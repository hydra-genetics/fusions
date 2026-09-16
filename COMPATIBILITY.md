# Compatibility
## hydra-genetics/alignment

| alignment version | fusions version |
| --- | --- |
| v0.5.1 | v0.1.0 |
| migrate-to-snakemake9 (branch) | unreleased (Snakemake 9) |

## hydra-genetics/prealignment
| prealignment version | fusions version |
| --- | --- |
| v1.2.0 | v0.1.0 |
| migrate-to-snakemake9 (branch) | unreleased (Snakemake 9) |

> The Snakemake 9 row points at unreleased sibling branches: the latest releases
> (`alignment` v0.8.0, `prealignment` v1.4.0) are still Snakemake 7 and fail under Snakemake 9.
> Replace both with tag pins — here and in the `Compatibility` block of `README.md`, which the
> compatibility test parses — once those modules ship Snakemake 9 releases.
