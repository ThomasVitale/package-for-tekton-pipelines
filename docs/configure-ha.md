# Configuring High Availability

Tekton Pipelines can run in high availability using different strategies for controllers and webhooks.

## Controllers

High availability for controllers is provided via a leader election strategy.

First, define at least 3 replicas for each component.

```yaml
controller:
  replicas: 3
resolver:
  replicas: 3
```

Then, configure the leader election strategy based on your needs.

Leader election

```yaml
leader_election:
  lease_duration: "60s"
  renew_deadline: "40s"
  retry_period: "10s"
  buckets: "3"
```

You can disable the high availability setup (default mode) by scaling down each component's replicas to 1.

## Webhook

High availability for webhooks is provided via a combination of autoscaling and pod disruption budgets.

To enable the high availability setup for webhooks, apply the following configuration when installing
the package. By default, it's disabled.

```yaml
webhook:
  pdb:
    enable: true
```

For more information, check the Tekton Pipelines documentation for [high availability](https://tekton.dev/docs/pipelines/install/#configuring-high-availability).
