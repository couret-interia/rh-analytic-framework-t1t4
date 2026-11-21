#!/usr/bin/env python3
"""Render the registered public entry points from one versioned claim register.

This checks documentary consistency and local evidence integrity. It does not
re-prove mathematics, check the live Zenodo record, or establish priority.
"""

import argparse
import hashlib
import html
import json
import re
import sys
import unicodedata
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = "governance/claims.json"
READMES = {
    "README.md": "en",
    "README_FR.md": "fr",
    "README_hero.md": "en",
    "README_hero_FR.md": "fr",
    "README_arxiv.md": "en",
}
STATUSES = {
    "withdrawn_as_proof": ("WITHDRAWN AS PROOF", "RETIRÉ COMME PREUVE"),
    "withdrawn_empirical_claim": ("WITHDRAWN EMPIRICAL CLAIM", "REVENDICATION EMPIRIQUE RETIRÉE"),
    "refuted_as_stated": ("REFUTED AS STATED", "RÉFUTÉ TEL QU’ÉNONCÉ"),
    "unverified": ("UNVERIFIED", "NON VÉRIFIÉ"),
    "observed": ("BOUNDED OBSERVATION", "OBSERVATION BORNÉE"),
    "conditional": ("CONDITIONAL", "CONDITIONNEL"),
    "proved": ("PROVED WITH SCOPED EVIDENCE", "PROUVÉ DANS LE PÉRIMÈTRE ATTESTÉ"),
}
FORBIDDEN = re.compile(
    r"journal[\s-]*ready|proof[\s-]*article|pr[eê]t[\s-]*journal|article\s+de\s+preuve",
    re.IGNORECASE,
)


class RegistryError(ValueError):
    pass


def require(condition, message):
    if not condition:
        raise RegistryError(message)


def unique_keys(pairs):
    result = {}
    for key, value in pairs:
        require(key not in result, f"duplicate JSON key: {key}")
        result[key] = value
    return result


def local_path(root, value):
    require(isinstance(value, str) and value, "local path must be a nonempty string")
    path = Path(value)
    require(not path.is_absolute() and ".." not in path.parts, f"unsafe path: {value}")
    target = (root / path).resolve()
    require(target.is_relative_to(root.resolve()), f"path escapes repository: {value}")
    return target


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def label(claim, lang):
    return STATUSES[claim["proof_status"]][lang == "fr"]


def load_registry(root):
    with (root / MANIFEST).open(encoding="utf-8") as stream:
        data = json.load(stream, object_pairs_hook=unique_keys)
    validate(data, root)
    return data


