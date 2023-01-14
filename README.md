# Tekton Pipelines

<a href="https://slsa.dev/spec/v0.1/levels"><img src="https://slsa.dev/images/gh-badge-level3.svg" alt="The SLSA Level 3 badge"></a>

This project provides a [Carvel package](https://carvel.dev/kapp-controller/docs/latest/packaging) for [Tekton Pipelines](https://tekton.dev/docs/pipelines), a cloud-native solution for building CI/CD systems.

## Prerequisites

* Kubernetes 1.24+
* Carvel [`kctrl`](https://carvel.dev/kapp-controller/docs/latest/install/#installing-kapp-controller-cli-kctrl) CLI.
* Carvel [kapp-controller](https://carvel.dev/kapp-controller) deployed in your Kubernetes cluster. You can install it with Carvel [`kapp`](https://carvel.dev/kapp/docs/latest/install) (recommended choice) or `kubectl`.

  ```shell
  kapp deploy -a kapp-controller -y \
    -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
  ```

## Installation

First, add the [Kadras package repository](https://github.com/kadras-io/kadras-packages) to your Kubernetes cluster.

  ```shell
  kubectl create namespace kadras-packages
  kctrl package repository add -r kadras-packages \
    --url ghcr.io/kadras-io/kadras-packages \
    -n kadras-packages
  ```

Then, install the Tekton Pipelines package.

  ```shell
  kctrl package install -i tekton-pipelines \
    -p tekton-pipelines.packages.kadras.io \
    -v ${VERSION} \
    -n kadras-packages
  ```

You can find the `${VERSION}` value by retrieving the list of package versions available in the Kadras package repository installed on your cluster.

  ```shell
  kctrl package available list -p tekton-pipelines.packages.kadras.io -n kadras-packages
  ```

<details><summary>Installation without package repository</summary>
<p>
The recommended way of installing the Tekton Pipelines package is via the <a href="https://github.com/kadras-io/kadras-packages">Kadras package repository</a>. If you prefer not using the repository, you can install the package by creating the necessary Carvel <code>PackageMetadata</code> and <code>Package</code> resources directly using <a href="https://carvel.dev/kapp/docs/latest/install"><code>kapp</code></a> or <code>kubectl</code>.

  ```shell
  kubectl create namespace kadras-packages
  kapp deploy -a tekton-pipelines-package -n kadras-packages -y \
    -f https://github.com/kadras-io/package-for-tekton-pipelines/releases/latest/download/metadata.yml \
    -f https://github.com/kadras-io/package-for-tekton-pipelines/releases/latest/download/package.yml
  ```
</p>
</details>

### Verification

You can verify the installed packages and their status as follows.

  ```shell
  kctrl package installed list -n kadras-packages
  ```

## Configuration

The Tekton Pipelines package has the following configurable properties.

| Config | Default | Description |
|-------|-------------------|-------------|
| `ca_cert_data` | `""` | Self-signed certificate for the private container registry storing the images used in Tekton Tasks (PEM-encoded format). |

Default configuration stored in the `config-defaults` ConfigMap.

| Config | Default | Description |
|-------|-------------------|-------------|
| `defaults.timeout_minutes` | `60` | Number of minutes to use for TaskRun and PipelineRun, if none is specified. |
| `defaults.service_account` | `default` | Service account name to use for TaskRun and PipelineRun, if none is specified. |
| `defaults.managed_by_label_value` | `tekton-pipelines` | Value given to the 'app.kubernetes.io/managed-by' label applied to all Pods created for TaskRuns. |
| `defaults.pod_template` | `""` | Pod template to use for TaskRun and PipelineRun. |
| `defaults.affinity_assistant_pod_template` | `""` | Pod template to use for affinity assistant pods. |
| `defaults.cloud_events_sink` | `"` | CloudEvents sink to be used for TaskRun and PipelineRun. If no sink is specified, no CloudEvent is generated. |
| `defaults.task_run_workspace_binding` | `""` | Workspace configuration provided for any Workspaces that a Task declares but that a TaskRun does not explicitly provide. |
| `defaults.max_matrix_combinations_count` | `256` | Maximum number of combinations from a Matrix, if none is specified. |
| `defaults.forbidden_env` | `""` | Comma seperated environment variables that cannot be overridden by PodTemplate. |

Leader election configuration stored in the `config-leader-election` ConfigMaps.

| Config | Default | Description |
|-------|-------------------|-------------|
| `leader_election.lease_duration` | `""` | How long non-leaders will wait to try to acquire the lock; 15 seconds is the value used by core Kubernetes controllers. |
| `leader_election.renew_deadline` | `""` | How long a leader will try to renew the lease before giving up; 10 seconds is the value used by core Kubernetes controllers. |
| `leader_election.retry_period` | `""` | How long the leader election client waits between tries of actions; 2 seconds is the value used by core Kubernetes controllers. |
| `leader_election.buckets` | `""` | Yhe number of buckets used to partition key space of each Reconciler. If this number is M and the replica number of the controller is N, the N replicas will compete for the M buckets. The owner of a bucket will take care of the reconciling for the keys partitioned into that bucket. |

Logging configuration stored in the `config-logging` ConfigMaps.

| Config | Default | Description |
|-------|-------------------|-------------|
| `logging.zap_logger_config` | `""` | Configuration for the zap logger used by all Tekton containers. |
| `logging.loglevel.controller` | `info` | Log level for the tekton-pipelines-controller and tekton-pipelines-resolvers Deployments. |
| `logging.loglevel.webhook` | `info` | Log level for the tekton-pipelines-webhook Deployment. |

Observability configuration stored in the `config-observability` ConfigMaps.

| Config | Default | Description |
|-------|-------------------|-------------|
| `observability.metrics.backend_destination` | `prometheus` | The system metrics destination. Supported values: `prometheus`, `stackdriver`. |
| `observability.metrics.stackdriver_project_id` | `""` | The Stackdriver project ID. When running on GCE, application default credentials will be used and metrics will be sent to the cluster's project if this field is not provided. |
| `observability.metrics.allow_stackdriver_custom_metrics` | `false` | Whether it is allowed to send metrics to Stackdriver using 'global' resource type and custom metric type. Ignore if `backend_destination` is not `stackdriver`. |
| `observability.metrics.taskrun.level` | `task` | Level for the TaskRun metrics controlling which labels are included: (taskrun, task, namespace), (task, namespace), (namespace). Supported values: `taskrun`, `task`, `namespace`. |
| `observability.metrics.taskrun.duration_type` | `histogram` | Duration type for the TaskRun metrics. Histogram value isn’t available when the `taskrun` level is selected. Supported values: `histogram`, `lastvalue`. |
| `observability.metrics.pipelinerun.level` | `pipeline` | Level for the PipelineRun metrics controlling which labels are included: (pipelinerun, pipeline, namespace), (pipeline, namespace), (namespace). Supported values: `pipelinerun`, `pipeline`, `namespace`. |
| `observability.metrics.pipelinerun.duration_type` | `histogram` | Duration type for the PipelineRun metrics. Histogram value isn’t available when the `pipelinerun` level is selected. Supported values: `histogram`, `lastvalue`. |

Feature flags configuration stored in the `feature-flags` ConfigMap.

| Config | Default | Description |
|-------|-------------------|-------------|
| `feature_flags.disable_affinity_assistant` | `false` | Setting this flag to 'true' will prevent Tekton to create an Affinity Assistant for every TaskRun sharing a PVC workspace. |
| `feature_flags.disable_creds_init` | `false` | Setting this flag to 'true' will prevent Tekton scanning attached service accounts and injecting any credentials it finds into your Steps. |
| `feature_flags.await_sidecar_readiness` | `true` | Setting this flag to 'false' will stop Tekton from waiting for a TaskRun's sidecar containers to be running before starting the first step. This will allow Tasks to be run in environments that don't support the DownwardAPI volume type, but may lead to unintended behaviour if sidecars are used. |
| `feature_flags.running_in_environment_with_injected_sidecars` | `true` | This option should be set to 'false' when Pipelines is running in a cluster that does not use injected sidecars such as Istio. Setting it to false should decrease the time it takes for a TaskRun to start running. For clusters that use injected sidecars, setting this option to false can lead to unexpected behavior. |
| `feature_flags.require_git_ssh_secret_known_hosts` | `false` | Setting this flag to 'true' will require that any Git SSH Secret offered to Tekton must have known_hosts included. |
| `feature_flags.enable_tekton_oci_bundles` | `false` | Setting this flag to 'true' enables the use of Tekton OCI bundle. This is an experimental feature and thus should still be considered an alpha feature. |
| `feature_flags.enable_custom_tasks` | `false` | Setting this flag to 'true' enables the use of custom tasks from within pipelines. This is an experimental feature and thus should still be considered an alpha feature. |
| `feature_flags.enable_api_fields` | `stable` | Setting this flag will determine which gated features are enabled. Either 'stable' or 'alpha'. |
| `feature_flags.send_cloudevents_for_runs` | `false` | Setting this flag to 'true' enables CloudEvents for Runs, as long as a CloudEvents sink is configured in the config-defaults config map. |
| `feature_flags.resource_verification_mode` | `skip` | Setting this flag to 'enforce' will enforce verification of tasks/pipeline. Failing to verify will fail the taskrun/pipelinerun. 'warn' will only log the err message and 'skip' will skip the whole verification. |
| `feature_flags.enable_provenance_in_status` | `false` | Setting this flag to 'true' enables populating the 'provenance' field in TaskRun and PipelineRun status. This field contains metadata about resources used in the TaskRun/PipelineRun such as the source from where a remote Task/Pipeline definition was fetched. |
| `feature_flags.embedded_status` | `full` | Setting this flag to `full` to enable full embedding of `TaskRun` and `Run` statuses in the `PipelineRun` status. Set it to `minimal` to populate the `ChildReferences` field in the `PipelineRun` status with name, kind, and API version information for each `TaskRun` and `Run` in the `PipelineRun` instead. Set it to `both` to do both. |
| `feature_flags.custom_task_version` | `v1alpha1` | Setting this flag will determine the version for custom tasks created by PipelineRuns. Supported values: `v1alpha1`, `v1beta1`. |

You can define your configuration in a `values.yml` file.

  ```yaml
  defaults:
    timeout_minutes: "60"  
    service_account: "default"
    managed_by_label_value: "tekton-pipelines"
    pod_template: ""
    affinity_assistant_pod_template: ""
    cloud_events_sink: ""
    task_run_workspace_binding: ""
    max_matrix_combinations_count: "256"
  
  leader_election:
    lease_duration: ""
    renew_deadline: ""
    retry_period: ""
    buckets: ""
  
  logging:
    zap_logger_config: ""
    loglevel:
      controller: "info"
      webhook: "info"
  
  observability:
    metrics:
      backend_destination: "prometheus"
      stackdriver_project_id: ""
      allow_stackdriver_custom_metrics: "false"
      taskrun:
        level: "task"
        duration_type: "histogram"
      pipelinerun:
        level: "pipeline"
        duration_type: "histogram"

  feature_flags:
    disable_affinity_assistant: "false"
    disable_creds_init: "false"
    await_sidecar_readiness: "true"
    running_in_environment_with_injected_sidecars: "true"
    require_git_ssh_secret_known_hosts: "false"
    enable_tekton_oci_bundles: "false"
    enable_custom_tasks: "false"
    enable_api_fields: "stable"
    send_cloudevents_for_runs: "false"
    embedded_status: "full"
    custom_task_version: "v1alpha1"
  ```

Then, reference it from the `kctrl` command when installing or upgrading the package.

  ```shell
  kctrl package install -i tekton-pipelines \
    -p tekton-pipelines.packages.kadras.io \
    -v ${VERSION} \
    -n kadras-packages \
    --values-file values.yml
  ```

## Support and Documentation

Documentation, tutorials and additional information about this package are available on [kadras.io](https://kadras.io).
For support and documentation specific to Tekton Pipelines, check out [tekton.dev](https://tekton.dev).

## Supply Chain Security

This project is compliant with level 3 of the [SLSA Framework](https://slsa.dev).

<img src="https://slsa.dev/images/SLSA-Badge-full-level3.svg" alt="The SLSA Level 3 badge" width=200>
