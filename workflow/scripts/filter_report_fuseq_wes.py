
import logging
import re

log = logging.getLogger()


def get_breakpoints(breakpoint_file, sample):
    fusion_breakpoint_dict = {}
    header_list = next(breakpoint_file).rstrip().split("\t")
    for fusion in breakpoint_file:
        columns = {k: v for k, v in zip(header_list, fusion.strip().split("\t"))}
        fusion_name = columns['name12']
        chrom1 = columns['front_tx'].split("__")[1]
        break_point1_1 = int(columns['front_tx'].split("__")[2]) + int(columns['front_hitpos'])
        break_point1_2 = break_point1_1 + int(columns['front_len'])
        break_point1 = f"{chrom1}:{break_point1_1}-{break_point1_2}"
        chrom2 = columns['back_tx'].split("__")[1]
        break_point2_1 = int(columns['back_tx'].split("__")[2]) + int(columns['back_hitpos'])
        break_point2_2 = break_point2_1 + int(columns['back_len'])
        break_point2 = f"{chrom2}:{break_point2_1}-{break_point2_2}"
        fusion_breakpoint_dict[fusion_name] = [break_point1, break_point2]
    return fusion_breakpoint_dict


def get_report_genes(gene_white_list):
    report_genes = []
    for gene in gene_white_list:
        report_genes.append(gene.strip())
    return report_genes


def get_transcript_black_list(transcript_black_list_file):
    transcript_black_list = []
    for transcript in transcript_black_list_file:
        transcript_black_list.append(transcript.strip())
    return transcript_black_list


def filter_fusion(sample, fusion_breakpoint_dict, report_genes, fusion_file, min_support, filter_on_fusiondb):
    nr_report_genes = len(report_genes)
    filtered_fusions = []
    header_list = next(fusion_file).rstrip().split("\t")
    for fusion in fusion_file:
        columns = {k: v for k, v in zip(header_list, fusion.strip().split("\t"))}
        fusion_name = columns['fusionName']
        gene1, gene2 = fusion_name.split("--")
        reverse_fusion_name = f"{gene2}--{gene1}"
        if nr_report_genes > 0 and not (gene1 in report_genes or gene2 in report_genes):
            continue
        support = int(columns['supportCount'])
        if support < min_support:
            continue
        SR_support = int(columns['SR'])
        MR_support = int(columns['MR'])
        fusiondb = int(columns['fusionDB'])
        paralog = columns['isParalog']
        if fusiondb == 1 or filter_on_fusiondb is False:
            break_points = ["", ""]
            break_point1 = ""
            break_point2 = ""
            if SR_support > 0:
                if fusion_name in fusion_breakpoint_dict:
                    break_points = fusion_breakpoint_dict[fusion_name]
                if reverse_fusion_name in fusion_breakpoint_dict:
                    break_points = fusion_breakpoint_dict[reverse_fusion_name]
                break_point1 = break_points[0]
                break_point2 = break_points[1]
            filtered_fusions.append(
                {
                    "fusion_name": fusion_name,
                    "break_point1": break_point1,
                    "exon1": "",
                    "break_point2": break_point2,
                    "exon2": "",
                    "paralog": paralog,
                    "SR_support": SR_support,
                    "MR_support": MR_support,
                    "support": support,
                }
            )
    return filtered_fusions


def get_annotation(annotation):
    annotation_dict = {}
    annotations = annotation.split(";")
    for a in annotations[:-1]:
        a = a.strip()
        key, value = a.split(" ")
        value = value.strip('"')
        annotation_dict[key] = value
    return annotation_dict


