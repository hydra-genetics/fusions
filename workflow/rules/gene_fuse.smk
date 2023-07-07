__author__ = "Jonas Almlöf"
__copyright__ = "Copyright 2021, Jonas Almlöf"
__email__ = "jonas.almlof@scilifelab.uu.se"
__license__ = "GPL-3"


rule gene_fuse:
    input:
        fastq1="prealignment/merged/{sample}_{type}_fastq1.fastq.gz",
        fastq2="prealignment/merged/{sample}_{type}_fastq2.fastq.gz",
        genes=config.get("gene_fuse", {}).get("genes", ""),
        ref=config.get("gene_fuse", {}).get("fasta", ""),
    output:
        html=temp("fusions/gene_fuse/{sample}_{type}_gene_fuse_report.html"),
        fusions=temp("fusions/gene_fuse/{sample}_{type}_gene_fuse_fusions.txt"),
    params:
        extra=config.get("gene_fuse", {}).get("extra", ""),
    log:
        "fusions/gene_fuse/{sample}_{type}_gene_fuse_fusions.txt.log",
    benchmark:
        repeat(
            "fusions/gene_fuse/{sample}_{type}_gene_fuse_fusions.txt.benchmark.tsv",
            config.get("gene_fuse", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("gene_fuse", {}).get("threads", config["default_resources"]["threads"])
    resources:
        threads=config.get("gene_fuse", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("gene_fuse", {}).get("time", config["default_resources"]["time"]),
        mem_mb=config.get("gene_fuse", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("gene_fuse", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("gene_fuse", {}).get("partition", config["default_resources"]["partition"]),
    container:
        config.get("gene_fuse", {}).get("container", config["default_container"])
    message:
        "{rule}: Find DNA-fusion using geneFuse in fusions/{rule}/{wildcards.sample}_{wildcards.type}"
    shell:
        "(genefuse -t {threads} "
        "-r {input.ref} "
        "-f {input.genes} "
        "-1 {input.fastq1} "
        "-2 {input.fastq2} "
        "-h {output.html} "
        "{params.extra} > "
        "{output.fusions}) "
        "&> {log}"


rule gene_fuse_report:
    input:
        fusions="fusions/gene_fuse/{sample}_{type}_gene_fuse_fusions.txt",
    output:
        fusions=temp("fusions/gene_fuse_report/{sample}_{type}_gene_fuse_fusions_report.txt"),
    params:
        unique_read_limit=config.get("gene_fuse_report", {}).get("unique_read_limit", 5),
    log:
        "fusions/gene_fuse_report/{sample}_{type}_gene_fuse_fusions_report.txt.log",
    benchmark:
        repeat(
            "fusions/gene_fuse_report/{sample}_{type}_gene_fuse_fusions_report.txt.benchmark.tsv",
            config.get("gene_fuse_report", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("gene_fuse_report", {}).get("threads", config["default_resources"]["threads"])
    resources:
        threads=config.get("gene_fuse_report", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("gene_fuse_report", {}).get("time", config["default_resources"]["time"]),
        mem_mb=config.get("gene_fuse_report", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("gene_fuse_report", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("gene_fuse_report", {}).get("partition", config["default_resources"]["partition"]),
    container:
        config.get("gene_fuse_report", {}).get("container", config["default_container"])
    message:
        "{rule}: Report true DNA-fusion found by geneFuse in fusions/{rule}/{wildcards.sample}_{wildcards.type}"
    shell:
        "(head -n 2 {input.fusions} "
        "| grep unique: || [[ $? == 1 ]] "
        "| awk -F'unique:|\)' '$2 > {params.unique_read_limit}' "
        "> {output.fusions}"
        ") &> {log}"
