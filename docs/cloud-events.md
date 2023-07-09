# CloudEvents

Tekton Pipelines can generate CloudEvents for `TaskRun`, `PipelineRun` and `CustomRun` lifecycle events.

The generation of events for `TaskRun` and `PipelineRun` is automatically enabled only if a URL has been configured for the CloudEvents sink. For example, you can use [Knative Eventing](https://knative.dev/docs/eventing) to set up a listener for such events.

```yaml
config-defaults:
  default-cloud-events-sink: "<cloud-events-sink-url>"
```

If you also want Tekton Pipelines to generate CloudEvents for `CustomRun`, you need to enable the dedicated feature.

```yaml
feature-flags:
  send-cloudevents-for-runs: "true"
```
