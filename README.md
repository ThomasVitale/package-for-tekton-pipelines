# Tekton Pipelines

This project provides a [Carvel package](https://carvel.dev/kapp-controller/docs/latest/packaging) for [Tekton Pipelines](https://tekton.dev/docs/pipelines), a cloud-native solution for building CI/CD systems.

## Components

* Tekton Pipelines

## Prerequisites

* Kubernetes <= 1.24 (support for 1.25 is [in progress](https://github.com/tektoncd/pipeline/pull/5536)).
* Install the [`kctrl`](https://carvel.dev/kapp-controller/docs/latest/install/#installing-kapp-controller-cli-kctrl) CLI to manage Carvel packages in a convenient way.
* Ensure [kapp-controller](https://carvel.dev/kapp-controller) is deployed in your Kubernetes cluster. You can do that with Carvel
[`kapp`](https://carvel.dev/kapp/docs/latest/install) (recommended choice) or `kubectl`.

```shell
kapp deploy -a kapp-controller -y \
  -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
```

## Installation

You can install the Tekton Pipelines package directly or rely on the [Kadras package repository](https://github.com/arktonix/carvel-packages)
(recommended choice).

Follow the [instructions](https://github.com/arktonix/carvel-packages) to add the Kadras package repository to your Kubernetes cluster.

If you don't want to use the Kadras package repository, you can create the necessary `PackageMetadata` and
`Package` resources for the Tekton Pipelines package directly.

```shell
kubectl create namespace carvel-packages
kapp deploy -a tekton-pipelines-package -n carvel-packages -y \
    -f https://github.com/arktonix/package-for-tekton-pipelines/releases/latest/download/metadata.yml \
    -f https://github.com/arktonix/package-for-tekton-pipelines/releases/latest/download/package.yml
```

Either way, you can then install the Tekton Pipelines package using [`kctrl`](https://carvel.dev/kapp-controller/docs/latest/install/#installing-kapp-controller-cli-kctrl).

```shell
kctrl package install -i tekton-pipelines \
    -p tekton-pipelines.packages.kadras.io \
    -v 0.41.0 \
    -n carvel-packages
```

You can retrieve the list of available versions with the following command.

```shell
kctrl package available list -p tekton-pipelines.packages.kadras.io
```

You can check the list of installed packages and their status as follows.

```shell
kctrl package installed list -n carvel-packages
```

## Configuration

The Tekton Pipelines package has the following configurable properties.

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
| `feature_flags.disable_affinity_assistant` | `false` | Setting this flag to 'true' will prevent Tekton to create an Affinity Assistant for every TaskRun sharing a PVC workspace. |
| `feature_flags.disable_creds_init` | `false` | Setting this flag to 'true' will prevent Tekton scanning attached service accounts and injecting any credentials it finds into your Steps. |
| `feature_flags.await_sidecar_readiness` | `true` | Setting this flag to 'false' will stop Tekton from waiting for a TaskRun's sidecar containers to be running before starting the first step. This will allow Tasks to be run in environments that don't support the DownwardAPI volume type, but may lead to unintended behaviour if sidecars are used. |
| `feature_flags.running_in_environment_with_injected_sidecars` | `true` | This option should be set to 'false' when Pipelines is running in a cluster that does not use injected sidecars such as Istio. Setting it to false should decrease the time it takes for a TaskRun to start running. For clusters that use injected sidecars, setting this option to false can lead to unexpected behavior. |
| `feature_flags.require_git_ssh_secret_known_hosts` | `false` | Setting this flag to 'true' will require that any Git SSH Secret offered to Tekton must have known_hosts included. |
| `feature_flags.enable_tekton_oci_bundles` | `false` | Setting this flag to 'true' enables the use of Tekton OCI bundle. This is an experimental feature and thus should still be considered an alpha feature. |
| `feature_flags.enable_custom_tasks` | `false` | Setting this flag to 'true' enables the use of custom tasks from within pipelines. This is an experimental feature and thus should still be considered an alpha feature. |
| `feature_flags.enable_api_fields` | `stable` | Setting this flag will determine which gated features are enabled. Either 'stable' or 'alpha'. |
| `feature_flags.send_cloudevents_for_runs` | `false` | Setting this flag to 'true' enables CloudEvents for Runs, as long as a CloudEvents sink is configured in the config-defaults config map. |

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
```

Then, reference it from the `kctrl` command when installing or upgrading the package.

```shell
kctrl package install -i tekton-pipelines \
    -p tekton-pipelines.packages.kadras.io \
    -v 0.41.0 \
    -n carvel-packages \
    --values-file values.yml
```

## Documentation

For documentation specific to Tekton Pipelines, check out [tekton.dev](https://tekton.dev).

## Supply Chain Security

This project is compliant with level 2 of the [SLSA Framework](https://slsa.dev).

<img src="https://slsa.dev/images/SLSA-Badge-full-level2.svg" alt="The SLSA Level 2 badge" width=200>
