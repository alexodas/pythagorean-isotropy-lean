# Continuous Planar Isotropy and Euclidean Length — Lean 4

This repository formalizes a mathematical answer to a precise question:

> **If planar length is initially an unknown function, when do rigid planar symmetries force the Pythagorean formula?**

The current `palomar-preparation` branch establishes a **characterization**: an axially calibrated function \(L : \mathbb R^2 \to \mathbb R\) admits a continuous additive **linear** action containing a primitive oriented quarter-turn and preserving \(L\) **if and only if**

\[
L(x,y)=\sqrt{x^2+y^2}\quad\text{for every }x,y.
\]

The forward direction **does not define** the primitive length by this formula. It proves the formula from explicit motion, continuity, calibration, and rigidity assumptions. The reverse direction constructs a model using ordinary sine and cosine. The proof is checked in **Lean 4/Mathlib**; it is **not** a derivation of rotational motions from purely synthetic incidence axioms, an axiom-minimality result, or a claim of historical novelty.

## Start with the explanatory manuscript

**[Read the current English manuscript (PDF)](./manuscript/continuous_planar_isotropy_explained.pdf)**  
[LaTeX source](./manuscript/continuous_planar_isotropy_explained.tex)

*Continuous Planar Isotropy and the Pythagorean Formula: A Plain-English Explanation of Lean-Formalized Hypotheses and Proofs* explains the assumptions, logical steps, converse, and counterexample in the order of the Lean modules, without requiring the reader to know Lean. This is the **current explanatory edition**.

**Disclosure of the research prompt and AI authorship.** Alessandro Odasso asked OpenAI's ChatGPT whether it could find an *original proof of the Pythagorean theorem*. The manuscript and proposed mathematical argument were AI-generated with ChatGPT (GPT-6, High thinking effort); the formalization and extensions were developed with AI assistance and checked in Lean. The term *original* describes the **question Odasso asked**, not an independently established claim of mathematical priority or novelty. This disclosure also appears prominently in the PDF.

The previously archived [manuscript (PDF)](./manuscript/pythagorean_isotropy_ai_disclosure.pdf) and its [LaTeX source](./manuscript/pythagorean_isotropy_ai_disclosure.tex) remain available **unchanged**. They belong to the published `v0.1.0` archive. The preservation checks protect those exact files, so the newer explanatory edition uses separate filenames rather than overwriting the historical record.

## Mathematical hypotheses

For the main characterization, take an arbitrary function \(L : \mathbb R^2\to\mathbb R\) satisfying **axial calibration** \(L(z,0)=|z|\). No positivity, norm structure, continuity of \(L\), or reflection symmetry is assumed.

The assertion on the left side of the equivalence is the **existence** of a real-indexed family \(F_t\) of linear planar maps and a linear map \(Q\) such that:

| Requirement | Precise meaning |
| --- | --- |
| Additive action | \(F_{s+t}=F_s\circ F_t\) for all real \(s,t\) |
| Primitive quarter-turn | \(Q(1,0)=(0,1)\) and \(Q^2=-I\), without assuming its matrix |
| Membership | \(F_\theta=Q\) for some real \(\theta\) |
| Continuity | The two first-column coefficient functions \(t\mapsto(F_t)_{11}\), \(t\mapsto(F_t)_{21}\) are continuous |
| Rigid congruence | \(L(F_t(x,y))=L(x,y)\) for all \(t,x,y\) |

Linearity is a genuine assumption, encoded in `LinearPlaneEnd`. The theorem does not claim that such an action is forced by elementary incidence, betweenness, or congruence axioms.

## Proof in the same order as Lean

1. **Recover the quarter-turn and motion normal form.** From \(Q(1,0)=(0,1)\) and \(Q^2=-I\), linearity forces \(Q(x,y)=(-y,x)\). The action commutes with \(Q\), giving
   \[
   F_t(x,y)=(u(t)x-v(t)y,\;v(t)x+u(t)y).
   \]
   The action at zero is the identity.

2. **Exclude radial scaling using compactness.** Set \(s(t)=u(t)^2+v(t)^2\). The action law gives \(s(t+r)=s(t)s(r)\); the quarter-turn gives a nonzero period, and continuity makes the range compact. Taking a maximum and then applying \(s(t)s(-t)=1\) forces \(s(t)=1\). Thus every \(F_t\) preserves **the coordinate quadratic expression** \(x^2+y^2\), without assuming it equals \(L^2\).

3. **Derive axis reachability.** The second coordinate of \(F_t(a,b)\) is continuous. It equals \(b\) at the identity and \(-b\) at the half-turn. By the intermediate value theorem it vanishes somewhere; an additional half-turn, if necessary, makes the first coordinate nonnegative.

