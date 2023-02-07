# Verifying the Tekton Pipelines Package Release

This package is published as an OCI artifact, signed with Sigstore [Cosign](https://docs.sigstore.dev/cosign/overview), and associated with a [SLSA Provenance](https://slsa.dev/provenance) attestation.

Using `cosign`, you can display the supply chain security related artifacts for the `ghcr.io/kadras-io/package-for-tekton-pipelines` images. Use the specific digest you'd like to verify.

```shell
COSIGN_EXPERIMENTAL=1 cosign verify ghcr.io/kadras-io/package-for-tekton-pipelines
```

The result:

```shell
📦 Supply Chain Security Related artifacts for an image: ghcr.io/kadras-io/package-for-tekton-pipelines
└── 💾 Attestations for an image tag: ghcr.io/kadras-io/package-for-tekton-pipelines:sha256-e8df926c1f03f381e54a6a421722c82e9988899dc3b54a234ca84aa5d8f959ac.att
   └── 🍒 sha256:3d3d05042dedd4ba564bf04757c88151fcaba70cf2b46a18db7d8e63b306525d
└── 🔐 Signatures for an image tag: ghcr.io/kadras-io/package-for-tekton-pipelines:sha256-e8df926c1f03f381e54a6a421722c82e9988899dc3b54a234ca84aa5d8f959ac.sig
   └── 🍒 sha256:1e9d9684f180aadaa8006013f6e8858d1d412c168f0257caef359b4c557a9065
```

You can verify the signature and its claims:

```shell
COSIGN_EXPERIMENTAL=1 cosign verify ghcr.io/kadras-io/package-for-tekton-pipelines
```

You can also verify the SLSA Provenance attestation associated with the image.

```shell
COSIGN_EXPERIMENTAL=1 cosign verify-attestation --type slsaprovenance ghcr.io/kadras-io/package-for-tekton-pipelines 
```
