# Configuring High Availability

High availability for Tekton Pipelines can be configured using different strategies for the controllers and the webhooks.

## High availability for the controllers

The Tekton Pipelines controllers support high availability following an active/active model based on the leader election strategy. Work is distributed among replicas based on buckets.

The leader election configuration is managed via the `config-leader-election-*` properties (customizing the `config-leader-election-*` ConfigMaps used by Tekton Pipelines).

```yaml
config-leader-election-controller:
  lease-duration: "60s"
  renew-deadline: "40s"
  retry-period: "10s"
  buckets: "1"
config-leader-election-events:
  lease-duration: "60s"
  renew-deadline: "40s"
  retry-period: "10s"
  buckets: "1"
config-leader-election-resolvers:
  lease-duration: "60s"
  renew-deadline: "40s"
  retry-period: "10s"
  buckets: "1"
```

By default, only one replica for each controller is deployed, meaning high availability is disabled. To enable high availability, it's recommended to configure at least 3 replicas for each controller.

```yaml
controllers:
  events:
    replicas: 3
  pipelines:
    replicas: 3
  resolvers:
    replicas: 3
```

You can disable high availability for the Tekton Pipelines controllers by scaling them down to 1 replica (default mode).

## High availability for the webhooks

High availability for the Tekton Pipelines webhook is controlled by a `HorizontalPodAutoscaler`, and requires [Metrics Server](https://github.com/kadras-io/package-for-metrics-server) to be installed in your Kubernetes cluster.

The following configuration enables the high availability setup so that the `HorizontalPodAutoscaler` ensures a minimum of 2 replicas. When more than 1 replica is configured, a `PodDisruptionBudget` is automatically created to prevent downtime during node unavailability.

```yaml
webhook:
  minReplicas: 2
```

Leader election can also be configured for the webhook via the `config-leader-election-webhook` properties (customizing the `config-leader-election-webhook` ConfigMap used by Tekton Pipelines).

```yaml
config-leader-election-webhook:
  lease-duration: "60s"
  renew-deadline: "40s"
  retry-period: "10s"
  buckets: "1"
```

For more information, check the Tekton Pipelines documentation for [high availability](https://tekton.dev/docs/pipelines/enabling-ha).
