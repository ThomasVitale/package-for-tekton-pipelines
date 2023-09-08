# Tekton Pipelines

![Test Workflow](https://github.com/kadras-io/package-for-tekton-pipelines/actions/workflows/test.yml/badge.svg)
![Release Workflow](https://github.com/kadras-io/package-for-tekton-pipelines/actions/workflows/release.yml/badge.svg)
[![The SLSA Level 3 badge](https://slsa.dev/images/gh-badge-level3.svg)](https://slsa.dev/spec/v1.0/levels)
[![The Apache 2.0 license badge](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Follow us on Twitter](https://img.shields.io/static/v1?label=Twitter&message=Follow&color=1DA1F2)](https://twitter.com/kadrasIO)

A Carvel package for [Tekton Pipelines](https://tekton.dev/docs/pipelines), a cloud-native solution for building CI/CD systems.

## 🚀&nbsp; Getting Started

### Prerequisites

* Kubernetes 1.26+
* Carvel [`kctrl`](https://carvel.dev/kapp-controller/docs/latest/install/#installing-kapp-controller-cli-kctrl) CLI.
* Carvel [kapp-controller](https://carvel.dev/kapp-controller) deployed in your Kubernetes cluster. You can install it with Carvel [`kapp`](https://carvel.dev/kapp/docs/latest/install) (recommended choice) or `kubectl`.

  ```shell
  kapp deploy -a kapp-controller -y \
    -f https://github.com/carvel-dev/kapp-controller/releases/latest/download/release.yml
  ```

### Installation

Add the Kadras [package repository](https://github.com/kadras-io/kadras-packages) to your Kubernetes cluster:

  ```shell
  kctrl package repository add -r kadras-packages \
    --url ghcr.io/kadras-io/kadras-packages \
    -n kadras-packages --create-namespace
  ```

<details><summary>Installation without package repository</summary>
The recommended way of installing the Tekton Pipelines package is via the Kadras <a href="https://github.com/kadras-io/kadras-packages">package repository</a>. If you prefer not using the repository, you can add the package definition directly using <a href="https://carvel.dev/kapp/docs/latest/install"><code>kapp</code></a> or <code>kubectl</code>.

  ```shell
  kubectl create namespace kadras-packages
  kapp deploy -a tekton-pipelines-package -n kadras-packages -y \
    -f https://github.com/kadras-io/package-for-tekton-pipelines/releases/latest/download/metadata.yml \
    -f https://github.com/kadras-io/package-for-tekton-pipelines/releases/latest/download/package.yml
  ```
</details>

Install the Tekton Pipelines package:

  ```shell
  kctrl package install -i tekton-pipelines \
    -p tekton-pipelines.packages.kadras.io \
    -v ${VERSION} \
    -n kadras-packages
  ```

> **Note**
> You can find the `${VERSION}` value by retrieving the list of package versions available in the Kadras package repository installed on your cluster.
> 
>   ```shell
>   kctrl package available list -p tekton-pipelines.packages.kadras.io -n kadras-packages
>   ```

Verify the installed packages and their status:

  ```shell
  kctrl package installed list -n kadras-packages
  ```

## 📙&nbsp; Documentation

Documentation, tutorials and examples for this package are available in the [docs](docs) folder.
For documentation specific to Tekton Pipelines, check out [tekton.dev](https://tekton.dev).

## 🎯&nbsp; Configuration

The Tekton Pipelines package can be customized via a `values.yml` file.

  ```yaml
  opentelemetry:
    enable: true
    exporter:
      jaeger:
        endpoint: http://tempo.observability:14268/api/traces
  ```

Reference the `values.yml` file from the `kctrl` command when installing or upgrading the package.

  ```shell
  kctrl package install -i tekton-pipelines \
    -p tekton-pipelines.packages.kadras.io \
    -v ${VERSION} \
    -n kadras-packages \
    --values-file values.yml
  ```

### Values

The Tekton Pipelines package has the following configurable properties.

<details><summary>Configurable properties</summary>

| Config | Default | Description |
|-------|-------------------|-------------|
| `ca_cert_data` | `""` | PEM-encoded certificate data to trust TLS connections with a custom CA. |
| `policies.include` | `false` | Whether to include the out-of-the-box Kyverno policies to validate and secure the package installation. |
| `controllers.pipelines.replicas` | `1` | The number of replicas for the `tekton-pipelines-controller` Deployment. In order to enable high availability, it should be greater than 1. |
| `controllers.resolvers.replicas` | `1` | The number of replicas for the `tekton-pipelines-remote-resolvers` Deployment. In order to enable high availability, it should be greater than 1. |
| `controllers.resolvers.artifact_hub_url` | `https://artifacthub.io/` | The Artifact Hub API used by the Hub Resolver to resolve remote pipelines and tasks. |
| `webhook.minReplicas` | `1` | The minimum number of replicas as controlled by a HorizontalPodAutoscaler. In order to enable high availability, it should be greater than 1. |
| `opentelemetry.enable` | `false` | Setting this flag to `true` enables the OpenTelemetry instrumentation and exporter. |
| `opentelemetry.exporter.jaeger.endpoint` | `""` | The endpoint where the distributed tracing backend accepts OpenTelemetry traces using the Jaeger protocol. |
| `opentelemetry.exporter.jaeger.endpoint` | `""` | The username to access the distributed tracing backend. Optional. |
| `opentelemetry.exporter.jaeger.endpoint` | `""` | The password/token to authenticate with the distributed tracing backend. Optional. |

Default configuration stored in the `config-defaults` ConfigMap.

| Config | Default | Description |
|-------|-------------------|-------------|
| `config-defaults.default-timeout-minutes` | `60` | Number of minutes to use for TaskRun and PipelineRun, if none is specified. |
| `config-defaults.default-service-account` | `default` | Service account name to use for TaskRun and PipelineRun, if none is specified. |
| `config-defaults.default-managed-by-label-value` | `tekton-pipelines` | Value given to the `app.kubernetes.io/managed-by` label applied to all Pods created for TaskRuns. |
| `config-defaults.default-pod-template` | `""` | Pod template to use for TaskRun and PipelineRun. |
| `config-defaults.default-affinity-assistant-pod-template` | `""` | Pod template to use for affinity assistant Pods. |
| `config-defaults.default-task-run-workspace-binding` | `emptyDir: {}` | Workspace configuration provided for any Workspaces that a Task declares but that a TaskRun does not explicitly provide. |
| `config-defaults.default-max-matrix-combinations-count` | `256` | Maximum number of combinations from a Matrix, if none is specified. |
| `config-defaults.default-forbidden-env` | `""` | Comma seperated environment variables that cannot be overridden by PodTemplate. |
| `config-defaults.default-resolver-type` | `""` | The default resolver type to be used in the cluster. |

Events configuration stored in the `config-events` ConfigMap.

| Config | Default | Description |
|-------|-------------------|-------------|
| `config-events.sink` | `""` | CloudEvents sink to be used for TaskRun, PipelineRun, and CustomRun. If no sink is specified, no CloudEvent is generated. |

Leader election configuration stored in the `config-leader-election` ConfigMaps.

| Config | Default | Description |
|-------|-------------------|-------------|
| `config-leader-election.lease-duration` | `60s` | How long non-leaders will wait to try to acquire the lock; 15 seconds is the value used by core Kubernetes controllers. |
| `config-leader-election.renew-deadline` | `40s` | How long a leader will try to renew the lease before giving up; 10 seconds is the value used by core Kubernetes controllers. |
| `config-leader-election.retry-period` | `10s` | How long the leader election client waits between tries of actions; 2 seconds is the value used by core Kubernetes controllers. |
| `config-leader-election.buckets` | `1` | Yhe number of buckets used to partition key space of each Reconciler. If this number is M and the replica number of the controller is N, the N replicas will compete for the M buckets. The owner of a bucket will take care of the reconciling for the keys partitioned into that bucket. The maximum value of at this time is 10. |

Logging configuration stored in the `config-logging` ConfigMaps.

| Config | Default | Description |
|-------|-------------------|-------------|
| `config-logging.zap-logger-config` | `""` | Configuration for the zap logger used by all Tekton containers. |
| `config-logging.loglevel.controller` | `info` | Log level for the `tekton-pipelines-controller` and `tekton-pipelines-resolvers` Deployments. |
| `config-logging.loglevel.webhook` | `info` | Log level for the `tekton-pipelines-webhook` Deployment. |

Observability configuration stored in the `config-observability` ConfigMaps.

| Config | Default | Description |
|-------|-------------------|-------------|
| `config-observability.metrics.backend-destination` | `prometheus` | The system metrics destination. Supported values: `prometheus`, `stackdriver`. |
| `config-observability.metrics.stackdriver-project-id` | `""` | The Stackdriver project ID. When running on GCE, application default credentials will be used and metrics will be sent to the cluster's project if this field is not provided. |
| `config-observability.metrics.allow-stackdriver-custom-metrics` | `false` | Whether it is allowed to send metrics to Stackdriver using 'global' resource type and custom metric type. Ignore if `backend_destination` is not `stackdriver`. |
| `config-observability.metrics.taskrun.level` | `task` | Level for the TaskRun metrics controlling which labels are included: (taskrun, task, namespace), (task, namespace), (namespace). Supported values: `taskrun`, `task`, `namespace`. |
| `config-observability.metrics.taskrun.duration-type` | `histogram` | Duration type for the TaskRun metrics. Histogram value isn’t available when the `taskrun` level is selected. Supported values: `histogram`, `lastvalue`. |
| `config-observability.metrics.pipelinerun.level` | `pipeline` | Level for the PipelineRun metrics controlling which labels are included: (pipelinerun, pipeline, namespace), (pipeline, namespace), (namespace). Supported values: `pipelinerun`, `pipeline`, `namespace`. |
| `config-observability.metrics.pipelinerun.duration-type` | `histogram` | Duration type for the PipelineRun metrics. Histogram value isn’t available when the `pipelinerun` level is selected. Supported values: `histogram`, `lastvalue`. |

Feature flags configuration stored in the `feature-flags` ConfigMap.

| Config | Default | Description |
|-------|-------------------|-------------|
| `feature-flags.coschedule` | `workspaces` | Setting this flag will determine how PipelineRun Pods are scheduled with Affinity Assistant. Options: `workspaces`, `pipelineruns`, `isolate-pipelinerun`, `disabled`. |
| `feature-flags.disable-creds-init` | `false` | Setting this flag to `true` will prevent Tekton scanning attached service accounts and injecting any credentials it finds into your Steps. |
| `feature-flags.await-sidecar-readiness` | `true` | Setting this flag to `false` will stop Tekton from waiting for a TaskRun's sidecar containers to be running before starting the first step. This will allow Tasks to be run in environments that don't support the DownwardAPI volume type, but may lead to unintended behaviour if sidecars are used. |
| `feature-flags.running-in-environment-with-injected-sidecars` | `true` | This option should be set to `false` when Pipelines is running in a cluster that does not use injected sidecars such as Istio. Setting it to false should decrease the time it takes for a TaskRun to start running. For clusters that use injected sidecars, setting this option to false can lead to unexpected behavior. |
| `feature-flags.require-git-ssh-secret-known-hosts` | `true` | Setting this flag to `true` will require that any Git SSH Secret offered to Tekton must have known_hosts included. |
| `feature-flags.enable-tekton-oci-bundles` | `false` | Setting this flag to `true` enables the use of Tekton OCI bundle. This is an experimental feature and thus should still be considered an alpha feature. |
| `feature-flags.enable-api-fields` | `beta` | Setting this flag will determine which gated features are enabled. Support values: `stable`, `beta`, `alpha`. |
| `feature-flags.send-cloudevents-for-runs` | `false` | Setting this flag to `true` enables CloudEvents for CustomRuns and Runs, as long as a CloudEvents sink is configured in the `config-defaults` ConfigMap. |
| `feature-flags.trusted-resources-verification-no-match-policy` | `ignore` | This flag affects the behavior of taskruns and pipelineruns in cases where no VerificationPolicies match them. If it is set to `fail`, TaskRuns and PipelineRuns will fail verification if no matching policies are found. If it is set to `warn`, TaskRuns and PipelineRuns will run to completion if no matching policies are found, and an error will be logged. If it is set to `ignore`, TaskRuns and PipelineRuns will run to completion if no matching policies are found, and no error will be logged. |
| `feature-flags.enable-provenance-in-status` | `true` | Setting this flag to `true` enables populating the `provenance` field in TaskRun and PipelineRun status. This field contains metadata about resources used in the TaskRun/PipelineRun such as the source from where a remote Task/Pipeline definition was fetched. |
| `feature-flags.enforce-nonfalsifiability` | `none` | Setting this flag will determine how Tekton Pipelines will handle non-falsifiable provenance. If set to `spire`, then SPIRE will be used to ensure non-falsifiable provenance. If set to `none`, then Tekton will not have non-falsifiable provenance. This is an experimental feature and thus should still be considered an alpha feature. |
| `feature-flags.results-from` | `termination-message` | Setting this flag will determine how Tekton pipelines will handle extracting results from the task. Acceptable values are `termination-message` or `sidecar-logs`. `sidecar-logs` is an experimental feature and thus should still be considered an alpha feature. |
| `feature-flags.set-security-context` | `false` | Setting this flag to `true` will limit privileges for containers injected by Tekton into TaskRuns. This allows TaskRuns to run in namespaces with `restricted` pod security standards. Not all Kubernetes implementations support this option. |

Configuration for the bundle resolver stored in the `bundleresolver-config` ConfigMap.

| Config | Default | Description |
|-------|-------------------|-------------|
| `resolvers.bundleresolver-config.default-service-account` | `default` | The default name of the service account to use when constructing registry credentials. |
| `resolvers.bundleresolver-config.default-kind` | `task` | The default resource kind to pull out of the bundle. Supported values: `pipeline`, `task`. |

Configuration for the cluster resolver stored in the `cluster-resolver-config` ConfigMap.

| Config | Default | Description |
|-------|-------------------|-------------|
| `resolvers.cluster-resolver-config.default-kind` | `task` | The default resource kind to fetch. Supported values: `pipeline`, `task`. |
| `resolvers.cluster-resolver-config.default-namespace` | `""` | The default namespace to fetch resources from. |
| `resolvers.cluster-resolver-config.allowed-namespaces` | `""` | A comma-separated list of namespaces which the resolver is allowed to access. Defaults to empty, meaning all namespaces are allowed. |
| `resolvers.cluster-resolver-config.blocked-namespaces` | `""` | A comma-separated list of namespaces which the resolver is blocked from accessing. Defaults to empty, meaning all namespaces are allowed. |

Configuration for the git resolver stored in the `git-resolver-config` ConfigMap.

| Config | Default | Description |
|-------|-------------------|-------------|
| `resolvers.git-resolver-config.fetch-timeout` | `1m` | The maximum amount of time a single anonymous cloning resolution may take. |
| `resolvers.git-resolver-config.default-url` | `https://github.com/tektoncd/catalog.git` | The git url to fetch the remote resource from when using anonymous cloning. |
| `resolvers.git-resolver-config.default-revision` | `main` | The git revision to fetch the remote resource from with either anonymous cloning or the authenticated API. |
| `resolvers.git-resolver-config.scm-type` | `github` | The SCM type to use with the authenticated API. Supported values: `github`, `gitlab`, `gitea`, `bitbucketserver`, `bitbucketcloud`. |
| `resolvers.git-resolver-config.server-url` | `""` | The SCM server URL to use with the authenticated API. Not needed when using github.com, gitlab.com, or BitBucket Cloud. |
| `resolvers.git-resolver-config.api-token-secret-name` | `""` | The Kubernetes secret containing the API token for the SCM provider. Required when using the authenticated API. |
| `resolvers.git-resolver-config.api-token-secret-key` | `""` | The key in the API token secret containing the actual token. Required when using the authenticated API. |
| `resolvers.git-resolver-config.api-token-secret-namespace` | `default` | The namespace containing the API token secret. |
| `resolvers.git-resolver-config.default-org` | `""` | The default organization to look for repositories under when using the authenticated API. |

Configuration for the hub resolver stored in the `hubresolver-config` ConfigMap.

| Config | Default | Description |
|-------|-------------------|-------------|
| `resolvers.hubresolver-config.default-tekton-hub-catalog` | `Tekton` | The default Tekton Hub catalog from where to pull the resource. |
| `resolvers.hubresolver-config.default-artifact-hub-task-catalog` | `tekton-catalog-tasks` | The default Artifact Hub Task catalog from where to pull the resource. |
| `resolvers.hubresolver-config.default-artifact-hub-pipeline-catalog` | `tekton-catalog-pipelines` | The default Artifact Hub Pipeline catalog from where to pull the resource. |
| `resolvers.hubresolver-config.default-kind` | `task` | The default resource kind to fetch. Supported values: `pipeline`, `task`. |
| `resolvers.hubresolver-config.default-type` | `artifact` | The default hub from where to pull the resource. Supported values: `artifact`, `tekton`. |

Feature flags configuration stored in the `resolvers-feature-flags` ConfigMap.

| Config | Default | Description |
|-------|-------------------|-------------|
| `resolvers.resolvers-feature-flags.enable-bundles-resolver` | `true` | Setting this flag to `true` enables remote resolution of Tekton OCI bundles. |
| `resolvers.resolvers-feature-flags.enable-hub-resolver` | `true` | Setting this flag to `true` enables remote resolution of tasks and pipelines via the Tekton Hub. |
| `resolvers.resolvers-feature-flags.enable-git-resolver` | `true` | Setting this flag to `true` enables remote resolution of tasks and pipelines from Git repositories. |
| `resolvers.resolvers-feature-flags.enable-cluster-resolver` | `true` | Setting this flag to `true` enables remote resolution of tasks and pipelines from other namespaces within the cluster. |

</details>

## 🛡️&nbsp; Security

The security process for reporting vulnerabilities is described in [SECURITY.md](SECURITY.md).

## 🖊️&nbsp; License

This project is licensed under the **Apache License 2.0**. See [LICENSE](LICENSE) for more information.
