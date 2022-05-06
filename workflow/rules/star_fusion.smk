# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Jonas Almlöf"
__copyright__ = "Copyright 2022, Jonas Almlöf"
__email__ = "jonas.almlof@scilifelab.uu.se"
__license__ = "GPL-3"


rule star_fusion:
    input:
        fq1="prealignment/merged/{sample}_{type}_fastq1.fastq.gz",
        fq2="prealignment/merged/{sample}_{type}_fastq2.fastq.gz",
        genome_path=config["star_fusion"]["genome_path"],
    output:
        fusions=temp("fusions/star_fusion/{sample}_{type}/star-fusion.fusion_predictions.tsv"),
        fusions_abridged=temp("fusions/star_fusion/{sample}_{type}/star-fusion.fusion_predictions.abridged.tsv"),
        bam=temp("fusions/star_fusion/{sample}_{type}/Aligned.out.bam"),
        sj=temp("fusions/star_fusion/{sample}_{type}/SJ.out.tab"),
    params:
        output_dir=temp(directory("fusions/star_fusion/{sample}_{type}/")),
        extra=config.get("star_fusion", {}).get("extra", "--examine_coding_effect"),
    log:
        "fusions/star_fusion/{sample}_{type}.log",
    benchmark:
        repeat(
            "fusions/star_fusion/{sample}_{type}.benchmark.tsv",
            config.get("star_fusion", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("star_fusion", {}).get("threads", config["default_resources"]["threads"])
    resources:
        threads=config.get("star_fusion", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("star_fusion", {}).get("time", config["default_resources"]["time"]),
        mem_mb=config.get("star_fusion", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("star_fusion", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("star_fusion", {}).get("partition", config["default_resources"]["partition"]),
    container:
        config.get("star_fusion", {}).get("container", config["default_container"])
    conda:
        "../envs/star_fusion.yaml"
    message:
        "{rule}: Find RNA-fusion using star-fusion and put results in {output.fusions}"
    shell:
        "(STAR-Fusion "
        "--genome_lib_dir {input.genome_path} "
        "--left_fq {input.fq1} "
        "--right_fq {input.fq2} "
        "--output_dir {params.output_dir}) "
        "--CPU {threads} "
        "{extra} "
        "&> {log}"
