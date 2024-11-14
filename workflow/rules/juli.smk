__author__ = "Jonas Almlöf"
__copyright__ = "Copyright 2024, Jonas Almlöf"
__email__ = "jonas.almlof@scilifelab.uu.se"
__license__ = "GPL-3"


rule juli_call:
    input:
        bam="alignment/samtools_merge_bam/{sample}_{type}.bam",
        bai="alignment/samtools_merge_bam/{sample}_{type}.bam.bai",
    output:
        bamstat=temp("fusions/juli_call/{sample}_{type}.BamStat.txt"),
        fusions=temp("fusions/juli_call/{sample}_{type}.txt"),
    params:
        extra=config.get("juli_call", {}).get("extra", ""),
        gap_file=config.get("juli_call", {}).get("gap_file", ""),
        juli_version=config.get("juli_call", {}).get("juli_version", "juliv0.1.6.2"),
        ref_genes=config.get("juli_call", {}).get("ref_genes", ""),
        reference=config.get("reference", {}).get("fasta", ""),
        sample_name="{sample}_{type}",
    log:
        "fusions/juli_call/{sample}_{type}.txt.log",
    benchmark:
        repeat("fusions/juli_call/{sample}_{type}.txt.benchmark.tsv", config.get("juli_call", {}).get("benchmark_repeats", 1))
    threads: config.get("juli_call", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("juli_call", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("juli_call", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("juli_call", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("juli_call", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("juli_call", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("juli_call", {}).get("container", config["default_container"])
    message:
        "{rule}: call fusions {output.fusions} using {input.bam}"
    shell:
        'Rscript -e "'
        "library({params.juli_version}); "
        "callfusion("
        "CaseBam='{input.bam}', "
        "TestID='{params.sample_name}', "
        "OutputPath='$(dirname {output.fusions})', "
        "Thread={threads}, "
        "Refgene='{params.ref_genes}', "
        "Gap='{params.gap_file}', "
        "Reference='{params.reference}')"
        '" &> {log}'


rule juli_annotate:
    input:
        fusions="fusions/juli_call/{sample}_{type}.txt",
    output:
        fusions=temp("fusions/juli_call/{sample}_{type}.annotated.txt"),
        pdf=temp("fusions/juli_call/{sample}_{type}.annotated.gene.pdf"),
    params:
        cosmic=config.get("juli_annotate", {}).get("cosmic", ""),
        extra=config.get("juli_annotate", {}).get("extra", ""),
        juli_version=config.get("juli_call", {}).get("juli_version", "juliv0.1.6.2"),
        pfam=config.get("juli_annotate", {}).get("pfam", ""),
        ref_genes=config.get("juli_annotate", {}).get("ref_genes", ""),
        uniprot=config.get("juli_annotate", {}).get("uniprot", ""),
    log:
        "fusions/juli_annotate/{sample}_{type}.annotated.txt.log",
    benchmark:
        repeat(
            "fusions/juli_annotate/{sample}_{type}.annotated.txt.benchmark.tsv",
            config.get("juli_annotate", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("juli_annotate", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("juli_annotate", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("juli_annotate", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("juli_annotate", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("juli_annotate", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("juli_annotate", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("juli_annotate", {}).get("container", config["default_container"])
    message:
        "{rule}: annotate fusions in {input.fusions} to {output.fusions}"
    shell:
        'Rscript -e "'
        "library({params.juli_version}); "
        "annofusion("
        "Output='{input.fusions}', "
        "Refgene='{params.ref_genes}', "
        "Cosmic='{params.cosmic}', "
        "Pfam='{params.pfam}', "
        "Uniprot='{params.uniprot}')"
        '" &> {log}'


rule juli_filter:
    input:
        fusions="fusions/juli_call/{sample}_{type}.annotated.txt",
    output:
        fusions=temp("fusions/juli_call/{sample}_{type}.annotated.filtered.txt"),
    params:
        cosmic_filter=config.get("juli_filter", {}).get("cosmic_filter", True),
        discordant_limit=config.get("juli_filter", {}).get("discordant_limit", 0),
        split_reads_limit=config.get("juli_filter", {}).get("split_reads_limit", 0),
        total_support_limit=config.get("juli_filter", {}).get("total_support_limit", 0),
    log:
        "fusions/juli_filter/{sample}_{type}.annotated.filtered.txt.log",
    benchmark:
        repeat(
            "fusions/juli_filter/{sample}_{type}.annotated.filtered.txt.benchmark.tsv",
            config.get("juli_filter", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("juli_filter", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("juli_filter", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("juli_filter", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("juli_filter", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("juli_filter", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("juli_filter", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("juli_filter", {}).get("container", config["default_container"])
    message:
        "{rule}: Filter fusions found in {input.fusions} into {output.fusions}"
    script:
        "./scripts/filter_juli.py"
