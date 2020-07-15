[
  {
    apiVersion: 'v1',
    kind: 'ServiceAccount',
    metadata: {
      name: 'fluentd',
      namespace: 'default',
    },
  },
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRole',
    metadata: {
      name: 'fluentd',
      namespace: 'default',
    },
    rules: [
      {
        apiGroups: [
          '',
        ],
        resources: [
          'pods',
          'namespaces',
        ],
        verbs: [
          'get',
          'list',
          'watch',
        ],
      },
    ],
  },
  {
    kind: 'ClusterRoleBinding',
    apiVersion: 'rbac.authorization.k8s.io/v1',
    metadata: {
      name: 'fluentd',
    },
    roleRef: {
      kind: 'ClusterRole',
      name: 'fluentd',
      apiGroup: 'rbac.authorization.k8s.io',
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: 'fluentd',
        namespace: 'default',
      },
    ],
  },
]
