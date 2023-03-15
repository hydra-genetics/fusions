import tempfile
import os
import unittest


class TestUnitUtils(unittest.TestCase):
    def setUp(self):

        self.min_support = 30
        self.filter_on_fusiondb = True

        self.tempdir = tempfile.mkdtemp()

    def tearDown(self):
        pass

    def _test_annotate_fusion(self, test_results, fusions):
        j = 0
        for fusion in fusions:
            for f in fusion:
                try:
                    self.assertEqual(test_results[j][f], fusion[f])
                except AssertionError as e:
                    print("Failed annotation fusions of: " + str(fusion))
                    raise e
            j += 1

    def _test_filter_fusion(self, test_results, fusions):
        j = 0
        for fusion in fusions:
            for f in fusion:
                try:
                    self.assertEqual(test_results[j][f], fusion[f])
                except AssertionError as e:
                    print("Failed filtering fusions of: " + str(fusion))
                    raise e
            j += 1

    def _test_get_breakpoints(self, test_results, fusion_breakpoint_dict):
        for breakpoint in fusion_breakpoint_dict:
            try:
                self.assertEqual(test_results[breakpoint], fusion_breakpoint_dict[breakpoint])
            except AssertionError as e:
                print("Failed breakpoint finding of: " + str(fusion_breakpoint_dict[breakpoint]))
                raise e

    def test_report_fusion(self):

        from filter_report_fuseq_wes import filter_fusion
        from filter_report_fuseq_wes import get_breakpoints
        from filter_report_fuseq_wes import annotate_fusion

        breakpoint = ".tests/units/fuseq_wes/Sample1/FuSeq_WES_SR_fge_fdb.txt"
        sample = "Sample1"
        fusion_breakpoint_dict = get_breakpoints(open(breakpoint), sample)
        report_genes = ["ALK"]
        transcript_black_list = ["NM_001353765"]
        fusions = ".tests/units/fuseq_wes/Sample1/FuSeq_WES_FusionFinal.txt"
        gtf = ".tests/units/fuseq_wes/hg19.refGene.small.gtf"

        test_results = {"ALK--EML4": ["chr2:29446159-29446272", "chr2:42546328-42546359"]}
        self._test_get_breakpoints(test_results, fusion_breakpoint_dict)

        filtered_fusions = filter_fusion(
            sample,
            fusion_breakpoint_dict,
            report_genes,
            open(fusions),
            self.min_support,
            self.filter_on_fusiondb
        )

        test_results = [
            {
                'fusion_name': 'ALK--EML4',
                'break_point1': 'chr2:29446159-29446272',
                'exon1': '',
                'break_point2': 'chr2:42546328-42546359',
                'exon2': '',
                'paralog': 'FALSE',
                'SR_support': 98,
                'MR_support': 23,
                'support': 121,
            },
            {
                'fusion_name': 'ALK--EML4',
                'break_point1': '',
                'exon1': '',
                'break_point2': '',
                'exon2': '',
                'paralog': 'FALSE',
                'SR_support': 0,
                'MR_support': 98,
                'support': 98
            }
        ]
        self._test_filter_fusion(test_results, filtered_fusions)

        annotated_filtered_fusions = annotate_fusion(filtered_fusions, open(gtf), transcript_black_list)
        test_results = [
            {
                'fusion_name': 'ALK--EML4',
                'break_point1': 'chr2:29446159-29446272',
                'exon1': 'exon 21 in NM_004304',
                'break_point2': 'chr2:42546328-42546359',
                'exon2': 'exon 19 in NM_001145076',
                'paralog': 'FALSE',
                'SR_support': 98,
                'MR_support': 23,
                'support': 121
            },
            {
                'fusion_name': 'ALK--EML4',
                'break_point1': '',
                'exon1': '',
                'break_point2': '',
                'exon2': '',
                'paralog': 'FALSE',
                'SR_support': 0,
                'MR_support': 98,
                'support': 98
            }
        ]
        self._test_annotate_fusion(test_results, annotated_filtered_fusions)