def validate(data, root):
    require(type(data["schema_version"]) is int and data["schema_version"] == 1,
            "unsupported schema_version")
    date.fromisoformat(data["as_of"])
    archive = data["archive"]
    require(bool(re.fullmatch(r"[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+", archive["repository"])),
            "invalid repository name")
    require(bool(re.fullmatch(r"[0-9a-f]{40}", archive["source_commit"])),
            "archive must identify an exact source commit")
    require(type(data["rh_claimed"]) is bool, "rh_claimed must be a boolean")
    require(data["rh_claimed"] is False, "this historical-withdrawal register cannot claim RH")
    require(set(data["readme_languages"]) == set(READMES), "all five README entry points are required")
    require(data["readme_languages"] == READMES, "README languages differ from the registered scope")
    evidence = {}
    for entry in data["evidence"]:
        key = entry["id"]
        require(key not in evidence, f"duplicate evidence id: {key}")
        require(entry["kind"] in {"source_document", "proof_receipt"}, f"unknown evidence kind: {key}")
        require(bool(re.fullmatch(r"[0-9a-f]{40}", entry["source_commit"])),
                f"evidence must pin an exact source commit: {key}")
        expected_url = (f"https://github.com/{entry['source_repository']}/blob/"
                        f"{entry['source_commit']}/{entry['source_path']}")
        require(entry["source_url"] == expected_url, f"evidence URL is not pinned: {key}")
        path = local_path(root, entry["local_path"])
        require(path.is_file(), f"missing evidence: {entry['local_path']}")
        require(sha256(path) == entry["sha256"], f"evidence digest mismatch: {key}")
        evidence[key] = entry
    claims = {}
    for claim in data["claims"]:
        key = claim["id"]
        require(key not in claims, f"duplicate claim id: {key}")
        require(bool(re.fullmatch(r"[A-Z0-9-]+", key)), f"invalid claim id: {key}")
        require(claim["proof_status"] in STATUSES, f"unknown proof status: {key}")
        date.fromisoformat(claim["status_date"])
        require(claim["status_date"] <= data["as_of"], f"future claim status: {key}")
        for field in ("statement", "public_summary"):
            require(set(claim[field]) == {"en", "fr"}, f"missing translation: {key}/{field}")
            require(all(isinstance(t, str) and t.strip() for t in claim[field].values()),
                    f"empty public text: {key}/{field}")
        require(claim["entry_mode"] in {"E", "C", "R"}, f"unknown entry mode: {key}")
        require(claim["priority_status"] in {"not_assessed", "open", "prior_art_found", "reviewed"},
                f"unknown priority status: {key}")
        require(claim["external_review_status"] in {"not_attested", "partial", "completed"},
                f"unknown external-review status: {key}")
        require(bool(claim["evidence_ids"]), f"claim needs an explicit source: {key}")
        require(len(claim["evidence_ids"]) == len(set(claim["evidence_ids"])),
                f"duplicate evidence reference: {key}")
        require(all(ref in evidence for ref in claim["evidence_ids"]), f"unknown evidence reference: {key}")
        if claim["proof_status"] == "proved":
            require(any(evidence[ref]["kind"] == "proof_receipt" for ref in claim["evidence_ids"]),
                    f"proved status needs a proof receipt, not a source document: {key}")
            for ref in claim["evidence_ids"]:
                entry = evidence[ref]
                if entry["kind"] != "proof_receipt":
                    continue
                receipt = json.loads(local_path(root, entry["local_path"]).read_text(encoding="utf-8"),
                                     object_pairs_hook=unique_keys)
                require(receipt["subject_commit"] == archive["source_commit"],
                        f"receipt is for a different source commit: {key}")
                require(receipt["claim_id"] == key and receipt["result"] == "success",
                        f"receipt does not attest this claim: {key}")
                require(bool(receipt["command"]) and bool(receipt["theorem_roots"])
                        and "axioms" in receipt, f"incomplete proof receipt: {key}")
                require(isinstance(receipt["axioms"], list)
                        and set(receipt["axioms"]) <= {"propext", "Classical.choice", "Quot.sound"},
                        f"receipt contains unapproved axiom dependencies: {key}")
        claims[key] = claim
    require(data["primary_claim"] in claims, "primary claim is missing")
    for claim in claims.values():
        require(all(ref in claims for ref in claim["depends_on"]),
                f"unknown dependency: {claim['id']}")
        require(claim["id"] not in claim["depends_on"], f"self dependency: {claim['id']}")
    def visit(key, active, done):
        require(key not in active, f"cyclic claim dependency: {key}")
        if key in done:
            return
        active.add(key)
        for dependency in claims[key]["depends_on"]:
            visit(dependency, active, done)
        active.remove(key)
        done.add(key)
    done = set()
    for key in claims:
        visit(key, set(), done)
    require(claims[data["primary_claim"]]["proof_status"] == "withdrawn_as_proof",
            "changing the historical withdrawal needs a separate reviewed migration")


def primary(data):
    return next(c for c in data["claims"] if c["id"] == data["primary_claim"])


def source(data):
    key = primary(data)["evidence_ids"][0]
    return next(e for e in data["evidence"] if e["id"] == key)


def archive_url(data):
    archive = data["archive"]
    return f"https://github.com/{archive['repository']}/tree/{archive['source_commit']}"


def notice(data, lang):
    claim = primary(data)
    return (f"**{label(claim, lang)} — {claim['status_date']}.** "
            f"{claim['public_summary'][lang]} "
            f"[{'Erratum' if lang == 'en' else 'Erratum scientifique'}]({source(data)['source_url']}).")