4. **Identify primitive length.** If \(F_T(a,b)=(z,0)\) with \(z\ge0\), quadratic preservation gives \(z^2=a^2+b^2\). Rigidity and calibration independently give \(L(a,b)=L(z,0)=z\). Consequently
   \[
   \boxed{L(a,b)=\sqrt{a^2+b^2}}\qquad\text{and}\qquad
   \boxed{a^2+b^2=L(a,b)^2}.
   \]
   Mirror symmetry follows from this identification; it is **not** an extra premise.

5. **Prove the converse.** The explicit model \(F_t=\bigl(\begin{smallmatrix}\cos t&-\sin t\\\sin t&\cos t\end{smallmatrix}\bigr)\), with \(Q=F_{\pi/2}\), satisfies the same hypotheses and preserves the Euclidean length.

The equivalence is `PythagoreanIsotropy.continuous_isotropy_iff_euclidean_length` in [`IsotropyCharacterization.lean`](./IsotropyCharacterization.lean). Supporting formal statements are mapped below.

### Lean proof map

| Mathematical step | Formal theorem or definition | File |
| --- | --- | --- |
| Primitive quarter-turn \(Q(x,y)=(-y,x)\) | `primitive_quarter_turn_is_J` | [`PythagoreanIsotropy.lean`](./PythagoreanIsotropy.lean) |
| Linear flow shape | `primitive_quarter_turn_forces_flow_shape` | [`PythagoreanIsotropy.lean`](./PythagoreanIsotropy.lean) |
| Identity and axis crossing | `action_zero_of_primitive_quarter_turn`, `axis_reachable_of_continuous_action` | [`ContinuousIsotropy.lean`](./ContinuousIsotropy.lean) |
| Compact nonnegative character | `periodic_nonnegative_character_eq_one` | [`CompactCharacter.lean`](./CompactCharacter.lean) |
| Quadratic preservation | `continuous_action_preserves_quadratic` | [`CompactIsotropy.lean`](./CompactIsotropy.lean) |
| Length and derived mirror | `length_eq_sqrt_without_mirror`, `mirror_symmetry_of_continuous_isotropy` | [`CompactIsotropy.lean`](./CompactIsotropy.lean) |
| Standard trigonometric model | `continuous_isotropy_model_of_euclidean_length` | [`EuclideanModel.lean`](./EuclideanModel.lean) |
| Existence equivalence | `continuous_isotropy_iff_euclidean_length` | [`IsotropyCharacterization.lean`](./IsotropyCharacterization.lean) |
| Finite-symmetry obstruction | `boxLength_rigid_normal_iff`, `boxLength_no_additive_quarter_turn_action` | [`IsotropyCounterexamples.lean`](./IsotropyCounterexamples.lean) |

### Relation to the archived Pythagorean theorem

The archived theorem `pythagoras_from_metric_free_quarter_turn` in `PythagoreanIsotropy.lean` has **eight explicit hypotheses**: action law, primitive quarter-turn, membership, axial calibration, **mirror symmetry**, rigidity, **reachability of the positive horizontal axis for the chosen vector**, and identification \(c=L(a,b)\). It needs **no continuity** assumption. Its normal-form proof obtains \(u^2+v^2=1\) using rigidity, reflection, and axial calibration, and then proves \(a^2+b^2=c^2\).

The newer result makes a different assumption tradeoff: continuity of two motion coefficients **replaces the need to assume reachability**; compactness eliminates the mirror premise; the conclusion identifies **all** of \(L\), not merely the square of one chosen length. Neither theorem claims its hypotheses are independent or minimal. See [`RESEARCH.md`](./RESEARCH.md) for the exact comparison, and [`AXIOMS.md`](./AXIOMS.md) for the **archived** theorem's eight-parameter audit.

### Why finite rotations do not suffice

`IsotropyCounterexamples.lean` formalizes \(B(x,y)=\max(|x|,|y|)\). This is a genuine norm, axially calibrated and invariant under the coordinate quarter-turn and reflection, yet \(B(1,1)^2=1\ne2\). Its rigid maps of the rotational normal form are only the four coordinate quarter-turns. In particular, it **cannot** support a rigid additive real action containing the primitive quarter-turn: such an action would also contain its rigid square root at time \(\theta/2\). The counterexample rejects a **finite-symmetry-only** inference; it does not satisfy all premises of either main theorem.

## Lean environment and reproducibility

This preparation uses the toolchain pinned in [`lean-toolchain`](./lean-toolchain): **Lean `v4.35.0-rc2`**, with a specific Mathlib revision pinned by [`lakefile.toml`](./lakefile.toml) and [`lake-manifest.json`](./lake-manifest.json). The package version is **`0.2.0`**, not an announced new release.

With Lean, Lake, and the pinned toolchain available, from the repository root run:

```bash
python3 scripts/check-packaging.py
python3 scripts/check-lean-sources.py
lake exe cache get
lake build
```

