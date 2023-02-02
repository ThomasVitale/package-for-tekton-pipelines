# Configuring Observability

This page explains how to configure logs and metrics for Tekton Pipelines.

## Logs

You can configure the log level for controllers and webhooks.

```yaml
logging:
  loglevel:
    controller: "info"
    webhook: "info"
```

The log format can also be customized (see [uber-go/zap](https://github.com/uber-go/zap) for more information on the configuration schema).

```yaml
logging:
  zap_logger_config: |
    {
        "level": "info",
        "development": false,
        "sampling": {
            "initial": 100,
            "thereafter": 100
        },
        "outputPaths": ["stdout"],
        "errorOutputPaths": ["stderr"],
        "encoding": "json",
        "encoderConfig": {
            "timeKey": "timestamp",
            "levelKey": "severity",
            "nameKey": "logger",
            "callerKey": "caller",
            "messageKey": "message",
            "stacktraceKey": "stacktrace",
            "lineEnding": "",
            "levelEncoder": "",
            "timeEncoder": "iso8601",
            "durationEncoder": "",
            "callerEncoder": ""
        }
    }
```

For more information, check the Tekton Pipelines documentation for [logs](https://tekton.dev/docs/pipelines/logs/).

## Metrics

This package comes preconfigured with the necessary annotation to let Prometheus scrape metrics
from all controllers and webhooks part of Tekton Pipelines.

By default, Tekton Pipelines exposes metrics in the Prometheus format, but you can switch
the implementation to Google Stackdriver and configure that further.

```yaml
observability:
  metrics:
    backend_destination: "stackdriver"
    stackdriver_project_id: "<project-id>"
    allow_stackdriver_custom_metrics: "true"
```

Independently from the implementation, you have full control on the granularity of the metrics.

```yaml
observability:
  metrics:
    taskrun:
      level: "taskrun"
      duration_type: "histogram"

    pipelinerun:
      level: "pipelinerun"
      duration_type: "histogram"
```

For more information, check the Tekton Pipelines documentation for [metrics](https://tekton.dev/docs/pipelines/metrics/).

## Traces

The Tekton Pipelines controller can be configured to enable its OpenTelemetry instrumentation to generate traces and export them suing the Jaeger Thrift protocol. Username and password are optional settings.

By default, the distributed tracing support is disabled.

```yaml
opentelemetry:
  enable: true
  exporter:
    jaeger:
      endpoint: "http://tempo.observability.svc.cluster.local:14268/api/traces"
      username: "jon"
      password: "snow"
```

## Example with Grafana OSS

When using the Grafana OSS observability stack, you might refer to this [dashboard](https://github.com/mgreau/tekton-pipelines-elastic-o11y) as a foundation to build your own.