def readme(data, lang):
    fr = lang == "fr"
    title = "Archive historique T1′–T4" if fr else "T1′–T4 historical archive"
    current = "Statut scientifique actuel" if fr else "Current scientific status"
    text = f"# {title}\n\n> {notice(data, lang)}\n\n"
    text += f"## {current}\n\n"
    text += ("Les statuts et leurs sources sont détaillés dans le registre ci-dessous. "
             "Chaque énoncé conserve son périmètre de vérification.\n\n"
             if fr else
             "The register below records each status and its evidence. "
             "Each statement retains its own verification scope.\n\n")
    text += "- [CURRENT_STATUS.md](CURRENT_STATUS.md)\n"
    text += "- [governance/claims.json](governance/claims.json)\n"
    text += ("- [Copie de l’erratum](governance/evidence/ERRATUM_RH_T1T4_2026-10-13.md)\n"
             if fr else "- [Local erratum copy](governance/evidence/ERRATUM_RH_T1T4_2026-10-13.md)\n")
    text += "- [F-001](F001_ERRATUM.md)\n"
    text += f"\n## {'Documents historiques' if fr else 'Historical documents'}\n\n"
    text += ("Les textes antérieurs restent accessibles à leur commit historique. "
             "Leurs titres et conclusions sont ceux de l’époque et sont accompagnés du présent retrait.\n\n"
             if fr else
             "Earlier texts remain available at their historical commit. Their titles and conclusions "
             "record the earlier state and must be read with this withdrawal.\n\n")
    text += f"- [Archive {data['archive']['version']}]({archive_url(data)})\n"
    text += "- [Copies avec notice / Copies with notices](HISTORICAL_DOCUMENTS.md)\n"
    text += f"- [DOI historique / Historical DOI](https://doi.org/{data['archive']['doi']})\n"
    text += "- [Galerie historique / Historical gallery](https://couret-interia.github.io/rh-analytic-framework-t1t4/#gallery)\n"
    text += "\n## Reproduction\n\n```bash\npython3 scripts/status_manifest.py --check\npython3 -m unittest discover -s tests -v\n```\n\n"
    text += ("Ces commandes contrôlent la cohérence documentaire et les empreintes des sources. "
             "Elles ne constituent ni une relecture mathématique ni un audit d’antériorité.\n\n"
             if fr else
             "These commands check documentary consistency and source digests. "
             "They do not constitute mathematical review or an audit of prior art.\n\n")
    text += "[English](README.md) · [Français](README_FR.md) · [Maintenance](governance/README.md)\n"
    return text


def current_status(data):
    text = "# Current scientific status and evidence\n\n" + notice(data, "en") + "\n\n"
    text += notice(data, "fr") + "\n\n"
    text += "| Claim | Status | Evidence |\n|---|---|---|\n"
    for claim in data["claims"]:
        references = [e for e in data["evidence"] if e["id"] in claim["evidence_ids"]]
        links = ", ".join(f"[{e['id']}]({e['source_url']})" for e in references)
        text += (f"| {claim['id']}: {claim['statement']['en']} | {label(claim, 'en')} | "
                 f"{links} |\n")
    text += ("\n## Scope\n\n" + data["coverage"] + "\n\n"
             "This is a documentary withdrawal register. Its evidence is a source document; "
             "no independent mathematical replay, external review or novelty assessment is implied. "
             "The legacy DOI identifies the historical archive. The 15 current PDF copies carry "
             "an opening withdrawal notice; their 64 historical pages are retained. "
             "These annotated copies were not recompiled from the edited LaTeX sources. "
             "Original versions remain pinned at the historical commit. Existing tags, releases "
             "and the live Zenodo files are separate historical publications.\n\n"
             "## Generated surfaces\n\n"
             "The five root README files, this page, `index.html` and "
             "`governance/generated/zenodo-description.html` derive from `governance/claims.json`. "
             "The local metadata and the archive inventory are checked against this register. "
             "The live Zenodo record and the main WordPress site still require separate application "
             "and verification. A passing check does not assert that either was updated.\n")
    return text


def html_notice(data):
    claim = primary(data)
    return (f"<p><strong>{html.escape(label(claim, 'en'))} — {claim['status_date']}.</strong> "
            f"{html.escape(claim['public_summary']['en'])} "
            f'<a href="{html.escape(source(data)["source_url"], quote=True)}">Scientific erratum</a>.</p>\n'
            f'<p lang="fr"><strong>{html.escape(label(claim, "fr"))}.</strong> '
            f"{html.escape(claim['public_summary']['fr'])}</p>\n")


