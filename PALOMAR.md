# Palomar preparation based on the archived v0.1.0 release

This is a preparation branch, not a new GitHub release and not a new Zenodo
deposit. Submit only after the build and Comparator checks below succeed.

## Preservation of the published version

- Archived commit: `64c8ea3ef05d621814bc6460223f1f14d208f543`.
- Existing tag and GitHub release: `v0.1.0`.
- Version DOI: <https://doi.org/10.5281/zenodo.23326197>.
- Neither that tag, the release assets nor the Zenodo record is changed here.
- `manuscript/`, `.zenodo.json`, `AXIOMS.md` and `RELEASE_NOTES.md` retain
  their archived contents. A source hash check verifies this.
- Package version `0.1.1` distinguishes the preparation; it does not create a
  tag, release, or DOI. A published branch commit suffices for Palomar.
- The local checkout has its push URL disabled. To publish later, use a new
  branch only, after reviewing the changes; never force-update `v0.1.0`.

## What is compared

`Challenge.lean` independently states four original fully qualified theorems,
using their unchanged archived signatures and explicit hypotheses:

1. `primitive_quarter_turn_is_J`: linearity, oriented axis exchange and the
   half-turn law determine the quarter-turn matrix.
2. `determinant_one_from_primitive_rigidity`: axial length calibration,
   reflection symmetry and rigidity of the stated linear map imply
   `u^2 + v^2 = 1`.
3. `infinitesimal_J_from_primitive_quarter_turn`: for an additive rigid linear
   action containing that quarter-turn, the explicit normalization and
   derivative hypotheses eliminate radial scaling and give the generator
   `omega J`.
4. `pythagoras_from_metric_free_quarter_turn`: the explicit action,
   quarter-turn membership, length calibration, reflection symmetry, rigidity
   and axis reachability for the chosen vector imply `a^2 + b^2 = c^2`, where
   `L a b = c`.

The five explicit definitions in `comparator.json`, together with the reachable
structure and its fields, expose the meaning of those statements. The
Challenge imports Mathlib only. `Solution.lean` imports and publicly re-exports
the actual original proof declarations, rather than introducing a second proof
or hiding extra hypotheses in an alias.

## Scope, provenance and research context

This is a formalized conditional derivation of a known identity, not a proof of
historical novelty. The potential research audience is formalized foundations
of Euclidean geometry and the algebraic relation between planar symmetries,
primitive length and quadratic invariants. The specific contribution presented
for assessment is the explicit dependency chain separating primitive length
from the quadratic coordinate expression, and exposing the exact assumptions
needed by this derivation. Palomar must independently judge whether this meets
its research-interest threshold; no claim of eligibility or acceptance is made.

The action's existence is not derived from weaker incidence/congruence axioms.
Reachability of the selected vector is a premise and is not inferred from one
quarter-turn. The assumptions are not proved independent or minimal. The main
theorem has no derivative hypotheses; the separately advertised infinitesimal
result does. The Lie-theoretic discussion and any measure-theoretic consequence
in the manuscript are not advertised as fully formalized.

The archived source and README disclose that Alessandro Odasso initiated the
research question; OpenAI ChatGPT generated the original manuscript and assisted
the Lean development. The word "original" describes the research prompt. This
preparation was made with OpenAI Codex assistance. Human expert mathematical
peer review has not been established. See `formalization.yaml` for structured
source, authorship, automation, classification and limitation information.

## Changes in this preparation

- Add a small independent statement surface, a Solution re-export and explicit
  Comparator configuration.
- Migrate to the official starter's Lean `v4.35.0-rc2` / Mathlib pair and commit
  its pinned dependency closure. The archived version used `v4.34.0-rc1`.
- Add `module`, public visibility and exposed definition bodies, and narrow
  imports to the required Mathlib calculus and tactic modules. The packaging
  check verifies that no mathematical declaration or proof was changed.
- Add the standard CC-BY-4.0 root licence, as explicitly selected by the owner
  for this preparation, consistent with the Zenodo record.
- Provide a read-only Palomar verification workflow. Retire the one-time release
  publishing workflow on this new branch to prevent accidental re-execution;
  its archived version remains in `v0.1.0`. The manuscript workflow on this
  branch also saves only an artifact and can no longer commit to `main`.

## Verification

Run in a Linux environment with the pinned Lean toolchain, Python 3, Git and
a recent Bubblewrap supporting `--clearenv`:

```sh
python3 scripts/check-packaging.py
python3 scripts/check-lean-sources.py
lake exe cache get Mathlib.Analysis.Calculus.Deriv.Pow Mathlib.Analysis.Calculus.MeanValue Mathlib.Tactic.Convert Mathlib.Tactic.Linarith Mathlib.Tactic.Ring
lake build
bash scripts/verify-comparator.sh
```

`lake build` is allowed to report the four deliberate Challenge `sorry`s. The
proof module and Solution must have no admissions. Comparator checks that the
proved Solution declarations implement the independent Challenge declarations,
using only `propext`, `Classical.choice` and `Quot.sound`; the script also uses
the toolchain's bundled NanoDa and con-ron kernels, as in Palomar's starter.

Local validation results are delivered separately in `VERIFICATION.md`.

## Later submission without changing Zenodo

After successful checks, publish the preparation on a new branch such as
`palomar-preparation`. Do not create a GitHub release or move an existing tag.
There is no need to merge the branch into `main` to submit its commit to
Palomar. The repository's Zenodo release integration is not triggered by a
normal branch push or pull request.

Use <https://submit.palomar-registry.org/> with repository
`alexodas/pythagorean-isotropy-lean` and the new branch's full 40-character commit
SHA. The project is at repository root and uses the conventional metadata and
Comparator paths. Authenticate with a GitHub account that can push and retain
the private submission-status URL. Read the automated report before choosing
registration, which is a separate, durable publication of the registry record.
