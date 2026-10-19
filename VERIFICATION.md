# Verification record

Prepared on 19 October 2026 from archived commit
`64c8ea3ef05d621814bc6460223f1f14d208f543`.

## Completed preservation and packaging checks

- The public GitHub `v0.1.0` tag resolves to the archived commit above.
- Existing GitHub release ID: `410986254`.
- Existing release PDF SHA-256:
  `686bb766e138173770a9dded1923efb369db3528bfd6e11751642485ff6c3de5`.
- The local PDF also matches the public release asset digest above.
- The archived PDF, manuscript source, `.zenodo.json`, `AXIOMS.md` and
  `RELEASE_NOTES.md` match the archived Git blobs, using canonical LF text.
- Removing only the documented module/import/visibility adaptation recovers
  the exact original mathematical proof source.
- All four independent Challenge theorem signatures match the archived source
  signatures exactly, including each explicit hypothesis.
- The Challenge imports only the pinned Mathlib derivative basics, contains
  four intentional proof placeholders, and meets the source-size limits.
- Every project Lean source uses `module` and meets the 10,000-line cap.
- `formalization.yaml` validates against the official upstream v0.4 schema.
- The Mathlib revision agrees between Lake configuration and the committed
  manifest, and every dependency revision is pinned to a full commit.
- Every retained/new workflow has `contents: read`; there is no release
  publisher or automatic branch-write step in this preparation.
- `git diff --check` passed.

Schema reference commit: `99c678e569c7c4c0772db297c5ddd5e4c9b6322e` in
`mathlib-initiative/formalization.yaml`.
Starter reference commit: `2891de4c48955af824969a263d31b25e7a9a1406` in
`PalomarRegistry/PalomarTemplate`.

## Lean and independent proof verification

`lake build` **passed**, reporting "Build completed successfully (2101 jobs)"
with Lean `v4.35.0-rc2` in an isolated temporary Linux workspace. It built
`Challenge`, `PythagoreanIsotropy` and `Solution` successfully. The four
Challenge admission warnings are deliberate. The remaining proof-source
warnings are style-linter messages inherited from the preserved proof text.

The four selected proof declarations each printed exactly the permitted
dependencies `propext`, `Classical.choice`, and `Quot.sound`. No extra axiom
was reported in those audits.

The final Comparator run **could not complete** in the local environment:
Debian's Bubblewrap `0.4.1` rejects the sandbox flag `--clearenv` used by the
bundled Comparator. The environment also lacks the development tools needed
for a straightforward isolated Bubblewrap build. The sandbox was not disabled
or bypassed. The script now detects that missing capability explicitly.

This is an environment limitation, not a successful Comparator result. The
included `.github/workflows/palomar.yml` runs the full comparison and bundled
independent kernels on a current Ubuntu runner. That check remains required
before describing the preparation as fully verified for submission. Local
compilation and a kernel-axiom audit do not replace it.

## External state

Only the separate `palomar-preparation` branch is intended for publication.
Publication was attempted but did not succeed: the GitHub connector returned
HTTP 403 (integration access), and local Git had no authenticated session.
No remote branch was created and no repository content was changed remotely.
The existing `main` branch, tags, releases and Zenodo records are not changed.
The observed `main` commit before publication was
`3de6c3fbc0c659b2121f222e6d69437e106a4926`.
No Palomar submission is made by this preparation. The source DOI remains
<https://doi.org/10.5281/zenodo.23326197>. A future Palomar submission must name
the new preparation commit, not the archived release commit.
