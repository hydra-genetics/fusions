# Softwares used in the biomarker module

## [arriba](https://github.com/suhrig/arriba)
Call fusions in RNA data. Uses STAR aligner with only one pass alignment giving it low execution time. 

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__arriba__arriba#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__arriba__arriba#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__arriba#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__arriba#

---

## [arriba_draw_fusion](https://github.com/suhrig/arriba)
Produces illustation in pdf-format of the fusions called by arriba. The illustrations show coverage, support, direction, exon numbers, and known protein domains.

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__arriba__arriba_draw_fusion#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__arriba__arriba_draw_fusion#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__arriba_draw_fusion#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__arriba_draw_fusion#

---

## [filter_report_fuseq_wes](https://github.com/hydra-genetics/fusions/blob/develop/workflow/scripts/filter_report_fuseq_wes.py)
Python script for filtering and annotation of called fusions by fuseq_wes.

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__fuseq_wes__filter_report_fuseq_wes#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__fuseq_wes__filter_report_fuseq_wes#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__filter_report_fuseq_wes#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__filter_report_fuseq_wes#

---

## [fuseq_wes](https://github.com/nghiavtr/FuSeq_WES)
Call fusions in DNA data. Long execution time (single threaded) and memory heavy.

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__fuseq_wes__fuseq_wes#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__fuseq_wes__fuseq_wes#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__fuseq_wes#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__fuseq_wes#

---

## [fusioncatcher](https://github.com/ndaniel/fusioncatcher)
Call fusions in RNA data. The program has high sensitivity but also generated many false positives. FusionCatcher is also very computer intensive.

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__fusioncatcher__fusioncatcher#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__fusioncatcher__fusioncatcher#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__fusioncatcher#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__fusioncatcher#

---

## [gene_fuse](https://github.com/OpenGene/GeneFuse)
Call DNA fusions from short reads fastq-files. Only analyses specific genes that both have to be in the fusion to be called. Including large sets of genes give very long execution times.

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__gene_fuse__gene_fuse#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__gene_fuse__gene_fuse#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__gene_fuse#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__gene_fuse#

---

## gene_fuse_report
Simple filter of the DNA fusions called by gene_fuse based on the number of uniquely supporting reads. More advanced filtering can be needed depending on the panel used.

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__gene_fuse__gene_fuse_report#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__gene_fuse__gene_fuse_report#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__gene_fuse_report#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__gene_fuse_report#

---

## [juli_call](https://github.com/sgilab/JuLI)
Call fusions in DNA data. 

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__juli__juli_call#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__juli__juli_call#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__juli_call#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__juli_call#

---

## [juli_annotate](https://github.com/sgilab/JuLI)
Annotated fusions called in DNA data by JuLI.

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__juli__juli_annotate#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__juli__juli_annotate#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__juli_annotate#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__juli_annotate#

---

## [juli_filter](https://github.com/hydra-genetics/fusions/blob/develop/workflow/scripts/filter_juli.py)
Filter fusions called in DNA data by JuLI.

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__juli__juli_filter#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__juli__juli_filter#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__juli_filter#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__juli_filter#

---

## [star_fusion](https://github.com/STAR-Fusion/STAR-Fusion)
Call fusions in RNA data. The program uses STAR internally for alignment. Additional filtering is recommended. 

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__star_fusion__star_fusion#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__star_fusion__star_fusion#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__star_fusion#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__star_fusion#


## [ctat_splicing_call](https://github.com/TrinityCTAT/CTAT-SPLICING)
Uses CTAT-Splicing to find cancer relevant introns with abnormal splicing, like MET exon 14 skipping and EGFR exon deletions.

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__ctat_splicing__ctat_splicing_call#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__ctat_splicing__ctat_splicing_call#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__ctat_splicing_call#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__ctat_splicing_call#

## [ctat_splicing_filter](https://github.com/hydra-genetics/fusions/blob/develop/workflow/scripts/ctat_splicing_filter.py)
Filter CTAT‑Splicing results using a user‑defined filter file. If no filter file is provided, no filtering is performed.
The format of the filter file is 'gene\tvariant_name\tnr_unique_reads'. Variant_name can be left empty to get all records for that gene. Variant name can also be a list separated by ','. No filtering is performed if nr_unique_reads is set to 0.

### :snake: Rule

#SNAKEMAKE_RULE_SOURCE__ctat_splicing__ctat_splicing_filter#

#### :left_right_arrow: input / output files

#SNAKEMAKE_RULE_TABLE__ctat_splicing__ctat_splicing_filter#

### :wrench: Configuration

#### Software settings (`config.yaml`)

#CONFIGSCHEMA__ctat_splicing_filter#

#### Resources settings (`resources.yaml`)

#RESOURCESSCHEMA__ctat_splicing_filter#
