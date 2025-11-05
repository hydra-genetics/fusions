import logging

log = logging.getLogger()


def read_filter_file(filter_filename):
    gene_dict = {}
    if filter_filename == "":
        return gene_dict
    filter_file = open(filter_filename)
    i = 0
    for line in filter_file:
        if i == 0 and (line.startswith("gene") or line.startswith("Gene")):
            i += 1
            continue
        columns = line.strip().split("\t")
        gene = columns[0]
        variant_names = columns[1].split(",")
        reads = int(columns[2])
        gene_dict[gene] = [variant_names, reads]
    return gene_dict


def filter_splicing(in_file, out_file, gene_dict):
    results = []
    header_list = next(in_file).rstrip().split("\t")
    out_file.write(header_list[0])
    for h in header_list[1:]:
        out_file.write(f"\t{h}")
    out_file.write(f"\n")
    for fusion in in_file:
        columns = {k: v for k, v in zip(header_list, fusion.strip("\n").split("\t"))}
        gene = columns["genes"].split("^")[0]
        nr_unique_support = int(columns["uniq_mapped"])
        variant_name = columns["variant_name"]
        if (
            gene_dict == {} or
            (
                gene in gene_dict and
                (variant_name in gene_dict[gene][0] or gene_dict[gene][0] == "") and
                nr_unique_support >= gene_dict[gene][1]
            )
        ):
            out_file.write(fusion)
            results.append(fusion)
    return results


if __name__ == "__main__":
    log = snakemake.log_fmt_shell(stdout=False, stderr=True)
    in_file = open(snakemake.input.splicing)
    out_file = open(snakemake.output.splicing_filtered, "w")
    filter_filename = snakemake.params.filtering_file

    gene_dict = read_filter_file(filter_filename)
    results = filter_splicing(in_file, out_file, gene_dict)

    in_file.close()
    out_file.close()
