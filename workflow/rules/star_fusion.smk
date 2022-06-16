__author__ = "Jonas Almlöf"
__copyright__ = "Copyright 2022, Jonas Almlöf"
__email__ = "jonas.almlof@scilifelab.uu.se"
__license__ = "GPL-3"


rule star_fusion:
    input:
        fq1="prealignment/merged/{sample}_{type}_fastq1.fastq.gz",
        fq2="prealignment/merged/{sample}_{type}_fastq2.fastq.gz",
        genome_path=config.get("star_fusion", {}).get("genome_path", ""),
    output:
        bam=temp("fusions/star_fusion/{sample}_{type}/Aligned.out.bam"),
        fusions=temp("fusions/star_fusion/{sample}_{type}/star-fusion.fusion_predictions.tsv"),
        fusions_abridged=temp("fusions/star_fusion/{sample}_{type}/star-fusion.fusion_predictions.abridged.tsv"),
        sj=temp("fusions/star_fusion/{sample}_{type}/SJ.out.tab"),
    params:
        extra=config.get("star_fusion", {}).get("extra", "--examine_coding_effect"),
        output_dir=temp(directory("fusions/star_fusion/{sample}_{type}/")),
    log:
        "fusions/star_fusion/{sample}_{type}.star-fusion.fusion_predictions.tsv.log",
    benchmark:
        repeat(
            "fusions/star_fusion/{sample}_{type}.star-fusion.fusion_predictions.tsv.benchmark.tsv",
            config.get("star_fusion", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("star_fusion", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("star_fusion", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("star_fusion", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("star_fusion", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("star_fusion", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("star_fusion", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("star_fusion", {}).get("container", config["default_container"])
    conda:
        "../envs/star_fusion.yaml"
    message:
        "{rule}: find RNA-fusion using star-fusion and put results in {output.fusions}"
    shell:
        "(STAR-Fusion "
        "--genome_lib_dir {input.genome_path} "
        "--left_fq {input.fq1} "
        "--right_fq {input.fq2} "
        "--output_dir {params.output_dir} "
        "--CPU {threads} "
        "{params.extra}) &> {log}"


rule samtools_reheader:
    input:
        bam="fusions/star_fusion/{sample}_{type}/Aligned.out.bam",
    output:
        bam=temp("fusions/star_fusion/{sample}_{type}/Aligned.out.rg_header.bam"),
    params:
        RGID=config.get("samtools_reheader", {}).get("RGID", lambda wildcards: generate_read_group(wildcards)["ID"]),
        RGLB=config.get("samtools_reheader", {}).get("RGLB", lambda wildcards: generate_read_group(wildcards)["LB"]),
        RGPL=config.get("samtools_reheader", {}).get("RGPL", lambda wildcards: generate_read_group(wildcards)["PL"]),
        RGPU=config.get("samtools_reheader", {}).get("RGPU", lambda wildcards: generate_read_group(wildcards)["PU"]),
        RGSM=config.get("samtools_reheader", {}).get("RGSM", lambda wildcards: generate_read_group(wildcards)["SM"]),
    log:
        "fusions/star_fusion/{sample}_{type}/Aligned.out.rg_header.bam.log",
    benchmark:
        repeat(
            "fusions/star_fusion/{sample}_{type}/Aligned.out.rg_header.bam.benchmark.tsv",
            config.get("samtools_reheader", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("samtools_reheader", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("samtools_reheader", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("samtools_reheader", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("samtools_reheader", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("samtools_reheader", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("samtools_reheader", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("samtools_reheader", {}).get("container", config["default_container"])
    conda:
        "../envs/samtools.yaml"
    message:
        "{rule}: fix readgroup header in output from star-fusion and put results in {output.bam}"
    shell:
        "(samtools view -H {input.bam} | "
        "sed 's,^@RG.*,@RG\tID:{params.RGID}\tSM:{params.RGSM}\tLB:{params.RGLB}\tPL:{params.RGPL}\tPU:{params.RGPU},g' | "
        "samtools reheader - {input.bam} > {output.bam}) &> {log}"


rule picard_add_read_group:
    input:
        bam="fusions/star_fusion/{sample}_{type}/Aligned.out.rg_header.bam",
    output:
        bam=temp("fusions/star_fusion/{sample}_{type}/Aligned.out.rg.bam"),
    params:
        RGID=config.get("picard_add_read_group", {}).get("RGID", lambda wildcards: generate_read_group(wildcards)["ID"]),
        RGLB=config.get("picard_add_read_group", {}).get("RGLB", lambda wildcards: generate_read_group(wildcards)["LB"]),
        RGPL=config.get("picard_add_read_group", {}).get("RGPL", lambda wildcards: generate_read_group(wildcards)["PL"]),
        RGPU=config.get("picard_add_read_group", {}).get("RGPU", lambda wildcards: generate_read_group(wildcards)["PU"]),
        RGSM=config.get("picard_add_read_group", {}).get("RGSM", lambda wildcards: generate_read_group(wildcards)["SM"]),
    log:
        "fusions/star_fusion/{sample}_{type}/Aligned.out.rg.bam.log",
    benchmark:
        repeat(
            "fusions/star_fusion/{sample}_{type}/Aligned.out.rg.bam.benchmark.tsv",
            config.get("picard_add_read_group", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("picard_add_read_group", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("picard_add_read_group", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("picard_add_read_group", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("picard_add_read_group", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("picard_add_read_group", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("picard_add_read_group", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("picard_add_read_group", {}).get("container", config["default_container"])
    conda:
        "../envs/picard.yaml"
    message:
        "{rule}: fix readgroup in output from star-fusion and put results in {output.bam}"
    shell:
        "(picard AddOrReplaceReadGroups "
        "I={input.bam} "
        "O={output.bam} "
        "RGID={params.RGID} "
        "RGLB={params.RGLB} "
        "RGPL={params.RGPL} "
        "RGPU={params.RGPU} "
        "RGSM={params.RGSM}) &> {log}"