The packaging check deliberately verifies that the *archived* proof and manuscript have not changed. It does **not** prohibit adding this separately named current manuscript. The full build includes the proof modules, independent `Challenge.lean`, and `Solution.lean`. Do not interpret a successful build alone as a claim of historical novelty.

To rebuild the **current** PDF from its `.tex` file (with a LaTeX installation):

```bash
cd manuscript
latexmk -pdf -interaction=nonstopmode -halt-on-error continuous_planar_isotropy_explained.tex
```

The existing [`build-manuscript.yml`](./.github/workflows/build-manuscript.yml) is a historical workflow targeting the archived filename on `main`; it is **not** the builder for this separately named current edition. No workflow or toolchain configuration is changed for this documentation revision.

### Comparator: what it checks

[`comparator.json`](./comparator.json) selects **11 theorem declarations** and **6 definitions**. [`Challenge.lean`](./Challenge.lean) is an independent statement surface importing Mathlib, not the project proof modules. Its `sorry` lines are intentional **challenge placeholders**, not admitted proofs in the implementation. [`Solution.lean`](./Solution.lean) re-exports the substantive formal proofs.

On a suitably configured Linux host, run:

```bash
bash scripts/verify-comparator.sh
```

The script uses `lake comparator`, Bubblewrap sandboxing, and the bundled independent checkers **NanoDa** and **con-ron**. It rejects unsupported local sandbox setups rather than disabling the sandbox. The permitted **Lean kernel** axioms are `propext`, `Classical.choice`, and `Quot.sound`. These are logical foundations in Lean; they are **not** the geometric hypotheses such as rigidity and continuity. Refer to [`VERIFICATION.md`](./VERIFICATION.md) for previously observed successful checks; never transfer their verification status to untested future source edits.

The branch verification workflow is [`.github/workflows/palomar.yml`](./.github/workflows/palomar.yml). The archived-development workflow is [`.github/workflows/lean.yml`](./.github/workflows/lean.yml). Only a successful run corresponding to the actual commit verifies that version of the repository.

## Palomar preparation and publication procedure

This branch is **preparation**, not an automatic submission to the Palomar Registry. Mechanical checking, independent mathematical review, research-interest assessment, and publication are different steps. The [Palomar preparation note](./PALOMAR.md) records the existing boundary.

A responsible publication sequence, **only after the repository owner explicitly decides to submit**, is:

1. **Freeze a reviewable commit** on `palomar-preparation`; record its **full commit SHA** and examine the difference from the archived release. Do not silently merge it into `main`.
2. **Review the actual hypotheses and literature context**, especially the existence of the continuous linear action, the difference between finite symmetry and continuous isotropy, and the limits of any novelty claim.
3. **Run and retain evidence** of packaging checks, source checks, `lake build`, Comparator, and independent kernel replay for **that exact commit**. Consult GitHub Actions logs and [`VERIFICATION.md`](./VERIFICATION.md); do not treat prior successful runs as proof of a different commit.
4. **Check the prepared submission metadata and independent statement surface** in [`formalization.yaml`](./formalization.yaml), [`comparator.json`](./comparator.json), `Challenge.lean`, and `Solution.lean` against the Registry's then-current requirements. Changes to those files are **not** part of this documentation edit.
5. **Submit through the applicable Palomar process only with explicit authorization** and cite the exact submitted commit. A passing Comparator result is not equivalent to Palomar acceptance. No submission, new release, new DOI, or Registry acceptance is claimed here.

The immutable public reference is the published **[`v0.1.0` archive](https://github.com/alexodas/pythagorean-isotropy-lean/releases/tag/v0.1.0)**, commit `64c8ea3ef05d621814bc6460223f1f14d208f543`, [Zenodo DOI `10.5281/zenodo.23326197`](https://doi.org/10.5281/zenodo.23326197). It must not be presented as identical to this `0.2.0` preparation. The repository is under **[CC BY 4.0](./LICENSE)**; dependencies retain their own licenses.

## Scope and scientific disclosure

- **Established:** conditional Lean theorems for the archived quarter-turn result, the new continuous-action equivalence, an explicit model, and the finite-symmetry obstruction.
- **Not established:** derivation of the motion action from elementary synthetic geometry; independence or minimality of the geometric premises; historical priority or novelty; Palomar acceptance.
- **AI provenance:** Alessandro Odasso initiated the prompt; ChatGPT generated the mathematical exposition and proposed derivation, with AI-assisted Lean development and machine-checked formal proof artifacts. Readers can inspect the precise Lean statements rather than relying on the informal exposition alone.

For extended mathematical discussion, see [`RESEARCH.md`](./RESEARCH.md). For check logs and their exact scope, see [`VERIFICATION.md`](./VERIFICATION.md). For archival and Palomar boundaries, see [`PALOMAR.md`](./PALOMAR.md).
