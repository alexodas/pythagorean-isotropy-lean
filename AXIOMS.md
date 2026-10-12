# Axiom and hypothesis audit

This document distinguishes **geometric premises stated in theorem signatures** from **Lean's global logical axioms**. It accompanies the compiled source [`PythagoreanIsotropy.lean`](./PythagoreanIsotropy.lean).

## 1. Main theorem — exact statement of the assumptions

The strongest group-theoretic conclusion is
`PythagoreanIsotropy.pythagoras_from_metric_free_quarter_turn`.

The objects supplied to this theorem are:

- `L : ℝ → ℝ → ℝ`: a **primitive** function representing the length of a displacement `(x,y)`. The theorem does *not* define `L` using `sqrt (x² + y²)`.
- `F : ℝ → LinearPlaneEnd`: an indexed family of *linear maps* `F t` of the plane.
- `Q : LinearPlaneEnd`: a chosen primitive quarter-turn.
- `a b c : ℝ`: the two coordinates and their stipulated length `c`.

Its **eight named hypotheses** are as follows.

| Lean hypothesis | Mathematical content | Status |
| --- | --- | --- |
| `hAction` | For every `s,t,x,y`, `F(s+t)(x,y) = F(s)(F(t)(x,y))`. | Assumed group composition law. Invertibility follows from the remaining structure rather than being separately postulated. |
| `hQ` | `Q(1,0)=(0,1)` and `Q²(x,y)=(-x,-y)` for all `x,y`. | Assumed oriented quarter-turn **geometric characterization**, *not* its coordinate matrix. |
| `hMember` | There exists a parameter `θ` such that `F θ = Q`. | Assumes the quarter-turn belongs to the action. |
| `hAxis` | `L(z,0)=|z|` for every real `z`. | Assumed axial length calibration. |
| `hMirror` | `L(x,-y)=L(x,y)` for all real `x,y`. | Assumed reflection symmetry. |
| `hRigid` | For every parameter and vector, `L(F t (x,y))=L(x,y)`. | Assumed primitive congruence/rigidity of the action. |
| `hToAxis` | For the **given** vector `(a,b)`, there exist `t,z` with `z≥0` and `F t (a,b)=(z,0)`. | Assumed **axis reachability** for this vector. Full transitivity across all rays is stronger and **not** what is formally assumed in this final theorem. |
| `hc` | `L(a,b)=c`. | Identifies the numerical `c` with the stipulated geometric length of the vector. |

**Proven consequence:** `a ^ 2 + b ^ 2 = c ^ 2`.

The definitions of `LinearPlaneEnd` and its `act` operation use the ordinary linear structure of `ℝ²`. The real-number arithmetic, absolute value, and polynomial operations used in the proof are supplied by Lean/Mathlib.

## 2. What is actually derived

1. **Quarter-turn coordinate formula:** `primitive_quarter_turn_is_J` derives `Q(x,y)=(-y,x)` from `hQ` and linearity.
2. **Commutation and flow matrix:** `primitive_quarter_turn_forces_flow_shape` derives `F_t(x,y)=(u_t x-v_t y, v_t x+u_t y)` from `hAction`, `hQ`, `hMember`. No coordinate matrix is postulated for `Q` or `F_t`.
3. **No radial scaling:** `determinant_one_from_primitive_rigidity` derives `u_t²+v_t²=1` using `hAxis`, `hMirror`, and `hRigid`. This is **not** taken as an axiom.
4. **Coordinate theorem:** `pythagoras_from_metric_free_quarter_turn` uses `hToAxis` and `hc` to identify the invariant axial coordinate with geometric length.

The separate theorem `infinitesimal_J_from_primitive_quarter_turn` adds **extra hypotheses** `(F 0).a=1`, `(F 0).c=0`, and the existence of the derivatives at zero of the coefficient functions. It derives the generator `ωJ`. The final Pythagorean theorem does **not** depend on these differentiability hypotheses or on matrix exponentiation.

## 3. Two distinct meanings of “axiom”

In Lean, `#print axioms THEOREM` reports **global logical axioms** in the kernel-level dependency graph of that theorem. It does **not** enumerate the mathematical *hypotheses* written in the theorem signature.

The following four commands are executed by the public GitHub Action:

```lean
#print axioms PythagoreanIsotropy.primitive_quarter_turn_is_J
#print axioms PythagoreanIsotropy.determinant_one_from_primitive_rigidity
#print axioms PythagoreanIsotropy.infinitesimal_J_from_primitive_quarter_turn
#print axioms PythagoreanIsotropy.pythagoras_from_metric_free_quarter_turn
```

**Observed in the successful public Lean compilation (12 October 2026):** each of the four selected theorem declarations depends on exactly `propext`, `Classical.choice`, and `Quot.sound`. These are standard kernel-level logical axioms, **not** geometric length assumptions. Their appearance is not a circular use of the Pythagorean theorem. The CI audit now rejects any additional global axiom dependency, as well as `sorryAx` admissions, for these four declarations.

The CI job captures the complete Lean log and **fails if any selected reported dependency set contains an axiom other than the three above**. Check the GitHub Actions logs for the actual per-theorem outputs. It is important not to mistake an absence of `sorryAx` for a proof of axiom minimality.

## 4. What the formalization does not establish

- It does **not** derive the existence of the entire transitive rotation action from bare incidence, congruence, or continuity axioms.
- It does **not** prove the geometric assumptions are independent, minimal, or philosophically primitive.
- It does **not** yet construct and check a model satisfying **all** geometric premises inside Lean. Euclidean geometry supplies an ordinary intended model, but the project does not formalize that model.
- It does **not** certify that this derivation is historically novel or that no similar argument appears in earlier literature.
- `#print axioms` does **not** certify that the informal geometric interpretation perfectly matches the formal statement; the theorem signature should always be read.

## 5. How to reproduce

```sh
lake update
lake exe cache get
lake env lean PythagoreanIsotropy.lean
```

The [GitHub Actions workflow](./.github/workflows/lean.yml) runs these commands on every push and pull request. It also records the `#print axioms` output and checks for any dependency on admitted `sorry` proofs.

## Attribution

The project was developed using ChatGPT, with the motivating research question initiated by Alessandro Odasso. The manuscript and README provide the full AI-generation disclosure. Mathematical rigor and claims of originality are separate questions.
