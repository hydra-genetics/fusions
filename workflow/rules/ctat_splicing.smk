__author__ = "Jonas Almlöf"
__copyright__ = "Copyright 2025, Jonas Almlöf"
__email__ = "jonas.almlof@scilifelab.uu.se"
__license__ = "GPL-3"


rule ctat_splicing_call:
    input:
        sj_tab_file="alignment/star/{sample}_{type}.SJ.out.tab",
        bam="alignment/star/{sample}_{type}.bam",
    output:
        bai=temp("fusions/ctat_splicing_call/{sample}_{type}.cancer_intron_reads.sorted.bam.bai"),
        bam=temp("fusions/ctat_splicing_call/{sample}_{type}.cancer_intron_reads.sorted.bam"),
        cancer_splicing=temp("fusions/ctat_splicing_call/{sample}_{type}.cancer.introns"),
        igv_splicing=temp("fusions/ctat_splicing_call/{sample}_{type}.ctat-splicing.igv.html"),
        result_dir=temp(directory("fusions/ctat_splicing_call/ctat_out_{sample}_{type}")),
    params:
        ctat_genome_lib=config.get("ctat_splicing_call", {}).get("ctat_genome_lib_path", ""),
        extra=config.get("ctat_splicing_call", {}).get("extra", ""),
        sample_name="{sample}_{type}",
    log:
        "fusions/ctat_splicing_call/{sample}_{type}.output.log",
    benchmark:
        repeat(
            "fusions/ctat_splicing_call/{sample}_{type}.output.benchmark.tsv",
            config.get("ctat_splicing_call", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("ctat_splicing_call", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("ctat_splicing_call", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("ctat_splicing_call", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("ctat_splicing_call", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("ctat_splicing_call", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("ctat_splicing_call", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("ctat_splicing_call", {}).get("container", config["default_container"])
    message:
        "{rule}: Call splicing into html report {output.cancer_splicing}"
    shell:
        "import os"
        "/usr/local/src/CTAT-SPLICING/STAR_to_cancer_introns.py "
        "--SJ_tab_file {input.sj_tab_file} "
        "--vis "
        "--bam_file {input.bam} "
        "--output_prefix {output.result_dir}/{params.sample_name} "
        "--sample_name {params.sample_name} "
        "--ctat_genome_lib /data/ref_data/star-fusion/GRCh37_gencode_v19_CTAT_lib_Mar012021.plug-n-play/ctat_genome_lib_build_dir/ || "
        "cp {output.result_dir}/os.path.basename({output.cancer_splicing}) {output.cancer_splicing} || "
        "cp {output.result_dir}/os.path.basename({output.igv_splicing}) {output.igv_splicing} || "
        "cp {output.result_dir}/os.path.basename({output.bam}) {output.bam} || "
        "cp {output.result_dir}/os.path.basename({output.bai}) {output.bai}"
