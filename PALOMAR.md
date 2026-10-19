# Research branch and possible future Palomar submission

The current development is described in **RESEARCH.md**. Package version is
0.2.0; this is a branch, not a GitHub release or a new Zenodo deposit.

The new continuous-action characterization and explicit model replace the
previous per-vector statement as the main development focus. Eleven theorems
are selected in `comparator.json`, including four unchanged archived results.
The independent `Challenge.lean` imports only Mathlib; `Solution.lean`
re-exports the substantive proofs. Deliberate Challenge placeholders are not
admissions in the proof development.

## Required checks

```sh
python3 scripts/check-packaging.py
python3 scripts/check-lean-sources.py
lake build
bash scripts/verify-comparator.sh
```

The GitHub workflow runs these checks and the bundled independent kernels.
See `VERIFICATION.md` for results actually obtained. Technical success does
not establish historical novelty, research interest or acceptance by Palomar.
No further Palomar submission is authorized by this development.

## Archive preservation

The archived tag `v0.1.0` points to
`64c8ea3ef05d621814bc6460223f1f14d208f543` and remains unchanged, as do its
release assets and DOI <https://doi.org/10.5281/zenodo.23326197>.
`PythagoreanIsotropy.lean` retains the old mathematics and the previously
documented module/import adaptation. The manuscript, `.zenodo.json`,
`AXIOMS.md`, and `RELEASE_NOTES.md` preserve their archived contents.
The latter documents concern the archived result, not the new theorem.

Keep this work on `palomar-preparation`; do not merge it into main or create
a release automatically. A possible future submission must identify its exact
new commit and should follow independent mathematical and literature review.
