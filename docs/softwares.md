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
