# Verification record

## Archive boundary

Archived commit: `64c8ea3ef05d621814bc6460223f1f14d208f543`, tag `v0.1.0`.
The archive-preservation script still verifies the exact old proof text after
removing only the documented module/import adaptation, plus the unchanged
manuscript, `.zenodo.json`, `AXIOMS.md`, and `RELEASE_NOTES.md`.
The four archived Challenge signatures are still checked against their
original SHA-256 hashes. New theorems are added in separate modules.

The observed `main` commit before this extension is
`3de6c3fbc0c659b2121f222e6d69437e106a4926`. The archived PDF SHA-256 is
`686bb766e138173770a9dded1923efb369db3528bfd6e11751642485ff6c3de5`.

## Previously completed checks, before the new extension

The preparation at `90c09aacea965686925cc41e588f395b254c0c69` passed its
[GitHub verification](https://github.com/alexodas/pythagorean-isotropy-lean/actions/runs/39231914593)
and [Palomar mechanical verification](https://github.com/PalomarRegistry/PalomarSubmission/actions/runs/39233022143).
Those results concern the earlier four-theorem package. They must not be
mistaken for verification of newly added code.

## Current continuous-isotropy extension

The independent Challenge now selects eleven theorems and six definitions.
Its eleven `sorry` placeholders are intentional specification placeholders.
The proof modules have no admitted proofs or new global axioms.

## Successful integrated verification

The complete extension at commit
`a7971a5c8f282c64845286f80e1771d8f7205664` passed
[GitHub verification run 39242062564](https://github.com/alexodas/pythagorean-isotropy-lean/actions/runs/39242062564).

- The full Lake build succeeded, including `EuclideanModel`, the final
  existence equivalence, the counterexamples, Challenge, and Solution.
- Comparator accepted all eleven requested theorem declarations and six
  definitions against the independent Challenge.
- The configured independent-kernel replay with the toolchain's bundled
  NanoDa and con-ron completed successfully in the Linux sandbox.
- Only `propext`, `Classical.choice`, and `Quot.sound` are permitted.
- The archived proof text, source assets and original four signatures
  passed their preservation checks.

The subsequent README title, metadata project title and this verification
record are documentation updates; the tested Lean sources and Comparator
configuration are unchanged from that successful commit.

Additional local checks completed while developing this extension:

- The archive/signature preservation script and source-format checks pass.
- `ContinuousIsotropy.lean` compiled successfully with the pinned Lean
  `v4.35.0-rc2`; its reachability and length audits report only `propext`,
  `Classical.choice`, and `Quot.sound`.
- The compact multiplicative-character lemma compiled successfully.
- The max-norm development, including its direct-action impossibility
  corollary, compiled successfully, with the same standard axiom set.
- `CompactIsotropy.lean` compiled successfully with standard axiom audits
  for quadratic preservation and the mirror-free length characterization.
- Metadata validates against the pinned official v0.4 schema.

Consult the
[Palomar preparation workflow](https://github.com/alexodas/pythagorean-isotropy-lean/actions/workflows/palomar.yml)
for the check of any later changes; a green run must correspond to their source.
Local Debian Bubblewrap is too old for the bundled Comparator, so the full
sandboxed comparison and independent kernels run on the Ubuntu CI runner.
The sandbox is not disabled to obtain a local result.

Lean checks and Comparator checks establish the stated implications, not
historical novelty, axiom minimality, or mathematical research interest.
See `RESEARCH.md` for the classical context and exact assumption tradeoff.
