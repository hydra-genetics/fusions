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
        # Extra output files that should be removed
        coj=temp("fusions/star_fusion/{sample}_{type}/Chimeric.out.junction"),
        log1=temp("fusions/star_fusion/{sample}_{type}/Log.final.out"),
        log2=temp("fusions/star_fusion/{sample}_{type}/Log.out"),
        log3=temp("fusions/star_fusion/{sample}_{type}/Log.progress.out"),
        rpg=temp("fusions/star_fusion/{sample}_{type}/ReadsPerGene.out.tab"),
        sc=temp(directory("fusions/star_fusion/{sample}_{type}/_starF_checkpoints")),
        sfp=temp(directory("fusions/star_fusion/{sample}_{type}/star-fusion.preliminary")),
        sg=temp(directory("fusions/star_fusion/{sample}_{type}/_STARgenome")),
        sp=temp(directory("fusions/star_fusion/{sample}_{type}/_STARpass1")),
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
