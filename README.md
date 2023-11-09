<p align="center">
<a href="https://hydra-genetics-fusions.readthedocs.io">https://hydra-genetics-fusions.readthedocs.io</a>
</p>

# <img src="https://github.com/hydra-genetics/fusions/blob/develop/images/hydragenetics.png" width=40 /> hydra-genetics/fusions

Snakemake module containing fusion callers for both DNA and RNA.

![Lint](https://github.com/hydra-genetics/fusions/actions/workflows/lint.yaml/badge.svg?branch=develop)
![Snakefmt](https://github.com/hydra-genetics/fusions/actions/workflows/snakefmt.yaml/badge.svg?branch=develop)

![pycodestyle](https://github.com/hydra-genetics/fusions/actions/workflows/pycodestyl.yaml/badge.svg?branch=develop)
![pytest](https://github.com/hydra-genetics/fusions/actions/workflows/pytest.yaml/badge.svg?branch=develop)


[![License: GPL-3](https://img.shields.io/badge/License-GPL3-yellow.svg)](https://opensource.org/licenses/gpl-3.0.html)

## :speech_balloon: Introduction

The module consists of fusion caller for RNA and DNA. The programs use `.fastq`-files or `.bam`-files as input.

## :heavy_exclamation_mark: Dependencies

[![hydra-genetics](https://img.shields.io/badge/hydragenetics-0.15.0-blue)](https://github.com/hydra-genetics/)
[![pandas](https://img.shields.io/badge/pandas-1.3.1-blue)](https://pandas.pydata.org/)
[![python](https://img.shields.io/badge/python-3.8-blue)](https://www.python.org/)
[![snakemake](https://img.shields.io/badge/snakemake-7.13.0-blue)](https://snakemake.readthedocs.io/en/stable/)
[![singularity](https://img.shields.io/badge/singularity-3.0.0-blue)](https://sylabs.io/docs/)
[![drmaa](https://img.shields.io/badge/drmaa-0.7.9-blue)](https://pypi.org/project/drmaa/)
[![tabulate](https://img.shields.io/badge/tabulate-0.8.10-blue)](https://pypi.org/project/tabulate/)

---
## OBSERVE
The small integration test is not run in this module as the programs need large test files to run.
---

## :school_satchel: Preparations

### Sample data

### Sample and unit data

Input data should be added to [`samples.tsv`](https://github.com/hydra-genetics/prealignment/blob/develop/config/samples.tsv)
and [`units.tsv`](https://github.com/hydra-genetics/prealignment/blob/develop/config/units.tsv).
The following information need to be added to these files:

| Column Id | Description |
| --- | --- |
| **`samples.tsv`** |
| sample | unique sample/patient id, one per row |
| **`units.tsv`** |
| sample | same sample/patient id as in `samples.tsv` |
| type | data type identifier (one letter), can be one of **T**umor, **N**ormal, **R**NA |
| platform | type of sequencing platform, e.g. `NovaSeq` |
| machine | specific machine id, e.g. NovaSeq instruments have `@Axxxxx` |
| flowcell | identifier of flowcell used |
| lane | flowcell lane number |
| barcode | sequence library barcode/index, connect forward and reverse indices by `+`, e.g. `ATGC+ATGC` |
| fastq1/2 | absolute path to forward and reverse reads |
| adapter | adapter sequences to be trimmed, separated by comma |

### Reference data

The fusion callers all have there own references needed to run the programs. Please refer to each program in order to obtain the correct reference or use the this [documentation](https://twist-solid.readthedocs.io/en/latest/references/#downloadable-reference-files) for reference files used in one pipeline using this module.

## :rocket: Usage

To use this module in your workflow, follow the description in the
[snakemake docs](https://snakemake.readthedocs.io/en/stable/snakefiles/modularization.html#modules).
Add the module to your `Snakefile` like so:

```bash
module fusions:
    snakefile:
        github(
            "hydra-genetics/fusions",
            path="workflow/Snakefile",
            tag="v0.1.0",
        )
    config:
        config


use rule * from fusions as fusions_*
```

The workflow is designed for WGS data meaning huge datasets which require a lot of compute power. For
HPC clusters, it is recommended to use a cluster profile and run something like:

```bash
snakemake -s /path/to/Snakefile --profile my-awesome-profile
```

### Input files

| File | Description |
|---|---|
| `alignment/samtools_merge_bam/{sample}_{type}.bam` | merged and sorted dna data from the alignment module |
| `alignment/star/{sample}_{type}.bam` | aligned rna data from the alignmnet module |
| `prealignment/merged/{sample}_{type}_fastq1.fastq.gz` | trimmed and merged fastq-file from the prealignment module |
| `prealignment/merged/{sample}_{type}_fastq2.fastq.gz` | trimmed and merged fastq-file from the prealignment module |

### Output files

The following output files should be targeted via another rule:

| File | Description |
|---|---|
| `fusions/arriba/{sample}_{type}.fusions.tsv` | RNA fusion predictions from Arriba |
| `fusions/star_fusion/{sample}_{type}/star-fusion.fusion_predictions.tsv"` | RNA fusion predictions from StarFusion |
| `fusions/fusioncatcher/{sample}_{type}/final-list_candidate-fusion-genes.hg19.txt` | RNA fusion predictions from FusionCatcher |
| `fusions/gene_fuse_report/{sample}_{type}_gene_fuse_fusions_report.txt` | filtered DNA fusion predictions from GeneFuse |
| `fusions/filter_fuseq_wes/{sample}_{type}.fuseq_wes.report.csv` | filtered DNA fusion predictions from FuseqWES |

## :judge: Rule Graph

![rule_graph](https://github.com/hydra-genetics/fusions/blob/develop/images/hydragenetics.png)
