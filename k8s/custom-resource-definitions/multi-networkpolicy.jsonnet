{
  apiVersion: 'apiextensions.k8s.io/v1',
  kind: 'CustomResourceDefinition',
  metadata: {
    name: 'multi-networkpolicies.k8s.cni.cncf.io',
  },
  spec: {
    group: 'k8s.cni.cncf.io',
    scope: 'Namespaced',
    names: {
      plural: 'multi-networkpolicies',
      singular: 'multi-networkpolicy',
      kind: 'MultiNetworkPolicy',
      shortNames: [
        'multi-policy',
      ],
    },
    versions: [
      {
        name: 'v1beta1',
        served: true,
        storage: false,
        schema: {
          openAPIV3Schema: {
            description: 'MultiNetworkPolicy is a CRD schema to provide NetworkPolicy mechanism for net-attach-def which is specified by the Network Plumbing Working Group. MultiNetworkPolicy is identical to Kubernetes NetworkPolicy, See: https://kubernetes.io/docs/concepts/services-networking/network-policies/ .',
            properties: {
              spec: {
                description: 'Specification of the desired behavior for this MultiNetworkPolicy.',
                properties: {
                  egress: {
                    description: 'List of egress rules to be applied to the selected pods. Outgoing traffic is allowed if there are no NetworkPolicies selecting the pod (and cluster policy otherwise allows the traffic), OR if the traffic matches at least one egress rule across all of the NetworkPolicy objects whose podSelector matches the pod. If this field is empty then this NetworkPolicy limits all outgoing traffic (and serves solely to ensure that the pods it selects are isolated by default). This field is beta-level in 1.8',
                    items: {
                      description: "NetworkPolicyEgressRule describes a particular set of traffic that is allowed out of pods matched by a NetworkPolicySpec's podSelector. The traffic must match both ports and to. This type is beta-level in 1.8",
                      properties: {
                        ports: {
                          description: 'List of destination ports for outgoing traffic. Each item in this list is combined using a logical OR. If this field is empty or missing, this rule matches all ports (traffic not restricted by port). If this field is present and contains at least one item, then this rule allows traffic only if the traffic matches at least one port in the list.',
                          items: {
                            description: 'NetworkPolicyPort describes a port to allow traffic on',
                            properties: {
                              port: {
                                anyOf: [
                                  {
                                    type: 'integer',
                                  },
                                  {
                                    type: 'string',
                                  },
                                ],
                                description: 'The port on the given protocol. This can either be a numerical or named port on a pod. If this field is not provided, this matches all port names and numbers.',
                                'x-kubernetes-int-or-string': true,
                              },
                              protocol: {
                                description: 'The protocol (TCP, UDP, or SCTP) which traffic must match. If not specified, this field defaults to TCP.',
                                type: 'string',
                              },
                            },
                            type: 'object',
                          },
                          type: 'array',
                        },
                        to: {
                          description: 'List of destinations for outgoing traffic of pods selected for this rule. Items in this list are combined using a logical OR operation. If this field is empty or missing, this rule matches all destinations (traffic not restricted by destination). If this field is present and contains at least one item, this rule allows traffic only if the traffic matches at least one item in the to list.',
                          items: {
                            description: 'NetworkPolicyPeer describes a peer to allow traffic from. Only certain combinations of fields are allowed',
                            properties: {
                              ipBlock: {
                                description: 'IPBlock defines policy on a particular IPBlock. If this field is set then neither of the other fields can be.',
                                properties: {
                                  cidr: {
                                    description: "CIDR is a string representing the IP Block Valid examples are '192.168.1.1/24'",
                                    type: 'string',
                                  },
                                  except: {
                                    description: "Except is a slice of CIDRs that should not be included within an IP Block Valid examples are '192.168.1.1/24' Except values will be rejected if they are outside the CIDR range",
                                    items: {
                                      type: 'string',
                                    },
                                    type: 'array',
                                  },
                                },
                                required: [
                                  'cidr',
                                ],
                                type: 'object',
                              },
                              namespaceSelector: {
                                description: 'Selects Namespaces using cluster-scoped labels. This field follows standard label selector semantics; if present but empty, it selects all namespaces. \n If PodSelector is also set, then the NetworkPolicyPeer as a whole selects the Pods matching PodSelector in the Namespaces selected by NamespaceSelector. Otherwise it selects all Pods in the Namespaces selected by NamespaceSelector.',
                                properties: {
                                  matchExpressions: {
                                    description: 'matchExpressions is a list of label selector requirements. The requirements are ANDed.',
                                    items: {
                                      description: 'A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.',
                                      properties: {
                                        key: {
                                          description: 'key is the label key that the selector applies to.',
                                          type: 'string',
                                        },
                                        operator: {
                                          description: "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist.",
                                          type: 'string',
                                        },
                                        values: {
                                          description: 'values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.',
                                          items: {
                                            type: 'string',
                                          },
                                          type: 'array',
                                        },
                                      },
                                      required: [
                                        'key',
                                        'operator',
                                      ],
                                      type: 'object',
                                    },
                                    type: 'array',
                                  },
                                  matchLabels: {
                                    additionalProperties: {
                                      type: 'string',
                                    },
                                    description: "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is 'key', the operator is 'In', and the values array contains only 'value'. The requirements are ANDed.",
                                    type: 'object',
                                  },
                                },
                                type: 'object',
                              },
                              podSelector: {
                                description: "This is a label selector which selects Pods. This field follows standard label selector semantics; if present but empty, it selects all pods. \n If NamespaceSelector is also set, then the NetworkPolicyPeer as a whole selects the Pods matching PodSelector in the Namespaces selected by NamespaceSelector. Otherwise it selects the Pods matching PodSelector in the policy's own Namespace.",
                                properties: {
                                  matchExpressions: {
                                    description: 'matchExpressions is a list of label selector requirements. The requirements are ANDed.',
                                    items: {
                                      description: 'A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.',
                                      properties: {
                                        key: {
                                          description: 'key is the label key that the selector applies to.',
                                          type: 'string',
                                        },
                                        operator: {
                                          description: "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist.",
                                          type: 'string',
                                        },
                                        values: {
                                          description: 'values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.',
                                          items: {
                                            type: 'string',
                                          },
                                          type: 'array',
                                        },
                                      },
                                      required: [
                                        'key',
                                        'operator',
                                      ],
                                      type: 'object',
                                    },
                                    type: 'array',
                                  },
                                  matchLabels: {
                                    additionalProperties: {
                                      type: 'string',
                                    },
                                    description: "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is 'key', the operator is 'In', and the values array contains only 'value'. The requirements are ANDed.",
                                    type: 'object',
                                  },
                                },
                                type: 'object',
                              },
                            },
                            type: 'object',
                          },
                          type: 'array',
                        },
                      },
                      type: 'object',
                    },
                    type: 'array',
                  },
                  ingress: {
                    description: "List of ingress rules to be applied to the selected pods. Traffic is allowed to a pod if there are no NetworkPolicies selecting the pod (and cluster policy otherwise allows the traffic), OR if the traffic source is the pod's local node, OR if the traffic matches at least one ingress rule across all of the NetworkPolicy objects whose podSelector matches the pod. If this field is empty then this NetworkPolicy does not allow any traffic (and serves solely to ensure that the pods it selects are isolated by default)",
                    items: {
                      description: "NetworkPolicyIngressRule describes a particular set of traffic that is allowed to the pods matched by a NetworkPolicySpec's podSelector. The traffic must match both ports and from.",
                      properties: {
                        from: {
                          description: 'List of sources which should be able to access the pods selected for this rule. Items in this list are combined using a logical OR operation. If this field is empty or missing, this rule matches all sources (traffic not restricted by source). If this field is present and contains at least one item, this rule allows traffic only if the traffic matches at least one item in the from list.',
                          items: {
                            description: 'NetworkPolicyPeer describes a peer to allow traffic from. Only certain combinations of fields are allowed',
                            properties: {
                              ipBlock: {
                                description: 'IPBlock defines policy on a particular IPBlock. If this field is set then neither of the other fields can be.',
                                properties: {
                                  cidr: {
                                    description: "CIDR is a string representing the IP Block Valid examples are '192.168.1.1/24'",
                                    type: 'string',
                                  },
                                  except: {
                                    description: "Except is a slice of CIDRs that should not be included within an IP Block Valid examples are '192.168.1.1/24' Except values will be rejected if they are outside the CIDR range",
                                    items: {
                                      type: 'string',
                                    },
                                    type: 'array',
                                  },
                                },
                                required: [
                                  'cidr',
                                ],
                                type: 'object',
                              },
                              namespaceSelector: {
                                description: 'Selects Namespaces using cluster-scoped labels. This field follows standard label selector semantics; if present but empty, it selects all namespaces. \n If PodSelector is also set, then the NetworkPolicyPeer as a whole selects the Pods matching PodSelector in the Namespaces selected by NamespaceSelector. Otherwise it selects all Pods in the Namespaces selected by NamespaceSelector.',
                                properties: {
                                  matchExpressions: {
                                    description: 'matchExpressions is a list of label selector requirements. The requirements are ANDed.',
                                    items: {
                                      description: 'A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.',
                                      properties: {
                                        key: {
                                          description: 'key is the label key that the selector applies to.',
                                          type: 'string',
                                        },
                                        operator: {
                                          description: "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist.",
                                          type: 'string',
                                        },
                                        values: {
                                          description: 'values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.',
                                          items: {
                                            type: 'string',
                                          },
                                          type: 'array',
                                        },
                                      },
                                      required: [
                                        'key',
                                        'operator',
                                      ],
                                      type: 'object',
                                    },
                                    type: 'array',
                                  },
                                  matchLabels: {
                                    additionalProperties: {
                                      type: 'string',
                                    },
                                    description: "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is 'key', the operator is 'In', and the values array contains only 'value'. The requirements are ANDed.",
                                    type: 'object',
                                  },
                                },
                                type: 'object',
                              },
                              podSelector: {
                                description: "This is a label selector which selects Pods. This field follows standard label selector semantics; if present but empty, it selects all pods. \n If NamespaceSelector is also set, then the NetworkPolicyPeer as a whole selects the Pods matching PodSelector in the Namespaces selected by NamespaceSelector. Otherwise it selects the Pods matching PodSelector in the policy's own Namespace.",
                                properties: {
                                  matchExpressions: {
                                    description: 'matchExpressions is a list of label selector requirements. The requirements are ANDed.',
                                    items: {
                                      description: 'A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.',
                                      properties: {
                                        key: {
                                          description: 'key is the label key that the selector applies to.',
                                          type: 'string',
                                        },
                                        operator: {
                                          description: "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist.",
                                          type: 'string',
                                        },
                                        values: {
                                          description: 'values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.',
                                          items: {
                                            type: 'string',
                                          },
                                          type: 'array',
                                        },
                                      },
                                      required: [
                                        'key',
                                        'operator',
                                      ],
                                      type: 'object',
                                    },
                                    type: 'array',
                                  },
                                  matchLabels: {
                                    additionalProperties: {
                                      type: 'string',
                                    },
                                    description: "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is 'key', the operator is 'In', and the values array contains only 'value'. The requirements are ANDed.",
                                    type: 'object',
                                  },
                                },
                                type: 'object',
                              },
                            },
                            type: 'object',
                          },
                          type: 'array',
                        },
                        ports: {
                          description: 'List of ports which should be made accessible on the pods selected for this rule. Each item in this list is combined using a logical OR. If this field is empty or missing, this rule matches all ports (traffic not restricted by port). If this field is present and contains at least one item, then this rule allows traffic only if the traffic matches at least one port in the list.',
                          items: {
                            description: 'NetworkPolicyPort describes a port to allow traffic on',
                            properties: {
                              port: {
                                anyOf: [
                                  {
                                    type: 'integer',
                                  },
                                  {
                                    type: 'string',
                                  },
                                ],
                                description: 'The port on the given protocol. This can either be a numerical or named port on a pod. If this field is not provided, this matches all port names and numbers.',
                                'x-kubernetes-int-or-string': true,
                              },
                              protocol: {
                                description: 'The protocol (TCP, UDP, or SCTP) which traffic must match. If not specified, this field defaults to TCP.',
                                type: 'string',
                              },
                            },
                            type: 'object',
                          },
                          type: 'array',
                        },
                      },
                      type: 'object',
                    },
                    type: 'array',
                  },
                  podSelector: {
                    description: "This is a label selector which selects Pods. This field follows standard label selector semantics; if present but empty, it selects all pods. \n If NamespaceSelector is also set, then the NetworkPolicyPeer as a whole selects the Pods matching PodSelector in the Namespaces selected by NamespaceSelector. Otherwise it selects the Pods matching PodSelector in the policy's own Namespace.",
                    properties: {
                      matchExpressions: {
                        description: 'matchExpressions is a list of label selector requirements. The requirements are ANDed.',
                        items: {
                          description: 'A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.',
                          properties: {
                            key: {
                              description: 'key is the label key that the selector applies to.',
                              type: 'string',
                            },
                            operator: {
                              description: "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist.",
                              type: 'string',
                            },
                            values: {
                              description: 'values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.',
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                          },
                          required: [
                            'key',
                            'operator',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                      matchLabels: {
                        additionalProperties: {
                          type: 'string',
                          description: "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is 'key', the operator is 'In', and the values array contains only 'value'. The requirements are ANDed.",
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  policyTypes: {
                    description: "List of rule types that the NetworkPolicy relates to. Valid options are 'Ingress', 'Egress', or 'Ingress,Egress'. If this field is not specified, it will default based on the existence of Ingress or Egress rules; policies that contain an Egress section are assumed to affect Egress, and all policies (whether or not they contain an Ingress section) are assumed to affect Ingress. If you want to write an egress-only policy, you must explicitly specify policyTypes [ 'Egress' ]. Likewise, if you want to write a policy that specifies that no egress is allowed, you must specify a policyTypes value that include 'Egress' (since such a policy would not include an Egress section and would otherwise default to just [ 'Ingress' ]). This field is beta-level in 1.8",
                    items: {
                      description: 'Policy Type string describes the NetworkPolicy type This type is beta-level in 1.8',
                      type: 'string',
                    },
                    type: 'array',
                  },
                },
                required: [
                  'podSelector',
                ],
                type: 'object',
              },
            },
            type: 'object',
          },
        },
      },
      {
        name: 'v1beta2',
        served: true,
        storage: true,
        schema: {
          openAPIV3Schema: {
            description: 'MultiNetworkPolicy is a CRD schema to provide NetworkPolicy mechanism for net-attach-def which is specified by the Network Plumbing Working Group. MultiNetworkPolicy is identical to Kubernetes NetworkPolicy, See: https://kubernetes.io/docs/concepts/services-networking/network-policies/ .',
            properties: {
              spec: {
                description: 'Specification of the desired behavior for this MultiNetworkPolicy.',
                properties: {
                  egress: {
                    description: 'List of egress rules to be applied to the selected pods. Outgoing traffic is allowed if there are no NetworkPolicies selecting the pod (and cluster policy otherwise allows the traffic), OR if the traffic matches at least one egress rule across all of the NetworkPolicy objects whose podSelector matches the pod. If this field is empty then this NetworkPolicy limits all outgoing traffic (and serves solely to ensure that the pods it selects are isolated by default). This field is beta-level in 1.8',
                    items: {
                      description: "NetworkPolicyEgressRule describes a particular set of traffic that is allowed out of pods matched by a NetworkPolicySpec's podSelector. The traffic must match both ports and to. This type is beta-level in 1.8",
                      properties: {
                        ports: {
                          description: 'List of destination ports for outgoing traffic. Each item in this list is combined using a logical OR. If this field is empty or missing, this rule matches all ports (traffic not restricted by port). If this field is present and contains at least one item, then this rule allows traffic only if the traffic matches at least one port in the list.',
                          items: {
                            description: 'NetworkPolicyPort describes a port to allow traffic on',
                            properties: {
                              port: {
                                anyOf: [
                                  {
                                    type: 'integer',
                                  },
                                  {
                                    type: 'string',
                                  },
                                ],
                                description: 'The port on the given protocol. This can either be a numerical or named port on a pod. If this field is not provided, this matches all port names and numbers.',
                                'x-kubernetes-int-or-string': true,
                              },
                              endPort: {
                                type: 'integer',
                                format: 'int32',
                                description: 'If set, indicates that the range of ports from port to endPort, inclusive, should be allowed by the policy. This field cannot be defined if the port field is not defined or if the port field is defined as a named (string) port. The endPort must be equal or greater than port.',
                              },
                              protocol: {
                                description: 'The protocol (TCP, UDP, or SCTP) which traffic must match. If not specified, this field defaults to TCP.',
                                type: 'string',
                              },
                            },
                            type: 'object',
                          },
                          type: 'array',
                        },
                        to: {
                          description: 'List of destinations for outgoing traffic of pods selected for this rule. Items in this list are combined using a logical OR operation. If this field is empty or missing, this rule matches all destinations (traffic not restricted by destination). If this field is present and contains at least one item, this rule allows traffic only if the traffic matches at least one item in the to list.',
                          items: {
                            description: 'NetworkPolicyPeer describes a peer to allow traffic from. Only certain combinations of fields are allowed',
                            properties: {
                              ipBlock: {
                                description: 'IPBlock defines policy on a particular IPBlock. If this field is set then neither of the other fields can be.',
                                properties: {
                                  cidr: {
                                    description: "CIDR is a string representing the IP Block Valid examples are '192.168.1.1/24'",
                                    type: 'string',
                                  },
                                  except: {
                                    description: "Except is a slice of CIDRs that should not be included within an IP Block Valid examples are '192.168.1.1/24' Except values will be rejected if they are outside the CIDR range",
                                    items: {
                                      type: 'string',
                                    },
                                    type: 'array',
                                  },
                                },
                                required: [
                                  'cidr',
                                ],
                                type: 'object',
                              },
                              namespaceSelector: {
                                description: 'Selects Namespaces using cluster-scoped labels. This field follows standard label selector semantics; if present but empty, it selects all namespaces. \n If PodSelector is also set, then the NetworkPolicyPeer as a whole selects the Pods matching PodSelector in the Namespaces selected by NamespaceSelector. Otherwise it selects all Pods in the Namespaces selected by NamespaceSelector.',
                                properties: {
                                  matchExpressions: {
                                    description: 'matchExpressions is a list of label selector requirements. The requirements are ANDed.',
                                    items: {
                                      description: 'A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.',
                                      properties: {
                                        key: {
                                          description: 'key is the label key that the selector applies to.',
                                          type: 'string',
                                        },
                                        operator: {
                                          description: "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist.",
                                          type: 'string',
                                        },
                                        values: {
                                          description: 'values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.',
                                          items: {
                                            type: 'string',
                                          },
                                          type: 'array',
                                        },
                                      },
                                      required: [
                                        'key',
                                        'operator',
                                      ],
                                      type: 'object',
                                    },
                                    type: 'array',
                                  },
                                  matchLabels: {
                                    additionalProperties: {
                                      type: 'string',
                                    },
                                    description: "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is 'key', the operator is 'In', and the values array contains only 'value'. The requirements are ANDed.",
                                    type: 'object',
                                  },
                                },
                                type: 'object',
                              },
                              podSelector: {
                                description: "This is a label selector which selects Pods. This field follows standard label selector semantics; if present but empty, it selects all pods. \n If NamespaceSelector is also set, then the NetworkPolicyPeer as a whole selects the Pods matching PodSelector in the Namespaces selected by NamespaceSelector. Otherwise it selects the Pods matching PodSelector in the policy's own Namespace.",
                                properties: {
                                  matchExpressions: {
                                    description: 'matchExpressions is a list of label selector requirements. The requirements are ANDed.',
                                    items: {
                                      description: 'A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.',
                                      properties: {
                                        key: {
                                          description: 'key is the label key that the selector applies to.',
                                          type: 'string',
                                        },
                                        operator: {
                                          description: "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist.",
                                          type: 'string',
                                        },
                                        values: {
                                          description: 'values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.',
                                          items: {
                                            type: 'string',
                                          },
                                          type: 'array',
                                        },
                                      },
                                      required: [
                                        'key',
                                        'operator',
                                      ],
                                      type: 'object',
                                    },
                                    type: 'array',
                                  },
                                  matchLabels: {
                                    additionalProperties: {
                                      type: 'string',
                                    },
                                    description: "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is 'key', the operator is 'In', and the values array contains only 'value'. The requirements are ANDed.",
                                    type: 'object',
                                  },
                                },
                                type: 'object',
                              },
                            },
                            type: 'object',
                          },
                          type: 'array',
                        },
                      },
                      type: 'object',
                    },
                    type: 'array',
                  },
                  ingress: {
                    description: "List of ingress rules to be applied to the selected pods. Traffic is allowed to a pod if there are no NetworkPolicies selecting the pod (and cluster policy otherwise allows the traffic), OR if the traffic source is the pod's local node, OR if the traffic matches at least one ingress rule across all of the NetworkPolicy objects whose podSelector matches the pod. If this field is empty then this NetworkPolicy does not allow any traffic (and serves solely to ensure that the pods it selects are isolated by default)",
                    items: {
                      description: "NetworkPolicyIngressRule describes a particular set of traffic that is allowed to the pods matched by a NetworkPolicySpec's podSelector. The traffic must match both ports and from.",
                      properties: {
                        from: {
                          description: 'List of sources which should be able to access the pods selected for this rule. Items in this list are combined using a logical OR operation. If this field is empty or missing, this rule matches all sources (traffic not restricted by source). If this field is present and contains at least one item, this rule allows traffic only if the traffic matches at least one item in the from list.',
                          items: {
                            description: 'NetworkPolicyPeer describes a peer to allow traffic from. Only certain combinations of fields are allowed',
                            properties: {
                              ipBlock: {
                                description: 'IPBlock defines policy on a particular IPBlock. If this field is set then neither of the other fields can be.',
                                properties: {
                                  cidr: {
                                    description: "CIDR is a string representing the IP Block Valid examples are '192.168.1.1/24'",
                                    type: 'string',
                                  },
                                  except: {
                                    description: "Except is a slice of CIDRs that should not be included within an IP Block Valid examples are '192.168.1.1/24' Except values will be rejected if they are outside the CIDR range",
                                    items: {
                                      type: 'string',
                                    },
                                    type: 'array',
                                  },
                                },
                                required: [
                                  'cidr',
                                ],
                                type: 'object',
                              },
                              namespaceSelector: {
                                description: 'Selects Namespaces using cluster-scoped labels. This field follows standard label selector semantics; if present but empty, it selects all namespaces. \n If PodSelector is also set, then the NetworkPolicyPeer as a whole selects the Pods matching PodSelector in the Namespaces selected by NamespaceSelector. Otherwise it selects all Pods in the Namespaces selected by NamespaceSelector.',
                                properties: {
                                  matchExpressions: {
                                    description: 'matchExpressions is a list of label selector requirements. The requirements are ANDed.',
                                    items: {
                                      description: 'A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.',
                                      properties: {
                                        key: {
                                          description: 'key is the label key that the selector applies to.',
                                          type: 'string',
                                        },
                                        operator: {
                                          description: "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist.",
                                          type: 'string',
                                        },
                                        values: {
                                          description: 'values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.',
                                          items: {
                                            type: 'string',
                                          },
                                          type: 'array',
                                        },
                                      },
                                      required: [
                                        'key',
                                        'operator',
                                      ],
                                      type: 'object',
                                    },
                                    type: 'array',
                                  },
                                  matchLabels: {
                                    additionalProperties: {
                                      type: 'string',
                                    },
                                    description: "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is 'key', the operator is 'In', and the values array contains only 'value'. The requirements are ANDed.",
                                    type: 'object',
                                  },
                                },
                                type: 'object',
                              },
                              podSelector: {
                                description: "This is a label selector which selects Pods. This field follows standard label selector semantics; if present but empty, it selects all pods. \n If NamespaceSelector is also set, then the NetworkPolicyPeer as a whole selects the Pods matching PodSelector in the Namespaces selected by NamespaceSelector. Otherwise it selects the Pods matching PodSelector in the policy's own Namespace.",
                                properties: {
                                  matchExpressions: {
                                    description: 'matchExpressions is a list of label selector requirements. The requirements are ANDed.',
                                    items: {
                                      description: 'A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.',
                                      properties: {
                                        key: {
                                          description: 'key is the label key that the selector applies to.',
                                          type: 'string',
                                        },
                                        operator: {
                                          description: "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist.",
                                          type: 'string',
                                        },
                                        values: {
                                          description: 'values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.',
                                          items: {
                                            type: 'string',
                                          },
                                          type: 'array',
                                        },
                                      },
                                      required: [
                                        'key',
                                        'operator',
                                      ],
                                      type: 'object',
                                    },
                                    type: 'array',
                                  },
                                  matchLabels: {
                                    additionalProperties: {
                                      type: 'string',
                                    },
                                    description: "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is 'key', the operator is 'In', and the values array contains only 'value'. The requirements are ANDed.",
                                    type: 'object',
                                  },
                                },
                                type: 'object',
                              },
                            },
                            type: 'object',
                          },
                          type: 'array',
                        },
                        ports: {
                          description: 'List of ports which should be made accessible on the pods selected for this rule. Each item in this list is combined using a logical OR. If this field is empty or missing, this rule matches all ports (traffic not restricted by port). If this field is present and contains at least one item, then this rule allows traffic only if the traffic matches at least one port in the list.',
                          items: {
                            description: 'NetworkPolicyPort describes a port to allow traffic on',
                            properties: {
                              port: {
                                anyOf: [
                                  {
                                    type: 'integer',
                                  },
                                  {
                                    type: 'string',
                                  },
                                ],
                                description: 'The port on the given protocol. This can either be a numerical or named port on a pod. If this field is not provided, this matches all port names and numbers.',
                                'x-kubernetes-int-or-string': true,
                              },
                              endPort: {
                                type: 'integer',
                                format: 'int32',
                                description: 'If set, indicates that the range of ports from port to endPort, inclusive, should be allowed by the policy. This field cannot be defined if the port field is not defined or if the port field is defined as a named (string) port. The endPort must be equal or greater than port.',
                              },
                              protocol: {
                                description: 'The protocol (TCP, UDP, or SCTP) which traffic must match. If not specified, this field defaults to TCP.',
                                type: 'string',
                              },
                            },
                            type: 'object',
                          },
                          type: 'array',
                        },
                      },
                      type: 'object',
                    },
                    type: 'array',
                  },
                  podSelector: {
                    description: "This is a label selector which selects Pods. This field follows standard label selector semantics; if present but empty, it selects all pods. \n If NamespaceSelector is also set, then the NetworkPolicyPeer as a whole selects the Pods matching PodSelector in the Namespaces selected by NamespaceSelector. Otherwise it selects the Pods matching PodSelector in the policy's own Namespace.",
                    properties: {
                      matchExpressions: {
                        description: 'matchExpressions is a list of label selector requirements. The requirements are ANDed.',
                        items: {
                          description: 'A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.',
                          properties: {
                            key: {
                              description: 'key is the label key that the selector applies to.',
                              type: 'string',
                            },
                            operator: {
                              description: "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist.",
                              type: 'string',
                            },
                            values: {
                              description: 'values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.',
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                          },
                          required: [
                            'key',
                            'operator',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                      matchLabels: {
                        additionalProperties: {
                          type: 'string',
                          description: "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is 'key', the operator is 'In', and the values array contains only 'value'. The requirements are ANDed.",
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  policyTypes: {
                    description: "List of rule types that the NetworkPolicy relates to. Valid options are 'Ingress', 'Egress', or 'Ingress,Egress'. If this field is not specified, it will default based on the existence of Ingress or Egress rules; policies that contain an Egress section are assumed to affect Egress, and all policies (whether or not they contain an Ingress section) are assumed to affect Ingress. If you want to write an egress-only policy, you must explicitly specify policyTypes [ 'Egress' ]. Likewise, if you want to write a policy that specifies that no egress is allowed, you must specify a policyTypes value that include 'Egress' (since such a policy would not include an Egress section and would otherwise default to just [ 'Ingress' ]). This field is beta-level in 1.8",
                    items: {
                      description: 'Policy Type string describes the NetworkPolicy type This type is beta-level in 1.8',
                      type: 'string',
                    },
                    type: 'array',
                  },
                },
                required: [
                  'podSelector',
                ],
                type: 'object',
              },
            },
            type: 'object',
          },
        },
      },
    ],
  },
}
