__author__ = "Jonas Almlöf"
__copyright__ = "Copyright 2022, Jonas Almlöf"
__email__ = "jonas.almlof@scilifelab.uu.se"
__license__ = "GPL-3"


rule fusioncatcher:
    input:
        fq1="prealignment/merged/{sample}_{type}_fastq1.fastq.gz",
        fq2="prealignment/merged/{sample}_{type}_fastq2.fastq.gz",
        genome_path=config.get("fusioncatcher", {}).get("genome_path", ""),
    output:
        fusions=temp("fusions/fusioncatcher/{sample}_{type}/final-list_candidate-fusion-genes.hg19.txt"),
        fusions_summary=temp("fusions/fusioncatcher/{sample}_{type}/summary_candidate_fusions.txt"),
    params:
        output_dir=temp(directory("fusions/fusioncatcher/{sample}_{type}/")),
        genome_path=config.get("fusioncatcher", {}).get("genome_path", ""),
        extra=config.get("fusioncatcher", {}).get("extra", "--visualization-sam"),
    log:
        "fusions/fusioncatcher/{sample}_{type}.final-list_candidate-fusion-genes.hg19.txt.log",
    benchmark:
        repeat(
            "fusions/fusioncatcher/{sample}_{type}.final-list_candidate-fusion-genes.hg19.txt.benchmark.tsv",
            config.get("fusioncatcher", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("fusioncatcher", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("fusioncatcher", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("fusioncatcher", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("fusioncatcher", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("fusioncatcher", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("fusioncatcher", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("fusioncatcher", {}).get("container", config["default_container"])
    conda:
        "../envs/fusioncatcher.yaml"
    message:
        "{rule}: find RNA-fusion using fusioncatcher and put results in {output.fusions}"
    shell:
        "(fusioncatcher "
        "-d {input.genome_path} "
        "--config=/usr/local/etc/configuration.cfg "
        "-i {input.fq1},{input.fq2} "
        "-o {params.output_dir} "
        "-p {threads} "
        "{params.extra}) &> {log}"
