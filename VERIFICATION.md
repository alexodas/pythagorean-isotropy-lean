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

Completed while developing this extension:

- The archive/signature preservation script and source-format checks pass.
- `ContinuousIsotropy.lean` compiled successfully with the pinned Lean
  `v4.35.0-rc2`; its reachability and length audits report only `propext`,
  `Classical.choice`, and `Quot.sound`.
- The compact multiplicative-character lemma compiled successfully.
- The initial max-norm development, including exact classification of its
  normal-form isometries, compiled successfully. A later direct-action
  impossibility corollary is included in the full verification target.

The full integrated Lake build and eleven-theorem Comparator check are
required for the current commit. Consult the
[Palomar preparation workflow](https://github.com/alexodas/pythagorean-isotropy-lean/actions/workflows/palomar.yml)
for its exact result; a green run must correspond to the current source.
Local Debian Bubblewrap is too old for the bundled Comparator, so the full
sandboxed comparison and independent kernels run on the Ubuntu CI runner.
The sandbox is not disabled to obtain a local result.

Lean checks and Comparator checks establish the stated implications, not
historical novelty, axiom minimality, or mathematical research interest.
See `RESEARCH.md` for the classical context and exact assumption tradeoff.
