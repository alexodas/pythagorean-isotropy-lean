# The Coordinate Pythagorean Theorem from Planar Isotropy — Lean 4

A Lean 4 + Mathlib formalization accompanying Alessandro Odasso's manuscript,
*The Coordinate Pythagorean Theorem from Planar Isotropy: A Lie-Theoretic and Axiomatic Derivation* (18 August 2026).

The project formalizes an axiomatic implication from **primitive congruence and planar symmetries** to the coordinate Pythagorean identity. The geometric length function is an independent function `L : ℝ → ℝ → ℝ`; it is **not** defined using `sqrt (x² + y²)`.

## Mathematical content

The main formalization is [`PythagoreanIsotropy.lean`](./PythagoreanIsotropy.lean).

Selected theorems:

| Lean theorem | Result |
| --- | --- |
| `quadratic_generator_invariant_iff` | Characterizes symmetric quadratic forms infinitesimally invariant under the normalized generator. |
| `quadratic_conserved` | Shows `x² + y²` is constant along a solution of `x' = -y`, `y' = x`. |
| `determinant_one_from_primitive_rigidity` | Deduces `u² + v² = 1` for a rigid quarter-turn-compatible linear map. |
| `radial_derivative_zero_from_rigidity` | Eliminates radial infinitesimal scaling. |
| `primitive_quarter_turn_is_J` | Derives `Q(x,y) = (-y,x)` from axis exchange and the half-turn law. |
| `primitive_quarter_turn_forces_flow_shape` | Derives the shape of an additive linear flow containing the quarter-turn. |
| `infinitesimal_J_from_primitive_quarter_turn` | Derives the infinitesimal generator `ωJ` under differentiability and rigidity. |
| `pythagoras_from_metric_free_quarter_turn` | Derives `a² + b² = c²` from the stated congruence, symmetry and axis-transitivity hypotheses. |

## Explicit foundational assumptions

The final theorem **does not** assume the Pythagorean identity, a Euclidean norm, or a Euclidean inner product as the definition of geometric length. It does explicitly assume:

1. A **linear** quarter-turn `Q` satisfying `Q(1,0) = (0,1)` and `Q²(P) = -P`.
2. A one-parameter **additive linear action** `F` containing `Q`, with `F(s+t) = F(s) ∘ F(t)`.
3. **Axial calibration** `L(z,0) = |z|` and **mirror symmetry** `L(x,-y) = L(x,y)`.
4. **Rigidity** `L(F(t)P) = L(P)` for each group element.
5. For the chosen vector `(a,b)`, an **axis-hit** assumption: some `F(t)` sends it to `(z,0)` with `z ≥ 0`.
6. `c = L(a,b)`.

For the separate infinitesimal-generator theorem, the requisite derivatives at zero and normalization `F(0)` are also explicit premises.

**Scope:** Lean checks that the conclusions follow from these assumptions. The project does *not* yet prove from more primitive incidence/congruence axioms that this entire rotation group exists, nor does it establish minimality or independence of the hypotheses. In particular, axis transitivity is an assumption, not a proven consequence of the presence of a single quarter-turn.

## Reproduce the Lean check

The exact Lean toolchain and a pinned Mathlib revision are provided.

```bash
lake update
lake exe cache get
lake env lean PythagoreanIsotropy.lean
```

The GitHub Actions workflow [`lean.yml`](./.github/workflows/lean.yml) runs the same check on pushes and pull requests.

## Provenance and disclosure

- Mathematical manuscript: Alessandro Odasso, 18 August 2026 (title above).
- Formalization developed with assistance from OpenAI ChatGPT and iteratively checked with the Lean compiler using GitHub Actions.
- The proof contains no `sorry` tactics; its hypotheses remain transparent in the theorem signatures.
- This public repository contains only the Lean proof, project metadata, and CI configuration; it does not publish material from the earlier private development repository.

## Citation and licensing

For now, cite this repository by URL and commit hash. A versioned release may later be archived on Zenodo for a DOI.

**No open-source license has been selected yet.** Public visibility alone should not be interpreted as a license to redistribute or modify the material.
