import copy
import hashlib
import importlib.util
import json
import shutil
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("status_manifest", ROOT / "scripts/status_manifest.py")
status = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(status)


class StatusManifestTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.data = status.load_registry(ROOT)
        for evidence in self.data["evidence"]:
            target = self.root / evidence["local_path"]
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(ROOT / evidence["local_path"], target)
        outputs = status.rendered(self.data)
        for name, content in outputs.items():
            path = self.root / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content, encoding="utf-8")
        self.metadata = json.loads((ROOT / "zenodo.json").read_text(encoding="utf-8"))
        self.metadata["description"] = outputs["governance/generated/zenodo-description.html"]
        (self.root / "zenodo.json").write_text(json.dumps(self.metadata), encoding="utf-8")

    def test_current_register_and_surfaces_pass(self):
        status.validate(self.data, self.root)
        self.assertEqual(status.check_surfaces(self.root, self.data, status.rendered(self.data)), [])

    def test_evidence_content_change_is_rejected(self):
        path = self.root / self.data["evidence"][0]["local_path"]
        path.write_text("changed evidence", encoding="utf-8")
        with self.assertRaisesRegex(status.RegistryError, "digest mismatch"):
            status.validate(self.data, self.root)

    def test_unpinned_source_url_is_rejected(self):
        self.data["evidence"][0]["source_url"] = self.data["evidence"][0]["source_url"].replace(
            self.data["evidence"][0]["source_commit"], "main")
        with self.assertRaisesRegex(status.RegistryError, "not pinned"):
            status.validate(self.data, self.root)

    def test_promotion_without_proof_receipt_is_rejected(self):
        self.data["claims"][1]["proof_status"] = "proved"
        with self.assertRaisesRegex(status.RegistryError, "needs a proof receipt"):
            status.validate(self.data, self.root)

    def test_receipt_for_another_commit_is_rejected(self):
        receipt = {"subject_commit": "0" * 40, "claim_id": "RH-T2-LOWER-BOUND",
                   "result": "success", "command": ["lake", "build"],
                   "theorem_roots": ["Example.theorem"], "axioms": []}
        path = self.root / "receipt.json"
        path.write_text(json.dumps(receipt), encoding="utf-8")
        entry = copy.deepcopy(self.data["evidence"][0])
        entry.update(id="PROOF-RECEIPT", kind="proof_receipt", local_path="receipt.json",
                     sha256=hashlib.sha256(path.read_bytes()).hexdigest())
        self.data["evidence"].append(entry)
        self.data["claims"][1].update(proof_status="proved", evidence_ids=["PROOF-RECEIPT"])
        with self.assertRaisesRegex(status.RegistryError, "different source commit"):
            status.validate(self.data, self.root)

    def test_duplicate_json_keys_are_rejected(self):
        with self.assertRaisesRegex(status.RegistryError, "duplicate JSON key"):
            json.loads('{"proof_status":"unverified","proof_status":"proved"}',
                       object_pairs_hook=status.unique_keys)

    def test_sorry_axiom_receipt_is_rejected(self):
        receipt = {"subject_commit": self.data["archive"]["source_commit"],
                   "claim_id": "RH-T2-LOWER-BOUND", "result": "success",
                   "command": ["lake", "build"], "theorem_roots": ["Example.theorem"],
                   "axioms": ["sorryAx"]}
        path = self.root / "receipt.json"
        path.write_text(json.dumps(receipt), encoding="utf-8")
        entry = copy.deepcopy(self.data["evidence"][0])
        entry.update(id="PROOF-RECEIPT", kind="proof_receipt", local_path="receipt.json",
                     sha256=hashlib.sha256(path.read_bytes()).hexdigest())
        self.data["evidence"].append(entry)
        self.data["claims"][1].update(proof_status="proved", evidence_ids=["PROOF-RECEIPT"])
        with self.assertRaisesRegex(status.RegistryError, "unapproved axiom"):
            status.validate(self.data, self.root)

    def test_indirect_dependency_cycle_is_rejected(self):
        self.data["claims"][1]["depends_on"] = ["RH-T1T4"]
        with self.assertRaisesRegex(status.RegistryError, "cyclic claim dependency"):
            status.validate(self.data, self.root)

    def test_missing_evidence_reference_is_rejected(self):
        self.data["claims"][0]["evidence_ids"] = ["DOES-NOT-EXIST"]
        with self.assertRaisesRegex(status.RegistryError, "unknown evidence reference"):
            status.validate(self.data, self.root)

    def test_rh_claim_cannot_be_enabled(self):
        self.data["rh_claimed"] = True
        with self.assertRaisesRegex(status.RegistryError, "cannot claim RH"):
            status.validate(self.data, self.root)

    def test_each_generated_entry_point_is_checked(self):
        outputs = status.rendered(self.data)
        for name, original in outputs.items():
            with self.subTest(path=name):
                path = self.root / name
                path.write_text(original + "\nUnregistered extra statement.\n", encoding="utf-8")
                errors = status.check_surfaces(self.root, self.data, outputs)
                self.assertTrue(any(name in error and "drift" in error for error in errors))
                path.write_text(original, encoding="utf-8")

    def test_promotion_wording_handles_unicode_hyphens_and_html(self):
        outputs = status.rendered(self.data)
        path = self.root / "README.md"
        for text in ["journal-ready", "journal‑ready", "Proof-Article", "Proof–Article",
                     "journal-<b>ready</b>", "journal&#45;ready", "prêt-journal"]:
            with self.subTest(text=text):
                path.write_text(outputs["README.md"] + "\n" + text, encoding="utf-8")
                errors = status.check_surfaces(self.root, self.data, outputs)
                self.assertTrue(any("incompatible" in error for error in errors))

    def test_metadata_drift_is_rejected(self):
        self.metadata["description"] = "Different current claim"
        (self.root / "zenodo.json").write_text(json.dumps(self.metadata), encoding="utf-8")
        errors = status.check_surfaces(self.root, self.data, status.rendered(self.data))
        self.assertTrue(any("zenodo.json description differs" in error for error in errors))

    def test_new_readme_cannot_escape_registered_scope(self):
        (self.root / "README_new.md").write_text("A separate unregistered status", encoding="utf-8")
        errors = status.check_surfaces(self.root, self.data, status.rendered(self.data))
        self.assertTrue(any("unregistered README" in error for error in errors))

    def test_source_path_cannot_escape_repository(self):
        self.data["evidence"][0]["local_path"] = "../outside.md"
        with self.assertRaisesRegex(status.RegistryError, "unsafe path"):
            status.validate(self.data, self.root)

    def test_release_is_blocked_even_when_documentary_check_passes(self):
        self.assertEqual(status.check_surfaces(self.root, self.data, status.rendered(self.data)), [])
        with self.assertRaisesRegex(status.RegistryError, "proof release blocked"):
            status.check_release(self.data)


if __name__ == "__main__":
    unittest.main()
