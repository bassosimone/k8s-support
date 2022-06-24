local exp = import '../templates.jsonnet';
local expName = 'responsiveness';

exp.ExperimentNoIndex(expName, 'pusher-' + std.extVar('PROJECT_ID'), "none", [], true) + {
  spec+: {
    template+: {
      metadata+: {
        annotations+: {
          'secret.reloader.stakater.com/reload': 'measurement-lab-org-tls',
        },
      },
      spec+: {
        // NOTE: we override the containers to include only those named below.
        // Once this service has a dedicated experiment index assigned, we should
        // update the config to use all sidecar services.
        containers: [
          {
            args: [
              '-config-port=4043',
              '-config-name=$(MLAB_NODE_NAME)',
              '-public-port=443',
              '-public-name=$(MLAB_NODE_NAME)',
              '-cert-file=/certs/tls.crt',
              '-key-file=/certs/tls.key',
              '-listen-addr=localhost',
            ],
            env: [
              {
                name: 'MLAB_NODE_NAME',
                valueFrom: {
                  fieldRef: {
                    fieldPath: 'spec.nodeName',
                  },
                },
              },
              {
                name: 'PRIVATE_IP',
                valueFrom: {
                  fieldRef: {
                    fieldPath: 'status.podIP',
                  },
                },
              },
            ],
            image: 'soltesz/responsiveness-server:v0.1',
            name: 'responsiveness-server',
            command: [
              '/server/networkqualityd',
            ],
            volumeMounts: [
              {
                mountPath: '/certs',
                name: 'measurement-lab-org-tls',
                readOnly: true,
              },
            ],
          },
          {
            image: "soltesz/access-proxy:v0.0.3",
            name: "access-proxy",
            args: [
              '-forward=https://0.0.0.0:443@https://localhost:4043',
              '-token.required=false',
              '-txcontroller.device=net1',
              '-txcontroller.max-rate=1000000000',
              '-token.machine=$(NODE_NAME)',
              '-token.verify-key=/verify/jwk_sig_EdDSA_locate_20200409.pub',
              '-cert=/certs/tls.crt',
              '-key=/certs/tls.key',
            ],
            env: [
              {
                name: 'MLAB_NODE_NAME',
                valueFrom: {
                  fieldRef: {
                    fieldPath: 'spec.nodeName',
                  },
                },
              },
            ],
            volumeMounts: [
              {
                mountPath: '/certs',
                name: 'measurement-lab-org-tls',
                readOnly: true,
              },
              {
                mountPath: '/verify',
                name: 'locate-verify-keys',
                readOnly: true,
              },
            ],
          },
        ],
        // Use host network to listen on the machine IP address without
        // registering an experiment index yet.
        hostNetwork: true,
        volumes+: [
          {
            name: 'measurement-lab-org-tls',
            secret: {
              secretName: 'measurement-lab-org-tls',
            },
          },
          {
            name: 'locate-verify-keys',
            secret: {
              secretName: 'locate-verify-keys',
            },
          },
        ],
      },
    },
  },
}
