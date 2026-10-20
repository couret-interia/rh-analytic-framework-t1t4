# Claim register maintenance

This first register covers the historical T1′–T4 withdrawal and the two errors
documented in the erratum of 13 October 2026. It does not inventory the entire
research programme. Its canonical source is `governance/claims.json` in this
repository. Other consumers must use a pinned revision of that source rather
than maintain another editable copy.

## Fields and evidence

Each claim has a stable ID, an English and French statement, a proof status,
a status date, evidence references and dependencies. Separate fields record
external review and bibliographic priority. These fields are not inferred from
a successful build, a DOI, another claim, or an AI-generated report.

Entry modes describe how an item entered the register: `E` means executed in
the registering session; `C` means copied from an identified source; `R` means
recovered from historical conversation. All three entries in this first lot
are `C`: the erratum was read, not independently re-proved in this change.

Supported proof statuses are `withdrawn_as_proof`, `refuted_as_stated`,
`unverified`, `observed`, `conditional` and `proved`. The last status requires
a hashed local proof receipt for the exact source commit and claim, with the
command, theorem roots, axiom dependencies and success result. In this pilot
the allowed axiom dependencies are `propext`, `Classical.choice` and `Quot.sound`;
`sorryAx` and compiler-trust additions are rejected. That receipt
remains an assertion to inspect: the documentary checker does not run Lean or
verify the truth or adequacy of an encoded theorem. This pilot explicitly
prevents re-promoting the historical primary RH claim.

No existing programme notation such as `[D]`, `[O]` or the novelty gate `N`
is silently redefined. A later programme-wide migration must preserve each
register's definitions and source boundaries.

The local erratum copy is pinned to its source repository, full commit SHA,
path and SHA-256. It is documentary evidence, not an execution receipt.

## Generation and checks

```bash
python3 scripts/status_manifest.py --write
python3 scripts/status_manifest.py --check
python3 -m unittest discover -s tests -v
```

The five root README files, `CURRENT_STATUS.md`, `index.html` and the Zenodo
description export are generated. The generator updates only the description
field of `zenodo.json`; identifiers, creators and the historical release date
are preserved. Edit the register and renderer, then regenerate. The checker
rejects output drift, missing evidence, hash changes, duplicate JSON keys,
unknown evidence references, an unregistered root README, and incompatible
promotion wording in registered current surfaces. It also recognizes common
Unicode hyphens and HTML-encoded wording. This is a bounded consistency check,
not a semantic validator for every possible public sentence.

Historical LaTeX, PDFs, tags, releases and previous commits remain available.
They are outside this checker’s mathematical certification. The gallery links
to a pinned historical commit and displays the withdrawal beside those links.
The old release template and packaging workflow cannot authorize a new release:
`--check --release` fails for this historical-withdrawal register. A later
correction package needs an explicit reviewed publication decision and warning
coverage inside every downloadable document before this gate can change.

## Applying other public surfaces

`governance/generated/zenodo-description.html` is a prepared description for the
existing DOI record. Generation does not update Zenodo. After a separate
metadata edit, compare the rendered live description with this export and
record its URL and verification time. Apply the same method to WordPress.
The live site and Zenodo are not included in the local PASS result.

The new CI job runs on pushes and pull requests without repository write
permissions. Its presence alone does not make it a required branch-protection
check; an administrator must configure that repository setting separately.

## Next migration

Inventory the current claim registers before extending coverage to STROBO,
Cayley or other branches. Import exact claim scopes and pinned evidence;
do not populate their current scientific status from the integral audit alone.
The registry location should be migrated once, with pinned consumer references,
if a programme-wide canonical repository is later selected.
