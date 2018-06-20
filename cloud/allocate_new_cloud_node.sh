#!/bin/bash
#
# Creates a new cloud VM and joins it to the cluster for which
# k8s-platform-master is the master node.  This script is intended to be run
# (infrequently) by a human as we add more monitoring services to the platform
# k8s cluster and start needing more and higher capacity compute nodes running
# in cloud.
#
# TODO: Make the node be a CoreOS node instead of Ubuntu

set -euxo pipefail

USAGE="USAGE: $0 <google-cloud-project> [extra args for gcloud compute instances create]"
PROJECT=${1:?Please specify the google cloud project: $USAGE}

# Now the entirety of $@ is arguments to pass to 'gcloud instances create'
shift

K8S_NODE_PREFIX="k8s-platform-cluster-node"

# Get a list of all VMs in the desired project that have a name in the right
# format (the format ends with a number) and find the lowest number that is not
# in the list (it may fill in a hole in the middle).
set +e  # The next command exits with nonzero, even when it works properly.
NEW_NODE_NUM=$(comm -1 -3 --nocheck-order \
    <(gcloud compute instances list \
        --project="${PROJECT}" \
        --filter="name~'${K8S_NODE_PREFIX}-\d+'" \
        --format='value(name)' \
      | sed -e 's/.*-//' \
      | sort -n) \
    <(seq 10000) \
  | head -n 1)
set -e

# Allocate a new VM with the right name.
NODE_NAME="${K8S_NODE_PREFIX}-${NEW_NODE_NUM}"
gcloud compute instances create "${NODE_NAME}" \
  --image "ubuntu-1710-artful-v20180612" \
  --image-project "ubuntu-os-cloud" \
  --project="${PROJECT}" \
  "$@"

sleep 120  # Wait for the node to appear
gcloud compute config-ssh --project="${PROJECT}"

# Ssh to the new node, install all the k8s binaries and make sure the node will
# be tagged as mlab/type:cloud when it joins.
gcloud compute ssh --project="${PROJECT}" "${NODE_NAME}" <<-\EOF
  sudo -s
  set -euxo pipefail
  apt-get update
  apt-get install -y docker.io

  apt-get update && apt-get install -y apt-transport-https curl
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
  echo deb http://apt.kubernetes.io/ kubernetes-xenial main >/etc/apt/sources.list.d/kubernetes.list
  apt-get update
  apt-get install -y kubelet kubeadm kubectl
  sed -e 's#KUBELET_KUBECONFIG_ARGS=#KUBELET_KUBECONFIG_ARGS=--node-labels="mlab/type=cloud" #' -i /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
  systemctl daemon-reload
  systemctl enable docker.service
  systemctl restart kubelet
EOF

# Ssh to k8s-platform-master and create a new token for login.

# TODO: This approach feels weird and brittle or unsafe or just architecturally
# wrong.  It works, but we would prefer some strategy where the node registers
# itself instead of requiring that the user running this script also have root
# on k8s-platform-master.  We should figure out how that should work and do that
# instead of the below.
JOIN_COMMAND=$(tail -n1 <(gcloud compute ssh --project="${PROJECT}" k8s-platform-master <<-EOF
  sudo -s
  set -euxo pipefail
  kubeadm token create --ttl=5m --print-join-command --description="Token for ${NODE_NAME}"
EOF
))

# Ssh to the new node and use the newly created token to join the cluster.
gcloud compute ssh --project="${PROJECT}" "${NODE_NAME}" <<-EOF
  sudo -s
  set -euxo pipefail
  sudo ${JOIN_COMMAND}
EOF
