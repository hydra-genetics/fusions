import logging
import re

log = logging.getLogger()


def filter_fusions(in_file, out_file, cosmic_filter, discordant_limit, split_reads_limit, total_support_limit):
    results = []
    header_list = next(in_file).rstrip().split("\t")
    out_file.write(header_list[0])
    for h in header_list[1:]:
        out_file.write(f"\t{h}")
    out_file.write(f"\n")
    for fusion in in_file:
        columns = {k: v for k, v in zip(header_list, fusion.strip("\n").split("\t"))}
        cosmic = columns["Cosmic"]
        if cosmic == "" and cosmic_filter is True:
            continue
        discordant = int(columns["DisA"]) + int(columns["DisB"])
        split = int(columns["SplitA"]) + int(columns["SplitB"])
        total_support = discordant + split
        if discordant < discordant_limit or split < split_reads_limit or total_support < total_support_limit:
            continue
        out_file.write(fusion)
        results.append(fusion)
    return results


if __name__ == "__main__":
    log = snakemake.log_fmt_shell(stdout=False, stderr=True)
    in_file = open(snakemake.input.fusions)
    out_file = open(snakemake.output.fusions, "w")
    cosmic_filter = snakemake.params.cosmic_filter
    discordant_limit = int(snakemake.params.discordant_limit)
    split_reads_limit = int(snakemake.params.split_reads_limit)
    total_support_limit = int(snakemake.params.total_support_limit)

    results = filter_fusions(in_file, out_file, cosmic_filter, discordant_limit, split_reads_limit, total_support_limit)

    in_file.close()
    out_file.close()
