# Configuring Observability

Monitor and observe the operation of Tekton Pipelines using logs, metrics, and traces.

## Logs

Log configuration for all Tekton Pipelines components is managed via the `logging.*` properties (customizing the `config-logging` ConfigMap in each namespace used by Tekton Pipelines).

This configuration can change the default log level for controllers and webhooks.

```yaml
logging:
  loglevel:
    controller: "info"
    webhook: "info"
```

The Tekton Pipelines components use the [uber-go/zap](https://github.com/uber-go/zap) logging library which can be customized via the [options](https://github.com/uber-go/zap/blob/master/config.go#L58) documented in the zap project.

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

For more information, check the Tekton Pipelines documentation for [logs](https://tekton.dev/docs/pipelines/logs).

## Metrics

Metrics configuration for all Tekton Pipelines components is managed via the `observability.metrics.*` properties (customizing the `config-observability` ConfigMap in each namespace used by Tekton Pipelines).

Tekton Pipelines supports Prometheus and Google Stackdriver for collecting metrics. Prometheus is the default format. This package comes pre-configured with the necessary annotations to let Prometheus scrape metrics automatically from all Tekton Pipelines components.

You can switch the implementation of the metrics to Google Stackdriver and configure that further.

```yaml
observability:
  metrics:
    backend_destination: "stackdriver"
    stackdriver_project_id: "<project-id>"
    allow_stackdriver_custom_metrics: "true"
```

Independently from the implementation, you have complete control over the granularity of the metrics.

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

For more information, check the Tekton Pipelines documentation for [metrics](https://tekton.dev/docs/pipelines/metrics).

## Traces

OpenTelemetry instrumentation is provided for all Tekton Pipelines controllers. By default, the instrumentation is disabled. Via the `opentelemetry.*` properties, you can enable the generation of traces and configure how they are exported to a distributed tracing backend.

Tekton Pipelines supports exporting traces to Jaeger via Thrift/HTTP. Username and password are optional settings.

```yaml
opentelemetry:
  enable: true
  exporter:
    jaeger:
      endpoint: "http://tempo.observability:14268/api/traces"
      username: "jon"
      password: "snow"
```

## Dashboards

If you use the Grafana observability stack, you can refer to this [dashboard](https://github.com/mgreau/tekton-pipelines-elastic-o11y) as a foundation to build your own.