def gallery(data):
    text = ("<!doctype html>\n<html lang=\"en\">\n<head>\n<meta charset=\"utf-8\">\n"
            "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n"
            "<title>T1′–T4 historical archive and withdrawal</title>\n"
            "<style>body{font:18px/1.6 system-ui,sans-serif;max-width:52rem;margin:3rem auto;"
            "padding:0 1.25rem;color:#20252a;background:#fff}a{color:#164c8c}"
            "li{margin:.65rem 0}h1{line-height:1.2}footer{margin-top:2rem}</style>\n"
            "</head>\n<body>\n<main>\n<h1>T1′–T4 historical archive</h1>\n")
    text += html_notice(data)
    text += ("<h2 id=\"gallery\">Historical documents</h2>\n"
             "<p>The linked versions preserve the earlier record. Their arguments and any claims "
             "of a completed proof must be read with the withdrawal above. "
             "The 15 current PDF copies have an opening notice; their historical content is preserved. "
             "This editorial annotation is not mathematical validation. "
             '<a href="HISTORICAL_DOCUMENTS.md">Copies, counts and pinned originals</a>.</p>\n<ul>\n')
    base = archive_url(data).replace("/tree/", "/blob/")
    for path, title in [
        ("src/main_journal.pdf", "Historical journal, English"),
        ("src/main_journal_FR.pdf", "Historical journal, French"),
        ("theorems/T2_weighted_frame_full.tex", "T2 source, invalid argument as written"),
        ("theorems/T3_wavepacket_full.tex", "T3 source, incompatible normalization"),
    ]:
        text += (f'<li><a href="{path}">{title}, annotated copy</a> '
                 f'(<a href="{base}/{path}">pinned original</a>)</li>\n')
    text += ("</ul>\n<p><a href=\"https://github.com/" + data["archive"]["repository"]
             + "/blob/main/CURRENT_STATUS.md\">Current status and evidence</a></p>\n"
             "</main>\n<footer>Historical archive, MIT licence.</footer>\n</body>\n</html>\n")
    return text


def rendered(data):
    result = {path: readme(data, lang) for path, lang in READMES.items()}
    result["CURRENT_STATUS.md"] = current_status(data)
    result["index.html"] = gallery(data)
    result["governance/generated/zenodo-description.html"] = html_notice(data) + (
        "<p>This DOI identifies the historical T1′–T4 archive. The source documents are preserved "
        "for provenance. The withdrawal does not certify unrelated finite computations, "
        "independent review or mathematical priority.</p>\n")
    return result


def normalized(text):
    text = html.unescape(re.sub(r"<[^>]*>", "", text))
    text = unicodedata.normalize("NFKC", text).casefold()
    return text.translate(str.maketrans({c: "-" for c in "‐‑‒–—−"}))


def metadata_fields(data):
    title = "WITHDRAWN AS PROOF — Historical T1′–T4 analytic framework"
    description = rendered(data)["governance/generated/zenodo-description.html"]
    return {
        "zenodo.json": {"title": title, "description": description},
        "manifest.json": {"description": description},
        "CITATION.cff": {"title": title,
                         "message": "Cite this only as a historical archive withdrawn as a proof argument; include the erratum of 13 October 2026."},
    }


def check_archive(root, data):
    errors = []
    try:
        spec = data["archive_integrity"]
        inventory_path = local_path(root, spec["path"])
        require(sha256(inventory_path) == spec["sha256"], "archive inventory digest mismatch")
        inventory = json.loads(inventory_path.read_text(encoding="utf-8"), object_pairs_hook=unique_keys)
        require(inventory["historical_commit"] == data["archive"]["source_commit"],
                "archive inventory identifies another historical commit")
        names = [entry["path"] for entry in inventory["files"]]
        require(len(names) == len(set(names)), "duplicate archive file")
        for entry in inventory["files"]:
            target = local_path(root, entry["path"])
            require(target.is_file() and sha256(target) == entry["sha256"],
                    f"archive file missing or modified: {entry['path']}")
        for entry in inventory["historical_markdown"]:
            text = local_path(root, entry["path"]).read_text(encoding="utf-8")
            start, end = "<!-- BEGIN WITHDRAWN HISTORICAL CONTENT -->\n", "<!-- END WITHDRAWN HISTORICAL CONTENT -->"
            require(text.count(start) == text.count(end) == 1, f"historical quotation missing: {entry['path']}")
            historical = text.split(start, 1)[1].split(end, 1)[0]
            require(hashlib.sha256(historical.encode()).hexdigest() == entry["historical_sha256"],
                    f"historical quotation changed: {entry['path']}")
        for entry in inventory["theorem_sources"]:
            text = local_path(root, entry["path"]).read_text(encoding="utf-8")
            marker = "% END RETRACTION NOTICE\n"
            require(text.count(marker) == 1, f"theorem notice missing: {entry['path']}")
            require(hashlib.sha256(text.split(marker, 1)[1].encode()).hexdigest() == entry["historical_sha256"],
                    f"historical theorem changed: {entry['path']}")
        for name in inventory["tex_documents"]:
            text = local_path(root, name).read_text(encoding="utf-8")
            require("\\begin{document}\n\\input{retraction_notice.tex}" in text,
                    f"opening LaTeX notice missing: {name}")
        for path in (root / ".github/workflows").glob("*.y*ml"):
            for action in re.findall(r"uses:\s+([^\s#]+)", path.read_text(encoding="utf-8")):
                require(action.startswith("./") or re.fullmatch(r"[^@\s]+@[0-9a-f]{40}", action),
                        f"unpinned action: {path.name}: {action}")
    except (RegistryError, KeyError, TypeError, OSError, ValueError) as error:
        errors.append(str(error))
    return errors


