import sys
import tempfile
import os
import unittest

TEST_DIR = os.path.dirname(os.path.abspath(__file__))
SCRIPT_DIR = os.path.abspath(os.path.join(TEST_DIR, "../../workflow/scripts"))
sys.path.insert(0, SCRIPT_DIR)

from ctat_splicing_filter import filter_splicing

class TestUnitUtils(unittest.TestCase):
    def setUp(self):

        self.tempfile = tempfile.mkstemp()

    def tearDown(self):
        pass

    def _test_filter_splicing(self, test_results, splicings):
        j = 0
        for splicing in splicings:
            try:
                self.assertEqual(test_results[j], splicing)
            except AssertionError as e:
                print("Failed filtering splicings of: " + str(splicing))
                raise e
            try:
                self.assertEqual(len(test_results), len(splicings))
            except AssertionError as e:
                print("Failed filtering splicings of due to length of results: " + str(splicing))
                raise e
            j += 1

    def test_filter_fusions(self):

        splicings = ".tests/units/ctat_splicing/ctat_splicing_test.cancer.introns"
        gene_dict = {"MET" : ["METx14del", 50], "EGFR" : ["EGFRvIII", 50]}

        filtered_splicing = filter_splicing(
            open(splicings),
            open(self.tempfile[1], "w"),
            gene_dict,
        )

        test_results = ["chr7:116411709-116414934	+	MET^ENSG00000105976.10	5947	10	LUAD:12:2.14,LUSC:2:0.37,LGG:1:0.19	NA	METx14del\n", # noqa
                        "chr7:55087059-55223522	+	EGFR^ENSG00000146648.11	74289	788	GBM:28:16.57,LGG:9:1.73,STAD:1:0.25,HNSC:1:0.18	NA	EGFRvIII\n"] # noqa

        self._test_filter_splicing(test_results, filtered_splicing)


        gene_dict = {"MET" : ["METx14del", 50], "EGFR" : ["", 50]}

        filtered_splicing = filter_splicing(
            open(splicings),
            open(self.tempfile[1], "w"),
            gene_dict,
        )

        test_results = ["chr7:116411709-116414934	+	MET^ENSG00000105976.10	5947	10	LUAD:12:2.14,LUSC:2:0.37,LGG:1:0.19	NA	METx14del\n", # noqa
                        "chr7:55087059-55223522	+	EGFR^ENSG00000146648.11	74289	788	GBM:28:16.57,LGG:9:1.73,STAD:1:0.25,HNSC:1:0.18	NA	EGFRvIII\n", # noqa
                        "chr7:55177652-55223522	+	EGFR^ENSG00000146648.11	629	1	GBM:2:1.18	NA	EGFRvIIIb\n"] # noqa

        self._test_filter_splicing(test_results, filtered_splicing)


        gene_dict = {"MET" : ["METx14del", 0], "EGFR" : ["EGFRvIII", 50]}

        filtered_splicing = filter_splicing(
            open(splicings),
            open(self.tempfile[1], "w"),
            gene_dict,
        )

        test_results = ["chr7:116411709-116414934	+	MET^ENSG00000105976.10	5947	10	LUAD:12:2.14,LUSC:2:0.37,LGG:1:0.19	NA	METx14del\n", # noqa
                        "chr7:55087059-55223522	+	EGFR^ENSG00000146648.11	74289	788	GBM:28:16.57,LGG:9:1.73,STAD:1:0.25,HNSC:1:0.18	NA	EGFRvIII\n"] # noqa

        self._test_filter_splicing(test_results, filtered_splicing)


        gene_dict = {"MET" : ["METx14del", 10000], "EGFR" : ["EGFRvIII", 50]}

        filtered_splicing = filter_splicing(
            open(splicings),
            open(self.tempfile[1], "w"),
            gene_dict,
        )

        test_results = ["chr7:55087059-55223522	+	EGFR^ENSG00000146648.11	74289	788	GBM:28:16.57,LGG:9:1.73,STAD:1:0.25,HNSC:1:0.18	NA	EGFRvIII\n"] # noqa

        self._test_filter_splicing(test_results, filtered_splicing)