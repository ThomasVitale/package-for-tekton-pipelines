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
  kctrl package repository add -r kadras-repo \
    --url ghcr.io/kadras-io/kadras-packages \
    -n kadras-packages
  ```

Then, install the Tekton Pipelines package.

  ```shell
  kctrl package install -i tekton-pipelines \
    -p tekton-pipelines.packages.kadras.io \
    -v 0.43.2 \
    -n kadras-packages
  ```

### Verification

You can verify the list of installed Carvel packages and their status.

  ```shell
  kctrl package installed list -n kadras-packages
  ```

### Version

You can get the list of Tekton Pipelines versions available in the Kadras package repository.

  ```shell
  kctrl package available list -p tekton-pipelines.packages.kadras.io -n kadras-packages
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

| Config | Default | Description |
|-------|-------------------|-------------|
| `feature_flags.await_sidecar_readiness` | `true` | Setting this flag to 'false' will stop Tekton from waiting for a TaskRun's sidecar containers to be running before starting the first step. This will allow Tasks to be run in environments that don't support the DownwardAPI volume type, but may lead to unintended behaviour if sidecars are used. |
| `feature_flags.disable_affinity_assistant` | `false` | Setting this flag to 'true' will prevent Tekton to create an Affinity Assistant for every TaskRun sharing a PVC workspace. |
| `feature_flags.disable_creds_init` | `false` | Setting this flag to 'true' will prevent Tekton scanning attached service accounts and injecting any credentials it finds into your Steps. |
| `feature_flags.enable_api_fields` | `stable` | Setting this flag will determine which gated features are enabled. Either 'stable' or 'alpha'. |
| `feature_flags.enable_custom_tasks` | `false` | Setting this flag to 'true' enables the use of custom tasks from within pipelines. This is an experimental feature and thus should still be considered an alpha feature. |
| `feature_flags.enable_provenance_in_status` | `false` | Setting this flag to 'true' enables populating the 'provenance' field in TaskRun and PipelineRun status. This field contains metadata about resources used in the TaskRun/PipelineRun such as the source from where a remote Task/Pipeline definition was fetched. |
| `feature_flags.enable_tekton_oci_bundles` | `false` | Setting this flag to 'true' enables the use of Tekton OCI bundle. This is an experimental feature and thus should still be considered an alpha feature. |
| `feature_flags.require_git_ssh_secret_known_hosts` | `false` | Setting this flag to 'true' will require that any Git SSH Secret offered to Tekton must have known_hosts included. |
| `feature_flags.resource_verification_mode` | `skip` | Setting this flag to 'enforce' will enforce verification of tasks/pipeline. Failing to verify will fail the taskrun/pipelinerun. 'warn' will only log the err message and 'skip' will skip the whole verification. |
| `feature_flags.running_in_environment_with_injected_sidecars` | `true` | This option should be set to 'false' when Pipelines is running in a cluster that does not use injected sidecars such as Istio. Setting it to false should decrease the time it takes for a TaskRun to start running. For clusters that use injected sidecars, setting this option to false can lead to unexpected behavior. |
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
    -v 0.43.2 \
    -n kadras-packages \
    --values-file values.yml
  ```

## Upgrading

You can upgrade an existing package to a newer version using `kctrl`.

  ```shell
  kctrl package installed update -i tekton-pipelines \
    -v <new-version> \
    -n kadras-packages
  ```

You can also update an existing package with a newer `values.yml` file.

  ```shell
  kctrl package installed update -i tekton-pipelines \
    -n kadras-packages \
    --values-file values.yml
  ```

## Other

The recommended way of installing the Tekton Pipelines package is via the [Kadras package repository](https://github.com/kadras-io/kadras-packages). If you prefer not using the repository, you can install the package by creating the necessary Carvel `PackageMetadata` and `Package` resources directly using [`kapp`](https://carvel.dev/kapp/docs/latest/install) or `kubectl`.

  ```shell
  kubectl create namespace kadras-packages
  kapp deploy -a tekton-pipelines-package -n kadras-packages -y \
    -f https://github.com/kadras-io/package-for-tekton-pipelines/releases/latest/download/metadata.yml \
    -f https://github.com/kadras-io/package-for-tekton-pipelines/releases/latest/download/package.yml
  ```

## Support and Documentation

For support and documentation specific to Tekton Pipelines, check out [tekton.dev](https://tekton.dev).

## Supply Chain Security

This project is compliant with level 3 of the [SLSA Framework](https://slsa.dev).

<img src="https://slsa.dev/images/SLSA-Badge-full-level3.svg" alt="The SLSA Level 3 badge" width=200>
