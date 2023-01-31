K8S_VERSION=v1.26
DEV_NAMESPACE=carvel-dev

# Inner development loop
dev: package test/integration
	ytt -f test/integration/setup/assets/namespace.yml --data-value namespace=$(DEV_NAMESPACE) | kapp deploy -a ns -f- -y
	kubectl kuttl test --config test/integration/kuttl-test.yaml --namespace $(DEV_NAMESPACE) --start-kind=false --skip-cluster-delete --skip-delete

# Use ytt to generate an OpenAPI specification
schema:
	ytt -f package/config/values-schema.yml --data-values-schema-inspect -o openapi-v3 > package/config/schema-openapi.yml

# Check the ytt-annotated Kubernetes configuration
test-config:
	ytt --file package/config

# Run package integration tests
test-integration: test/integration
	kubectl kuttl test --config test/integration/kuttl-test.yaml --kind-config test/integration/setup/kind/$(K8S_VERSION)/kind-config.yaml
