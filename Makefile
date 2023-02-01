K8S_VERSION=v1.26
DEV_NAMESPACE=carvel-dev

# Prepare cluster for development workflow
prepare: test/integration/setup
	ytt -f test/integration/setup/assets/namespace.yml --data-value namespace=$(DEV_NAMESPACE) | kapp deploy -a ns -f- -y
	ytt -f test/integration/setup/assets/rbac.yml --data-value namespace=$(DEV_NAMESPACE) | kapp deploy -a rbac -f- -y
	kubectl config set-context --current --namespace=$(DEV_NAMESPACE)

# Inner development loop
dev: package
	cd package && kctrl dev -f package-resources.yml --local -y

# Process the configuration manifests with ytt
ytt:
	ytt --file package/config

# Use ytt to generate an OpenAPI specification
schema:
	ytt -f package/config/values-schema.yml --data-values-schema-inspect -o openapi-v3 > package/config/schema-openapi.yml

# Check the ytt-annotated Kubernetes configuration and its validation
test-config:
	ytt --file package/config | kubeconform -ignore-missing-schemas -summary

# Run package integration tests
test-integration: test/integration
	kubectl kuttl test --config test/integration/kuttl-test.yaml --kind-config test/integration/setup/kind/$(K8S_VERSION)/kind-config.yaml
