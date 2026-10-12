# v0.1.0 — First public archived release

**Title:** The Coordinate Pythagorean Theorem from Planar Isotropy: An Axiomatic Derivation with Lie-Theoretic Extensions

This version packages a Lean 4/Mathlib formalization and its AI-generated accompanying mathematical manuscript.

## Contents

- [`PythagoreanIsotropy.lean`](./PythagoreanIsotropy.lean): formal proofs of the primitive quarter-turn normal form, rigidity constraints, a conditional Pythagorean theorem, and separate Lie-theoretic extensions.
- [`AXIOMS.md`](./AXIOMS.md): precise statements of the geometric hypotheses and Lean kernel axiom audit.
- [Manuscript PDF](./manuscript/pythagorean_isotropy_ai_disclosure.pdf) and [LaTeX source](./manuscript/pythagorean_isotropy_ai_disclosure.tex).
- Pinned Lean toolchain and Mathlib dependency, with GitHub Actions for Lean verification and PDF generation.

## Attribution and scientific scope

**Alessandro Odasso** initiated the research question, asking ChatGPT to seek an original proof of the Pythagorean theorem. **OpenAI ChatGPT (GPT-6, High thinking effort)** generated the original manuscript. The formalization and subsequent manuscript revisions were developed with AI assistance, with public Lean 4/Mathlib compilation and axiom-dependency checks.

The geometric length `L` is not defined by a Cartesian Euclidean norm. The final theorem derives `a²+b²=c²` from expressly stated geometric and algebraic premises; in particular, axis reachability is assumed for the chosen vector. Compilation does not establish independence or minimality of these premises, nor does it establish priority or historical novelty.

## Archiving and license

The GitHub repository has no separate `LICENSE` file. Its archived software release is intended to use **Zenodo's default license (CC BY 4.0)**. The `.zenodo.json` metadata intentionally omits a `license` key, allowing Zenodo to select its default when ingesting the GitHub release. The effective license and DOI should be verified in the Zenodo record once processing completes.

Repository: https://github.com/alexodas/pythagorean-isotropy-lean
