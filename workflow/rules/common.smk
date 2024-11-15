__author__ = "Jonas A"
__copyright__ = "Copyright 2021, Jonas A"
__email__ = "jonas.almlof@igp.uu.se"
__license__ = "GPL-3"

import pandas as pd
from snakemake.utils import validate
from snakemake.utils import min_version

from hydra_genetics.utils.resources import load_resources
from hydra_genetics.utils.samples import *
from hydra_genetics.utils.units import *

min_version("7.8.0")

### Set and validate config file

if not workflow.overwrite_configfiles:
    sys.exit("At least one config file must be passed using --configfile/--configfiles, by command line or a profile!")


validate(config, schema="../schemas/config.schema.yaml")
config = load_resources(config, config["resources"])
validate(config, schema="../schemas/resources.schema.yaml")


### Read and validate samples file

samples = pd.read_table(config["samples"], dtype=str).set_index("sample", drop=False)
validate(samples, schema="../schemas/samples.schema.yaml")

### Read and validate units file

units = pandas.read_table(config["units"], dtype=str).set_index(["sample", "type", "flowcell", "lane"], drop=False)
validate(units, schema="../schemas/units.schema.yaml")

### Set wildcard constraints


wildcard_constraints:
    sample="|".join(samples.index),
    unit="N|T|R",


def compile_output_list(wildcards):
    files = {
        "fusions/gene_fuse_report": ["_gene_fuse_fusions_report.txt"],
    }
    output_files = [
        "%s/%s_T%s" % (prefix, sample, suffix)
        for prefix in files.keys()
        for sample in get_samples(samples)
        if "T" in get_unit_types(units, sample)
        for suffix in files[prefix]
    ]
    files = {
        "fusions/filter_fuseq_wes": [".fuseq_wes.report.csv"],
    }
    output_files.extend(
        [
            "%s/%s_T%s" % (prefix, sample, suffix)
            for prefix in files.keys()
            for sample in get_samples(samples)
            if "T" in get_unit_types(units, sample)
            for suffix in files[prefix]
        ]
    )
    files = {
        "fusions/juli_call": [".annotated.filtered.txt"],
    }
    output_files.extend(
        [
            "%s/%s_T%s" % (prefix, sample, suffix)
            for prefix in files.keys()
            for sample in get_samples(samples)
            if "T" in get_unit_types(units, sample)
            for suffix in files[prefix]
        ]
    )
    files = {
        "fusions/arriba_draw_fusion": [".pdf"],
    }
    output_files.extend(
        [
            "%s/%s_R%s" % (prefix, sample, suffix)
            for prefix in files.keys()
            for sample in get_samples(samples)
            if "R" in get_unit_types(units, sample)
            for suffix in files[prefix]
        ]
    )
    files = {
        "fusions/star_fusion": ["star-fusion.fusion_predictions.tsv"],
        "fusions/fusioncatcher": ["final-list_candidate-fusion-genes.hg19.txt"],
    }
    output_files.extend(
        [
            "%s/%s_R/%s" % (prefix, sample, suffix)
            for prefix in files.keys()
            for sample in get_samples(samples)
            if "R" in get_unit_types(units, sample)
            for suffix in files[prefix]
        ]
    )
    return output_files
