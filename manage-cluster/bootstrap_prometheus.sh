#!/bin/bash
#
# TODO: add help text.


set -euxo pipefail

USAGE="$0 <cloud project>"
PROJECT=${1:?Please provide the cloud project: ${USAGE}}

# Source all of the global configuration variables.
source k8s_deploy.conf

# Create a string representing region and zone variable names for this project.
GCE_REGION_VAR="GCE_REGION_${PROJECT//-/_}"
GCE_ZONES_VAR="GCE_ZONES_${PROJECT//-/_}"

# Dereference the region and zones variables.
GCE_REGION="${!GCE_REGION_VAR}"
GCE_ZONES="${!GCE_ZONES_VAR}"

GCP_ARGS=("--project=${PROJECT}" "--quiet")

# Prometheus
CURRENT_PROMETHEUS_LB_IP=$(gcloud compute addresses list \
    --filter "name=${PROM_BASE_NAME}-lb AND region:${GCE_REGION}" \
    --format "value(address)" \
    "${GCP_ARGS[@]}" || true)
if [[ -n "${CURRENT_PROMETHEUS_LB_IP}" ]]; then
  PROMETHEUS_LB_IP="${CURRENT_PROMETHEUS_LB_IP}"
else
  gcloud compute addresses create "${PROM_BASE_NAME}-lb" \
      --region "${GCE_REGION}" \
      "${GCP_ARGS[@]}"
  PROMETHEUS_LB_IP=$(gcloud compute addresses list \
      --filter "name=${PROM_BASE_NAME}-lb AND region:${GCE_REGION}" \
      --format "value(address)" \
      "${GCP_ARGS[@]}")
fi

# Check the value of the existing IP address associated with the external load
# balancer name. If it's the same as the current/existing IP, then leave DNS
# alone, else delete the existing DNS RR and create a new one.
CURRENT_PROMETHEUS_LB_DNS_IP=$(gcloud dns record-sets list \
    --zone "${PROJECT}-measurementlab-net" \
    --name "${PROM_BASE_NAME}.${PROJECT}.measurementlab.net." \
    --format "value(rrdatas[0])" \
    "${GCP_ARGS[@]}" || true)
if [[ -z "${CURRENT_PROMETHEUS_LB_DNS_IP}" ]]; then
  # Add the record.
  gcloud dns record-sets transaction start \
      --zone "${PROJECT}-measurementlab-net" \
      "${GCP_ARGS[@]}"
  gcloud dns record-sets transaction add \
      --zone "${PROJECT}-measurementlab-net" \
      --name "${PROM_BASE_NAME}.${PROJECT}.measurementlab.net." \
      --type A \
      --ttl 300 \
      "${PROMETHEUS_LB_IP}" \
      "${GCP_ARGS[@]}"
  gcloud dns record-sets transaction execute \
      --zone "${PROJECT}-measurementlab-net" \
      "${GCP_ARGS[@]}"

elif [[ "${CURRENT_PROMETHEUS_LB_DNS_IP}" != "${PROMETHEUS_LB_IP}" ]]; then
  # Update the record.
  gcloud dns record-sets transaction start \
      --zone "${PROJECT}-measurementlab-net" \
      "${GCP_ARGS[@]}"
  gcloud dns record-sets transaction remove \
      --zone "${PROJECT}-measurementlab-net" \
      --name "${PROM_BASE_NAME}.${PROJECT}.measurementlab.net." \
      --type A \
      --ttl 300 \
      "${CURRENT_PROMETHEUS_LB_DNS_IP}" \
      "${GCP_ARGS[@]}"
  gcloud dns record-sets transaction add \
      --zone "${PROJECT}-measurementlab-net" \
      --name "${PROM_BASE_NAME}.${PROJECT}.measurementlab.net." \
      --type A \
      --ttl 300 \
      "${PROMETHEUS_LB_IP}" \
      "${GCP_ARGS[@]}"
  gcloud dns record-sets transaction execute \
      --zone "${PROJECT}-measurementlab-net" \
      "${GCP_ARGS[@]}"
fi

#######################################################
# DELETE THINGS
#######################################################
# Delete in the reverse order of creation.

# firewall
gcloud compute firewall-rules delete "${PROM_BASE_NAME}-external" \
    "${GCP_ARGS[@]}" || :
gcloud compute firewall-rules delete "${PROM_BASE_NAME}-health-checks" \
    "${GCP_ARGS[@]}" || :

# forwaring
gcloud compute forwarding-rules delete "${PROM_BASE_NAME}" \
    --region "${GCE_REGION}" "${GCP_ARGS[@]}" || :

# target pools
gcloud compute target-pools delete "${PROM_BASE_NAME}" \
    --region "${GCE_REGION}" "${GCP_ARGS[@]}" || :

# health checks
gcloud compute http-health-checks delete "${PROM_BASE_NAME}" "${GCP_ARGS[@]}" || :


#######################################################
# CREATE THINGS
#######################################################

# Create the http-health-check for the nodes in the target pool.
gcloud compute http-health-checks create "${PROM_BASE_NAME}" \
    --port 9090 \
    --request-path "/-/healthy" \
    "${GCP_ARGS[@]}"

# Create the target pool for our load balancer.
gcloud compute target-pools create "${PROM_BASE_NAME}" \
    --region "${GCE_REGION}" \
    --http-health-check="${PROM_BASE_NAME}" \
    --session-affinity="CLIENT_IP" \
    "${GCP_ARGS[@]}"

# Create the forwarding rule using the target pool we just created.
gcloud compute forwarding-rules create "${PROM_BASE_NAME}" \
    --region "${GCE_REGION}" \
    --ports 9090 \
    --address "${PROM_BASE_NAME}-lb" \
    --target-pool "${PROM_BASE_NAME}" \
    "${GCP_ARGS[@]}"

# Create a firewall rule allowing external access to ports:
#   TCP 22: SSH
#   TCP 9090: k8s API server
gcloud compute firewall-rules create "${PROM_BASE_NAME}-external" \
    --network "${GCE_NETWORK}" \
    --action "allow" \
    --rules "tcp:22,tcp:9090" \
    --source-ranges "0.0.0.0/0" \
    "${GCP_ARGS[@]}"

# Create firewall rule allowing GCP health checks.
# https://cloud.google.com/load-balancing/docs/health-checks#firewall_rules
gcloud compute firewall-rules create "${PROM_BASE_NAME}-health-checks" \
    --network "${GCE_NETWORK}" \
    --action "allow" \
    --rules "all" \
    --source-ranges "35.191.0.0/16,130.211.0.0/22" \
    --target-tags "${PROM_BASE_NAME}" \
    "${GCP_ARGS[@]}"

for zone in $GCE_ZONES; do

  gce_zone="${GCE_REGION}-${zone}"
  gce_name="${GCE_BASE_NAME}-${gce_zone}"

  GCE_ARGS=("--zone=${gce_zone}" "${GCP_ARGS[@]}")

  gcloud compute target-pools add-instances "${PROM_BASE_NAME}" \
      --instances "${gce_name}" \
      --instances-zone "${gce_zone}" \
      "${GCP_ARGS[@]}"

done