def annotate_fusion(filtered_fusions, input_gtf, transcript_black_list):
    gene_dict = {}
    chr_pos_dict = {}
    transcript_exon_max = {}
    i = 0
    large_bp_distance = 100000
    for fusion in filtered_fusions:
        if not (fusion["break_point1"] == "" or fusion["break_point2"] == ""):
            gene1, gene2 = fusion["fusion_name"].split("--")
            gene_dict[gene1] = ""
            gene_dict[gene2] = ""
            bp1_chrom, pos1, pos2 = re.split(":|-", fusion['break_point1'])
            # Middle point of region for distance calculation between two points rather than regions
            bp1_pos = (int(pos1) + int(pos2)) / 2
            bp2_chrom, pos1, pos2 = re.split(":|-", fusion['break_point2'])
            # Middle point of region for distance calculation between two points rather than regions
            bp2_pos = (int(pos1) + int(pos2)) / 2
            if bp1_chrom in chr_pos_dict:
                chr_pos_dict[bp1_chrom].append(
                    {
                        "bp_pos": bp1_pos,
                        "fusion_index": i,
                        "exon_1_2": "exon1",
                        "distance": large_bp_distance,
                        "exon_number": 0,
                        "transcript_id": "",
                        "strand": "",
                    }
                )
            else:
                chr_pos_dict[bp1_chrom] = [
                    {
                        "bp_pos": bp1_pos,
                        "fusion_index": i,
                        "exon_1_2": "exon1",
                        "distance": large_bp_distance,
                        "exon_number": 0,
                        "transcript_id": "",
                        "strand": "",
                    }
                ]
            if bp2_chrom in chr_pos_dict:
                chr_pos_dict[bp2_chrom].append(
                    {
                        "bp_pos": bp2_pos,
                        "fusion_index": i,
                        "exon_1_2": "exon2",
                        "distance": large_bp_distance,
                        "exon_number": 0,
                        "transcript_id": "",
                        "strand": "",
                    }
                )
            else:
                chr_pos_dict[bp2_chrom] = [
                    {
                        "bp_pos": bp2_pos,
                        "fusion_index": i,
                        "exon_1_2": "exon2",
                        "distance": large_bp_distance,
                        "exon_number": 0,
                        "transcript_id": "",
                        "strand": "",
                    }
                ]
        i += 1
    for gtf in input_gtf:
        chrom, source, type, start, end, score, strand, frame, annotation = gtf.strip().split("\t")
        if type != "CDS":
            continue
        annotation_dict = get_annotation(annotation)
        gene_name = annotation_dict.get("gene_id", "")
        if gene_name in gene_dict:
            # Middle point of region for distance calculation between two points rather than regions
            pos = (int(start) + int(end)) / 2
            if chrom in chr_pos_dict:
                for breakpoint in chr_pos_dict[chrom]:
                    if strand == "-":
                        distance = breakpoint["bp_pos"] - pos
                    else:
                        distance = pos - breakpoint["bp_pos"]
                    if distance < 0:
                        distance = large_bp_distance
                    transcript_id = annotation_dict.get("transcript_id", "")
                    if transcript_id in transcript_black_list:
                        continue
                    exon_number = int(annotation_dict.get("exon_number", ""))
                    if distance < breakpoint["distance"]:
                        breakpoint["distance"] = distance
                        breakpoint["exon_number"] = exon_number
                        breakpoint["transcript_id"] = transcript_id
                        breakpoint["strand"] = strand
                    transcript_exon_max[transcript_id] = exon_number
    for chrom in chr_pos_dict:
        for breakpoint in chr_pos_dict[chrom]:
            transcript_id = breakpoint["transcript_id"]
            if breakpoint["strand"] == "-":
                exon_number = transcript_exon_max[transcript_id] - breakpoint["exon_number"] + 1
            else:
                exon_number = breakpoint["exon_number"]
            filtered_fusions[breakpoint["fusion_index"]][breakpoint["exon_1_2"]] = f"exon {exon_number} in {transcript_id}"
    return filtered_fusions


def write_fusions(annotated_filtered_fusions, out_file):
    out_file.write("fusion\tbreak_point1\texon1\tbreak_point2\texon2\tparalog\t")
    out_file.write("split_read_support\tmate_pair_support\ttotal_support\n")
    for data in annotated_filtered_fusions:
        first = True
        for d in data:
            if first:
                out_file.write(f"{data[d]}")
                first = False
            else:
                out_file.write(f"\t{data[d]}")
        out_file.write(f"\n")
    out_file.close()


if __name__ == "__main__":
    log = snakemake.log_fmt_shell(stdout=False, stderr=True)

    sample = snakemake.input.breakpoint.split("/")[-2].split(".")[0]
    fusion_breakpoint_dict = get_breakpoints(open(snakemake.input.breakpoint), sample)
    if snakemake.params.gene_white_list != "":
        report_genes = get_report_genes(open(snakemake.params.gene_white_list))
    else:
        report_genes = []
    if snakemake.params.transcript_black_list != "":
        transcript_black_list = get_transcript_black_list(open(snakemake.params.transcript_black_list))
    else:
        transcript_black_list = []
    filtered_fusions = filter_fusion(
        sample,
        fusion_breakpoint_dict,
        report_genes,
        open(snakemake.input.fusions),
        snakemake.params.min_support,
        snakemake.params.filter_on_fusiondb,
    )
    annotated_filtered_fusions = annotate_fusion(filtered_fusions, open(snakemake.params.gtf), transcript_black_list)
    write_fusions(annotated_filtered_fusions, open(snakemake.output.fusions, "w"))