def check_surfaces(root, data, outputs):
    errors = []
    for path, expected in outputs.items():
        target = local_path(root, path)
        if not target.is_file() or target.read_text(encoding="utf-8") != expected:
            errors.append(f"generated surface drift: {path}; run --write")
    for path in root.glob("README*.md"):
        if path.name not in READMES:
            errors.append(f"unregistered README entry point: {path.name}")
    metadata = json.loads((root / "zenodo.json").read_text(encoding="utf-8"), object_pairs_hook=unique_keys)
    description = outputs["governance/generated/zenodo-description.html"]
    if metadata.get("description") != description:
        errors.append("zenodo.json description differs from the register; run --write")
    for name, fields in metadata_fields(data).items():
        try:
            text = local_path(root, name).read_text(encoding="utf-8")
            if name.endswith(".json"):
                actual = json.loads(text, object_pairs_hook=unique_keys)
                for field, wanted in fields.items():
                    if actual.get(field) != wanted:
                        errors.append(f"{name}: metadata drift: {field}")
            else:
                for field, wanted in fields.items():
                    if f"{field}: {json.dumps(wanted, ensure_ascii=False)}" not in text.splitlines():
                        errors.append(f"{name}: metadata drift: {field}")
        except (OSError, ValueError) as error:
            errors.append(f"{name}: {error}")
    errors.extend(check_archive(root, data))
    if any(c["proof_status"] != "proved" for c in data["claims"]):
        for path in [*outputs, "zenodo.json"]:
            target = local_path(root, path)
            if target.is_file() and FORBIDDEN.search(normalized(target.read_text(encoding="utf-8"))):
                errors.append(f"incompatible proof-promotion wording: {path}")
    return errors


def check_release(data):
    raise RegistryError("proof release blocked: this register records a withdrawn historical argument; "
                        "a future correction release needs a separate reviewed publication decision")


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    parser.add_argument("--release", action="store_true", help="require a publication decision")
    args = parser.parse_args(argv)
    try:
        data = load_registry(ROOT)
        outputs = rendered(data)
        if args.write:
            for path, content in outputs.items():
                target = local_path(ROOT, path)
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_text(content, encoding="utf-8")
            for name, fields in metadata_fields(data).items():
                path = ROOT / name
                text = path.read_text(encoding="utf-8")
                if name.endswith(".json"):
                    metadata = json.loads(text, object_pairs_hook=unique_keys)
                    metadata.update(fields)
                    text = json.dumps(metadata, ensure_ascii=False, indent=2) + "\n"
                else:
                    for field, wanted in fields.items():
                        line = f"{field}: {json.dumps(wanted, ensure_ascii=False)}"
                        text = re.sub(rf"^{re.escape(field)}:.*$", lambda _: line, text, flags=re.M)
                path.write_text(text, encoding="utf-8")
        errors = check_surfaces(ROOT, data, outputs)
        require(not errors, "\n".join(errors))
        if args.release:
            check_release(data)
        print(f"Status consistency PASS: {len(data['claims'])} claims, {len(outputs)} generated surfaces; "
              "no mathematical, priority or live-publication certification.")
        return 0
    except (RegistryError, KeyError, TypeError, OSError, ValueError) as error:
        print(f"Status consistency FAIL: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
