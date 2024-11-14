import sys
import tempfile
import os
import unittest

TEST_DIR = os.path.dirname(os.path.abspath(__file__))
SCRIPT_DIR = os.path.abspath(os.path.join(TEST_DIR, "../../workflow/scripts"))
sys.path.insert(0, SCRIPT_DIR)

from filter_juli import filter_fusions

class TestUnitUtils(unittest.TestCase):
    def setUp(self):

        self.cosmic = True
        self.discordant_limit = 20
        self.split_reads_limit = 35
        self.total_support_limit = 70

        self.tempfile = tempfile.mkstemp()

    def tearDown(self):
        pass

    def _test_filter_fusions(self, test_results, fusions):
        j = 0
        for fusion in fusions:
            try:
                self.assertEqual(test_results[j], fusion)
            except AssertionError as e:
                print("Failed filtering fusions of: " + str(fusion))
                raise e
            j += 1

    def test_filter_fusions(self):

        fusions = ".tests/units/juli/juli_test.annotated.txt"

        filtered_fusions = filter_fusions(
            open(fusions),
            open(self.tempfile[1], "w"),
            True,
            20,
            35,
            70,
        )

        test_results = ["chr2\t29447837\t1\t11\t28\tchr2\t42526358\t1\t11\t20\tInversion\tALK\t-\tEML4\t+\tNM_004304_Intron(19/28)_Frame(1)\tNM_019063_Intron(13/22)_Frame(1)\tEML4->ALK\tInframe\tlung(1126)_thyroid(14)\n"]  # noqa

        self._test_filter_fusions(test_results, filtered_fusions)

        filtered_fusions = filter_fusions(
            open(fusions),
            open(self.tempfile[1], "w"),
            False,
            20,
            35,
            70,
        )

        test_results = [
            "chr2\t30053808\t1\t11\t17\tchr4\t183934636\t1\t17\t71\tInterchromosomal_translocation\tALK\t-\tFlanking_FAM92A1P2\t+\tNM_004304_Intron(1/28)_Frame(1)\t\tFlanking_FAM92A1P2->ALK\t\t\n",  # noqa
            "chr2\t29447837\t1\t11\t28\tchr2\t42526358\t1\t11\t20\tInversion\tALK\t-\tEML4\t+\tNM_004304_Intron(19/28)_Frame(1)\tNM_019063_Intron(13/22)_Frame(1)\tEML4->ALK\tInframe\tlung(1126)_thyroid(14)\n",  # noqa
        ]

        self._test_filter_fusions(test_results, filtered_fusions)

        filtered_fusions = filter_fusions(
            open(fusions),
            open(self.tempfile[1], "w"),
            True,
            0,
            0,
            70,
        )

        test_results = [
            "chr2\t29447837\t1\t11\t28\tchr2\t42526358\t1\t11\t20\tInversion\tALK\t-\tEML4\t+\tNM_004304_Intron(19/28)_Frame(1)\tNM_019063_Intron(13/22)_Frame(1)\tEML4->ALK\tInframe\tlung(1126)_thyroid(14)\n",  # noqa
            "chr2\t29446685\t1\t8\t30\tchr2\t42523824\t1\t8\t24\tInversion\tALK\t-\tEML4\t+\tNM_004304_Intron(19/28)_Frame(1)\tNM_019063_Intron(13/22)_Frame(1)\tEML4->ALK\tInframe\tlung(1126)_thyroid(14)\n",  # noqa
        ]

        self._test_filter_fusions(test_results, filtered_fusions)

        filtered_fusions = filter_fusions(
            open(fusions),
            open(self.tempfile[1], "w"),
            True,
            0,
            50,
            0,
        )

        test_results = [
            "chr2\t29446685\t1\t8\t30\tchr2\t42523824\t1\t8\t24\tInversion\tALK\t-\tEML4\t+\tNM_004304_Intron(19/28)_Frame(1)\tNM_019063_Intron(13/22)_Frame(1)\tEML4->ALK\tInframe\tlung(1126)_thyroid(14)\n",  # noqa
        ]

        self._test_filter_fusions(test_results, filtered_fusions)

        filtered_fusions = filter_fusions(
            open(fusions),
            open(self.tempfile[1], "w"),
            True,
            40,
            0,
            0,
        )

        test_results = [
            "chr2\t29446685\t1\t8\t30\tchr2\t42523824\t1\t8\t24\tInversion\tALK\t-\tEML4\t+\tNM_004304_Intron(19/28)_Frame(1)\tNM_019063_Intron(13/22)_Frame(1)\tEML4->ALK\tInframe\tlung(1126)_thyroid(14)\n",  # noqa
        ]

        self._test_filter_fusions(test_results, filtered_fusions)
