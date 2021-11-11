# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Jonas Almlöf"
__copyright__ = "Copyright 2021, Jonas Almlöf"
__email__ = "jonas.almlof@scilifelab.uu.se"
__license__ = "GPL-3"


rule gene_fuse:
    input:
        fastq1="prealignment/merged/{sample}_{type}_fastq1.fq.gz",
        fastq2="prealignment/merged/{sample}_{type}_fastq2.fq.gz",
        genes=config["gene_fuse"]["genes"],
        ref=config["reference"]["fasta"],
    output:
        html=temp("fusions/gene_fuse/{sample}_{type}_gene_fuse_report.html"),
        fusions=temp("fusions/gene_fuse/{sample}_{type}_gene_fuse_fusions.txt"),
    params:
        extra=config.get("gene_fuse", {}).get("extra", ""),
    log:
        "fusions/gene_fuse/{sample}_{type}.log",
    benchmark:
        repeat("fusions/gene_fuse/{sample}_{type}.benchmark.tsv", config.get("gene_fuse", {}).get("benchmark_repeats", 1))
    threads: config.get("gene_fuse", {}).get("threads", config["default_resources"]["threads"])
    resources:
        threads=config.get("gene_fuse", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("gene_fuse", {}).get("time", config["default_resources"]["time"]),
        mem_mb=config.get("gene_fuse", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("gene_fuse", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("gene_fuse", {}).get("partition", config["default_resources"]["partition"]),
    container:
        config.get("gene_fuse", {}).get("container", config["default_container"])
    conda:
        "../envs/gene_fuse.yaml"
    message:
        "{rule}: Find DNA-fusion using geneFuse in fusions/{rule}/{wildcards.sample}_{wildcards.type}"
    shell:
        "(genefuse -r {input.ref} -f {input.genes} -1 {input.fastq1} -2 {input.fastq2} -h {output.html} {params.extra} > {output.fusions}) &> {log}"
