# Continuous planar isotropy: a characterization of Euclidean length

This development extends the archived conditional theorem. It is not a new
GitHub release or Zenodo deposit. It makes no claim of a newly discovered
mathematical characterization or of eligibility for a research registry.

## Main statement

Let `L : ℝ → ℝ → ℝ` be any function, calibrated by `L(z,0)=|z|`.
Then the following are equivalent:

1. There exist real linear maps `F(t)` and a map `Q` such that:
   - `F(s+t)=F(s)∘F(t)`;
   - `Q(1,0)=(0,1)` and `Q²=-I`;
   - `Q=F(θ)` for some real `θ`;
   - the coefficient functions `t ↦ (F t).a` and `t ↦ (F t).c` are continuous;
   - every `F(t)` preserves `L`.
2. For every real `x,y`, `L(x,y)=sqrt(x²+y²)`.

The Lean theorem is
`PythagoreanIsotropy.continuous_isotropy_iff_euclidean_length` in
`IsotropyCharacterization.lean`. The definition of `L` is arbitrary in the
forward implication: it need not be positive, continuous, homogeneous,
subadditive, or reflection invariant. Those properties follow once it has
been identified with Euclidean length. Linearity of the motion remains an
assumption built into `LinearPlaneEnd`.

## What changes relative to the archived theorem

This is an assumption tradeoff, not a strict weakening of every original
hypothesis. The archived theorem allows a possibly discontinuous action and
assumes mirror symmetry and axis reachability for the particular vector.
The new characterization assumes continuity of two action coefficients,
derives reachability for every vector, and needs no mirror premise. It
identifies the whole length function, rather than only a squared identity
for a selected displacement. Neither version needs differentiability for
its final length theorem.

An explicit trigonometric model in `EuclideanModel.lean` proves the converse
and witnesses that the assumptions are jointly satisfiable. This model is
built within ordinary real analysis, using sine and cosine and their
standard identities. It is not an independent derivation of rotations from
synthetic incidence or congruence axioms.

## Proof of the forward implication

1. The action law and the invertible quarter-turn force `F(0)=I`.
   Commutation with the quarter-turn gives
   `F(t)(x,y)=(u(t)x-v(t)y, v(t)x+u(t)y)`.
2. Put `s(t)=u(t)²+v(t)²`. Direct algebra gives
   `s(t+r)=s(t)s(r)`. Since `F(θ)=Q`, `s(θ)=1` and `θ≠0`, so `s`
   is continuous and periodic. It has compact range.
3. Let `M` be the greatest value of `s`. Since `s(0)=1`, `M>0`.
   If `M=s(r)`, then `s(t)M=s(t+r)≤M`; hence `s(t)≤1`.
   Applying the same bound at `-t` and using `s(t)s(-t)=1` gives
   `s(t)=1`. This proves preservation of `x²+y²` without using `L`,
   reflection symmetry, a derivative, or the desired length formula.
4. For any vector `(x,y)`, the second coordinate of its orbit is `y`
   at time zero and `-y` at time `2θ`. The intermediate value theorem
   gives an axis crossing. If necessary a further half-turn makes its
   first coordinate nonnegative. Reachability is therefore a theorem.
5. If the crossing is `(z,0)` with `z≥0`, quadratic preservation gives
   `z²=x²+y²`; rigidity and axial calibration give `L(x,y)=z`.
   Consequently `L(x,y)=sqrt(x²+y²)`.

The two ingredients, compactness excluding radial scaling and continuity
giving an axis crossing, are established independently of the length formula.

## Exact finite-symmetry obstruction

`IsotropyCounterexamples.lean` studies `B(x,y)=max(|x|,|y|)`.
It proves continuity, positive definiteness, homogeneity, the triangle
inequality, axial calibration, mirror symmetry, and quarter-turn invariance.
Nevertheless `B(1,1)=1`, so its squared length is not `1²+1²=2`.

More precisely, its length-preserving maps of the normal form
`(x,y) ↦ (ux-vy,vx+uy)` are exactly the four coordinate rotations:

`(u=0 ∧ |v|=1) ∨ (|u|=1 ∧ v=0)`.

None sends `(1,1)` onto the horizontal axis and none is a square root
of the primitive quarter-turn. It follows that this length admits no
additive real linear action containing that quarter-turn, even without
assuming continuity: `F(θ/2)` would have to provide the missing rigid root.

This is a counterexample to a *finite-symmetry* characterization. It is
not a counterexample retaining every original hypothesis except reachability,
nor a proof that every new assumption is minimal or independent.

## Relationship to known mathematics

The principle that sufficiently rich linear isometry groups force a planar
norm to be Euclidean is classical. For example, Sean Dewar,
*Infinitesimal rigidity in normed planes*, SIAM J. Discrete Math. 34(2),
1205–1231 (2020), [DOI 10.1137/19M1284051](https://doi.org/10.1137/19M1284051),
records finiteness of the linear isometry group of a non-Euclidean normed
plane. See [arXiv v1, §2.2, Proposition 2.6](https://arxiv.org/html/1812.06022v1#S2.SS2).

The present assumptions differ: they start with an arbitrary calibrated
function and a specified continuous action, rather than a pre-existing norm.
That difference and the Lean proofs are not evidence of historical novelty.
The contribution established here is a checked extension of this repository:
an explicit equivalence, a consistency witness, and a finite-symmetry
obstruction. A serious research claim would still require a closer literature
comparison and independent mathematical assessment.

## Provenance and archive boundary

The extension was developed with OpenAI Codex assistance following Alessandro
Odasso's request to seek a substantive mathematical improvement. It adds new
modules; the old proof module, archived manuscript, Zenodo metadata,
`AXIOMS.md`, and `RELEASE_NOTES.md` retain their archived contents, apart from
the already documented module/import adaptation of the old proof module.
`AXIOMS.md` describes the archived theorem, not the new characterization.

No new release, tag, DOI, or Palomar submission is created by this development.
See `VERIFICATION.md` for the precise checks actually completed.
