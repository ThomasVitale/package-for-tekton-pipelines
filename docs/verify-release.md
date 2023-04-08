# Verifying the Tekton Pipelines Package Release

This package is published as an OCI artifact, signed with Sigstore [Cosign](https://docs.sigstore.dev/cosign/overview), and associated with a [SLSA Provenance](https://slsa.dev/provenance) attestation.

Using `cosign`, you can display the supply chain security related artifacts for the `ghcr.io/kadras-io/package-for-tekton-pipelines` images. Use the specific digest you'd like to verify.

```shell
cosign tree ghcr.io/kadras-io/package-for-tekton-pipelines
```

The result:

```shell
📦 Supply Chain Security Related artifacts for an image: ghcr.io/kadras-io/package-for-tekton-pipelines
└── 💾 Attestations for an image tag: ghcr.io/kadras-io/package-for-tekton-pipelines:sha256-61345735ba6f6a25f39395e8c1b1a7890a16123b448076b0d95a02eccccc0804.att
   └── 🍒 sha256:4e160b469483d5a8a1897ed8d9e6ee5964b19563481a8b17f23028832dfd6f39
└── 🔐 Signatures for an image tag: ghcr.io/kadras-io/package-for-tekton-pipelines:sha256-61345735ba6f6a25f39395e8c1b1a7890a16123b448076b0d95a02eccccc0804.sig
   └── 🍒 sha256:2e213286f7c7e9f39109913f1211d8e0e3edbc9f78ef23dfd43c213ee0dee079
```

You can verify the signature and its claims:

```shell
cosign verify \
   --certificate-identity-regexp https://github.com/kadras-io \
   --certificate-oidc-issuer https://token.actions.githubusercontent.com \
   ghcr.io/kadras-io/package-for-tekton-pipelines | jq
```

You can also verify the SLSA Provenance attestation associated with the image.

```shell
cosign verify-attestation --type slsaprovenance \
   --certificate-identity-regexp https://github.com/slsa-framework \
   --certificate-oidc-issuer https://token.actions.githubusercontent.com \
   ghcr.io/kadras-io/package-for-tekton-pipelines | jq .payload -r | base64 --decode | jq
```
