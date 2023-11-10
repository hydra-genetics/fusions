__author__ = "Martin Rippin"
__copyright__ = "Copyright 2022, Martin Rippin"
__email__ = "martin.rippin@scilifelab.uu.se"
__license__ = "GPL-3"


rule arriba:
    input:
        bam="alignment/star/{sample}_{type}.bam",
        bai="alignment/star/{sample}_{type}.bam.bai",
        ass=config.get("arriba", {}).get("assembly", ""),
        gtf=config.get("arriba", {}).get("gtf", ""),
        bl=config.get("arriba", {}).get("blacklist", ""),
    output:
        fusions=temp("fusions/arriba/{sample}_{type}.fusions.tsv"),
        fusions_dis=temp("fusions/arriba/{sample}_{type}.fusions.discarded.tsv"),
    params:
        extra=config.get("arriba", {}).get("extra", ""),
    log:
        "fusions/arriba/{sample}_{type}.fusions.tsv.log",
    benchmark:
        repeat(
            "fusions/arriba/{sample}_{type}.fusions.tsv.benchmark.tsv",
            config.get("arriba", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("arriba", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("arriba", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("arriba", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("arriba", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("arriba", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("arriba", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("arriba", {}).get("container", config["default_container"])
    message:
        "{rule}: find rna fusions in {input.bam}"
    shell:
        "(arriba "
        "-a {input.ass} "
        "-b {input.bl} "
        "-g {input.gtf} "
        "-x {input.bam} "
        "-o {output.fusions} "
        "-O {output.fusions_dis}) &> {log}"


rule arriba_draw_fusion:
    input:
        bam="alignment/star/{sample}_{type}.bam",
        bai="alignment/star/{sample}_{type}.bam.bai",
        cytobands=config.get("arriba_draw_fusion", {}).get("cytobands", ""),
        fusions="fusions/arriba/{sample}_{type}.fusions.tsv",
        gtf=config.get("arriba_draw_fusion", {}).get("gtf", ""),
        protein_domains=config.get("arriba_draw_fusion", {}).get("protein_domains", ""),
    output:
        pdf=temp("fusions/arriba_draw_fusion/{sample}_{type}.pdf"),
    log:
        "fusions/arriba_draw_fusion/{sample}_{type}.pdf.log",
    benchmark:
        repeat(
            "fusions/arriba_draw_fusion/{sample}_{type}.pdf.benchmark.tsv",
            config.get("arriba_draw_fusion", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("arriba_draw_fusion", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("arriba_draw_fusion", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("arriba_draw_fusion", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("arriba_draw_fusion", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("arriba_draw_fusion", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("arriba_draw_fusion", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("arriba_draw_fusion", {}).get("container", config["default_container"])
    message:
        "{rule}: draw rna fusions into {output.pdf}"
    shell:
        "(draw_fusions.R "
        "--fusions={input.fusions} "
        "--alignments={input.bam} "
        "--output={output.pdf} "
        "--annotation={input.gtf} "
        "--cytobands={input.cytobands} "
        "--proteinDomains={input.protein_domains}) &> {log}"
