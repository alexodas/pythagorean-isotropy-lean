import Mathlib

/-!
# The coordinate Pythagorean theorem from planar isotropy

Lean 4 / mathlib formalization attempt based on:
A. Odasso, "The Coordinate Pythagorean Theorem from Planar Isotropy:
A Lie-Theoretic and Axiomatic Derivation", 18 August 2026.

Scope:
* `quadratic_generator_invariant_iff` formalizes the coefficient calculation
  behind Lemma 3.1 (the infinitesimal form of rotational invariance).
* `quadratic_conserved` proves conservation of x(t)^2 + y(t)^2
  directly from the two differential equations of the generator J.
* `pythagorean_from_isotropy` formalizes the two channels of Theorem 4.1:
  dynamical conservation and primitive geometric congruence.

The existence of a differentiable rotation trajectory, its length-preserving
character, and its reaching the positive x-axis are HYPOTHESES, as in the PDF.
The extended file derives the shape of the generator from explicitly stated
infinitesimal symmetry conditions (quarter-turn compatibility and mirror
reversal). It does NOT derive those symmetry conditions from rigidity alone.

This file was checked on GitHub Actions with Lean 4.34.0-rc1 and Mathlib.
It contains no `sorry` tactics and assumes no global axioms beyond theorem hypotheses.
-/

namespace PythagoreanIsotropy

/-- The equation `JᵀM + MJ = 0` for the symmetric matrix
    `M = !![α, β; β, γ]`, written componentwise as the vanishing
    directional derivative of its quadratic form along `J(x,y)=(-y,x)`.
    This is the infinitesimal version of Lemma 3.1 of the manuscript.
-/
theorem quadratic_generator_invariant_iff (α β γ : ℝ) :
    (∀ x y : ℝ,
      (2 * α * x + 2 * β * y) * (-y) +
      (2 * β * x + 2 * γ * y) * x = 0) ↔
    β = 0 ∧ α = γ := by
  constructor
  · intro h
    have h10 := h 1 0
    have h11 := h 1 1
    constructor
    · nlinarith [h10]
    · nlinarith [h10, h11]
  · rintro ⟨hβ, hαγ⟩ x y
    rw [hβ, ← hαγ]
    ring

/-- Dynamical channel: for a solution of
    x' = -y, y' = x, the quadratic expression x²+y² is constant.
    There is no hypothesis that x²+y² represents a geometric length.
-/
theorem quadratic_conserved
    (X Y : ℝ → ℝ)
    (hX : ∀ t : ℝ, HasDerivAt X (-Y t) t)
    (hY : ∀ t : ℝ, HasDerivAt Y (X t) t)
    (s t : ℝ) :
    X s ^ 2 + Y s ^ 2 = X t ^ 2 + Y t ^ 2 := by
  let q : ℝ → ℝ := fun u => X u ^ 2 + Y u ^ 2
  have hq : ∀ u : ℝ, HasDerivAt q 0 u := by
    intro u
    -- Differentiation and algebraic cancellation:
    -- d(x²+y²)/dt = 2x(-y) + 2yx = 0.
    convert ((hX u).fun_pow 2).add ((hY u).fun_pow 2) using 1 <;>
      (try dsimp [q]) <;> first | rfl | ring
  have hdiff : Differentiable ℝ q :=
    fun u => (hq u).differentiableAt
  have hzero : ∀ u : ℝ, deriv q u = 0 :=
    fun u => (hq u).deriv
  simpa only [q] using is_const_of_deriv_eq_zero hdiff hzero s t

/-- The manuscript's Theorem 4.1, formulated without identifying the
    *primitive geometric length* `L` with sqrt(x²+y²) in advance.

  `hAxis`   : calibration of lengths on the horizontal axis (Axiom 2.1).
  `hRigid`  : the specific motion preserves primitive length (Axiom 2.2).
  `hToAxis` : ray transitivity for the selected trajectory (Axiom 2.2).
  `hX, hY`  : the infinitesimal equations of the specified rotation flow.
  `hStart`  : the starting point has coordinates (a,b).
  `hc`      : c is the primitive geometric length of that segment.

  Crucially, NO assumption says `L a b = sqrt(a²+b²)`.
-/
theorem pythagorean_from_isotropy
    (L : ℝ → ℝ → ℝ)
    (X Y : ℝ → ℝ)
    (a b c : ℝ)
    (hAxis : ∀ r : ℝ, L r 0 = |r|)
    (hRigid : ∀ t : ℝ, L (X t) (Y t) = L (X 0) (Y 0))
    (hToAxis : ∃ T r : ℝ, 0 ≤ r ∧ X T = r ∧ Y T = 0)
    (hX : ∀ t : ℝ, HasDerivAt X (-Y t) t)
    (hY : ∀ t : ℝ, HasDerivAt Y (X t) t)
    (hX0 : X 0 = a)
    (hY0 : Y 0 = b)
    (hc : L a b = c) :
    a ^ 2 + b ^ 2 = c ^ 2 := by
  obtain ⟨T, r, hr, hXT, hYT⟩ := hToAxis

  -- Channel 1: conservation of the algebraic quadratic invariant.
  have hq := quadratic_conserved X Y hX hY 0 T
  rw [hX0, hY0, hXT, hYT] at hq
  have hq' : a ^ 2 + b ^ 2 = r ^ 2 := by
    simpa using hq

  -- Channel 2: primitive length preservation plus axial calibration.
  have hlen := hRigid T
  rw [hXT, hYT, hX0, hY0, hAxis r, abs_of_nonneg hr, hc] at hlen
  have hrc : r = c := hlen

  -- Identify the invariant terminal axial coordinate with the length c.
  rw [hrc] at hq'
  exact hq'


/-!
## Derivation of the infinitesimal generator

Let A be the unknown 2x2 generator, written without assuming any metric:

    A(x,y) = (p*x + q*y, r*x + s*y).

The following hypotheses are purely ALGEBRAIC infinitesimal symmetries:

* A K = K A, where K(x,y)=(-y,x) is an oriented quarter-turn.
  For a differentiable abelian rotation flow containing K, this follows
  by differentiating R(t) K = K R(t) at t=0.
* A S = -S A, where S(x,y)=(x,-y) is a reflection.
  For a reversible mirror-symmetric rotation flow, this follows by
  differentiating S R(t) S = R(-t) at t=0.

Neither condition assumes a Cartesian diagonal-length formula.
They DO encode a nontrivial choice of coordinate symmetries, and a separate
foundational argument is needed to obtain them from primitive congruence.
-/

/-- The most general real linear planar infinitesimal generator. -/
def linearGenerator (p q r s x y : ℝ) : ℝ × ℝ :=
  (p * x + q * y, r * x + s * y)

/-- `A K = K A` where `K(x,y)=(-y,x)`. -/
def CommutesQuarterTurn (p q r s : ℝ) : Prop :=
  ∀ x y : ℝ,
    linearGenerator p q r s (-y) x =
      (-(linearGenerator p q r s x y).2,
        (linearGenerator p q r s x y).1)

/-- `A S = - S A` where `S(x,y)=(x,-y)`.
This is the differentiated form of mirror reversal of the flow. -/
def ReversesUnderReflection (p q r s : ℝ) : Prop :=
  ∀ x y : ℝ,
    linearGenerator p q r s x (-y) =
      (-(linearGenerator p q r s x y).1,
        (linearGenerator p q r s x y).2)

/-- Commutation with a quarter-turn equates the diagonal coefficients
and makes the off-diagonal ones opposite. -/
theorem quarter_turn_coefficients (p q r s : ℝ)
    (hK : CommutesQuarterTurn p q r s) :
    s = p ∧ q = -r := by
  have h1 := congrArg Prod.snd (hK 1 0)
  have h2 := congrArg Prod.fst (hK 1 0)
  simp [linearGenerator] at h1 h2
  constructor <;> nlinarith

/-- Reflection reversal removes BOTH diagonal (expanding/contracting)
terms. In particular, there is no infinitesimal radial displacement of (1,0). -/
theorem reflection_removes_radial_part (p q r s : ℝ)
    (hS : ReversesUnderReflection p q r s) :
    p = 0 ∧ s = 0 := by
  have h1 := congrArg Prod.fst (hS 1 0)
  have h2 := congrArg Prod.snd (hS 0 1)
  simp [linearGenerator] at h1 h2
  constructor <;> nlinarith

/-- The desired generator theorem: the only real linear generator
compatible with the specified quarter-turn and mirror-reversal
symmetries is a scalar multiple of J(x,y)=(-y,x).
The factor omega is a choice of time/angle parametrization. -/
theorem generator_is_multiple_of_J (p q r s : ℝ)
    (hK : CommutesQuarterTurn p q r s)
    (hS : ReversesUnderReflection p q r s) :
    ∃ omega : ℝ, ∀ x y : ℝ,
      linearGenerator p q r s x y = (-omega * y, omega * x) := by
  obtain ⟨hp, hs⟩ := reflection_removes_radial_part p q r s hS
  obtain ⟨_, hq⟩ := quarter_turn_coefficients p q r s hK
  refine ⟨r, ?_⟩
  intro x y
  apply Prod.ext
  · change p * x + q * y = -r * y
    rw [hp, hq]
    ring
  · change r * x + s * y = r * x
    rw [hs]
    ring

/-- A second version, closer to the user's intuition: quarter-turn
compatibility PLUS absence of first-order axial/radial displacement
already force the generator to be a multiple of J. Note that the
absence of radial displacement is an explicit premise here. -/
theorem generator_from_no_radial_motion (p q r s : ℝ)
    (hK : CommutesQuarterTurn p q r s)
    (hNoRadial : (linearGenerator p q r s 1 0).1 = 0) :
    ∃ omega : ℝ, ∀ x y : ℝ,
      linearGenerator p q r s x y = (-omega * y, omega * x) := by
  have hp : p = 0 := by
    simpa [linearGenerator] using hNoRadial
  obtain ⟨hs_eq, hq⟩ := quarter_turn_coefficients p q r s hK
  have hs : s = 0 := by rw [hs_eq, hp]
  refine ⟨r, ?_⟩
  intro x y
  apply Prod.ext
  · change p * x + q * y = -r * y
    rw [hp, hq]
    ring
  · change r * x + s * y = r * x
    rw [hs]
    ring


/-- A second route, based on rigidity preserving area/volume:
for a differentiable linear one-parameter group of isometries of a
proper norm, the determinant is 1, so the generator has trace zero.
Together with quarter-turn commutation that forces the generator
A = omega*J. Here the trace-zero implication is EXPLICITLY an input;
the measure/volume argument is not formalized in this file. -/
theorem generator_from_trace_zero (p q r s : ℝ)
    (hK : CommutesQuarterTurn p q r s)
    (hTrace : p + s = 0) :
    ∃ omega : ℝ, ∀ x y : ℝ,
      linearGenerator p q r s x y = (-omega * y, omega * x) := by
  obtain ⟨hs_eq, hq⟩ := quarter_turn_coefficients p q r s hK
  have hp : p = 0 := by linarith
  have hs : s = 0 := by rw [hs_eq, hp]
  refine ⟨r, ?_⟩
  intro x y
  apply Prod.ext
  · change p * x + q * y = -r * y
    rw [hp, hq]
    ring
  · change r * x + s * y = r * x
    rw [hs]
    ring

/-- The same quadratic conservation law for an arbitrary fixed angular
speed omega, rather than assuming a particular unit of angle/time. -/
theorem quadratic_conserved_omega (omega : ℝ)
    (X Y : ℝ → ℝ)
    (hX : ∀ t : ℝ, HasDerivAt X (-omega * Y t) t)
    (hY : ∀ t : ℝ, HasDerivAt Y (omega * X t) t)
    (s t : ℝ) :
    X s ^ 2 + Y s ^ 2 = X t ^ 2 + Y t ^ 2 := by
  let quad : ℝ → ℝ := fun u => X u ^ 2 + Y u ^ 2
  have hquad : ∀ u : ℝ, HasDerivAt quad 0 u := by
    intro u
    convert ((hX u).fun_pow 2).add ((hY u).fun_pow 2) using 1 <;>
      (try dsimp [quad]) <;> first | rfl | ring
  have hdiff : Differentiable ℝ quad :=
    fun u => (hquad u).differentiableAt
  have hzero : ∀ u : ℝ, deriv quad u = 0 :=
    fun u => (hquad u).deriv
  simpa only [quad] using is_const_of_deriv_eq_zero hdiff hzero s t

/-- An extension of the manuscript's main theorem:
we assume only an *unknown linear generator* for the motion, not
predefined equations x'=-omega*y and y'=omega*x.
The symmetry assumptions determine its form, then rigidity and
axis calibration identify the conserved algebraic quadratic with
primitive geometric length.

WARNING: `hK` and `hS` are infinitesimal consequences of stronger
rotation-group axioms, not consequences of length-preservation alone.
-/
theorem pythagorean_from_derived_generator
    (p q r s : ℝ)
    (hK : CommutesQuarterTurn p q r s)
    (hS : ReversesUnderReflection p q r s)
    (L : ℝ → ℝ → ℝ)
    (X Y : ℝ → ℝ)
    (a b c : ℝ)
    (hAxis : ∀ u : ℝ, L u 0 = |u|)
    (hRigid : ∀ t : ℝ, L (X t) (Y t) = L (X 0) (Y 0))
    (hToAxis : ∃ T u : ℝ, 0 ≤ u ∧ X T = u ∧ Y T = 0)
    (hLinearX : ∀ t : ℝ,
        HasDerivAt X (p * X t + q * Y t) t)
    (hLinearY : ∀ t : ℝ,
        HasDerivAt Y (r * X t + s * Y t) t)
    (hX0 : X 0 = a)
    (hY0 : Y 0 = b)
    (hc : L a b = c) :
    a ^ 2 + b ^ 2 = c ^ 2 := by
  obtain ⟨hp, hs⟩ := reflection_removes_radial_part p q r s hS
  obtain ⟨_, hq⟩ := quarter_turn_coefficients p q r s hK
  have hX : ∀ t : ℝ, HasDerivAt X (-r * Y t) t := by
    intro t
    have heq : p * X t + q * Y t = -r * Y t := by
      rw [hp, hq]
      ring
    simpa only [heq] using hLinearX t
  have hY : ∀ t : ℝ, HasDerivAt Y (r * X t) t := by
    intro t
    have heq : r * X t + s * Y t = r * X t := by
      rw [hs]
      ring
    simpa only [heq] using hLinearY t
  obtain ⟨T, u, hu, hXT, hYT⟩ := hToAxis
  have hquad := quadratic_conserved_omega r X Y hX hY 0 T
  rw [hX0, hY0, hXT, hYT] at hquad
  have hquad' : a ^ 2 + b ^ 2 = u ^ 2 := by
    simpa using hquad
  have hlen := hRigid T
  rw [hXT, hYT, hX0, hY0, hAxis u, abs_of_nonneg hu, hc] at hlen
  rw [hlen] at hquad'
  exact hquad'


/-!
## Rigidity -> preservation of area -> trace zero -> generator J

This section removes the postulate `p+s=0` of `generator_from_trace_zero`.
It DOES NOT assume the Pythagorean formula for the primitive length L.

Additional primitive geometric hypotheses, made explicit:
* axial calibration L(x,0)=|x|;
* reflection (x,y) -> (x,-y) preserves L;
* each map in the flow is a congruence for L;
* its linear coordinate action commutes with the calibrated quarter-turn,
  so it has the form (x,y) -> (u*x-v*y, v*x+u*y).

We prove area preservation algebraically as preservation of oriented
parallelogram area. The usual conclusion for Lebesgue area then follows
from the change-of-variables theorem; that measure-theoretic corollary
is NOT formalized here.
-/

/-- Coordinates of a real linear map commuting with the calibrated quarter-turn. -/
def quarterTurnFlow (u v x y : ℝ) : ℝ × ℝ :=
  (u * x - v * y, v * x + u * y)

/-- Primitive geometric rigidity of such a map; L is *not* defined
by the Cartesian Euclidean distance expression. -/
def PrimitiveRigid (L : ℝ → ℝ → ℝ) (u v : ℝ) : Prop :=
  ∀ x y : ℝ, L (u * x - v * y) (v * x + u * y) = L x y

/-- Rigidity plus axial calibration and reflection symmetry implies
that a quarter-turn-compatible linear map has determinant one.
No diagonal metric formula is used. -/
theorem determinant_one_from_primitive_rigidity
    (L : ℝ → ℝ → ℝ) (u v : ℝ)
    (hAxis : ∀ z : ℝ, L z 0 = |z|)
    (hMirror : ∀ x y : ℝ, L x (-y) = L x y)
    (hRigid : PrimitiveRigid L u v) :
    u ^ 2 + v ^ 2 = 1 := by
  have hu : L u v = 1 := by
    have h := hRigid 1 0
    simpa [hAxis, PrimitiveRigid] using h
  have hmirror : L u (-v) = 1 := by
    rw [hMirror u v, hu]
  have hcomputation : L (u * u + v * v) 0 = L u (-v) := by
    have h := hRigid u (-v)
    have hx : u * u - v * (-v) = u * u + v * v := by ring
    have hy : v * u + u * (-v) = 0 := by ring
    rw [hx, hy] at h
    exact h
  have hAbs : |u * u + v * v| = 1 := by
    rw [hAxis] at hcomputation
    exact hcomputation.trans hmirror
  have hNonneg : 0 ≤ u * u + v * v := by
    nlinarith [sq_nonneg u, sq_nonneg v]
  rw [abs_of_nonneg hNonneg] at hAbs
  nlinarith

/-- Algebraic oriented area of a parallelogram based at the origin. -/
def orientedArea (x₁ y₁ x₂ y₂ : ℝ) : ℝ :=
  x₁ * y₂ - y₁ * x₂

/-- We obtain *area preservation*, in the literal determinant sense,
from primitive congruence (and the geometric reflection hypothesis).
This does not postulate preservation of area as an axiom. -/
theorem oriented_area_preserved_from_primitive_rigidity
    (L : ℝ → ℝ → ℝ) (u v : ℝ)
    (hAxis : ∀ z : ℝ, L z 0 = |z|)
    (hMirror : ∀ x y : ℝ, L x (-y) = L x y)
    (hRigid : PrimitiveRigid L u v)
    (x₁ y₁ x₂ y₂ : ℝ) :
    orientedArea
      (u * x₁ - v * y₁) (v * x₁ + u * y₁)
      (u * x₂ - v * y₂) (v * x₂ + u * y₂) =
    orientedArea x₁ y₁ x₂ y₂ := by
  have hdet := determinant_one_from_primitive_rigidity
    L u v hAxis hMirror hRigid
  dsimp [orientedArea]
  calc
    (u * x₁ - v * y₁) * (v * x₂ + u * y₂) -
       (v * x₁ + u * y₁) * (u * x₂ - v * y₂) =
      (u ^ 2 + v ^ 2) * (x₁ * y₂ - y₁ * x₂) := by ring
    _ = x₁ * y₂ - y₁ * x₂ := by rw [hdet]; ring

/-- A differentiable one-parameter family of primitive rigid motions
has zero infinitesimal radial scaling in quarter-turn coordinates.

This differentiates the *derived* determinant-one identity at t=0;
trace zero is therefore a theorem, not an extra postulate. -/
theorem radial_derivative_zero_from_rigidity
    (L : ℝ → ℝ → ℝ) (U V : ℝ → ℝ) (p omega : ℝ)
    (hAxis : ∀ z : ℝ, L z 0 = |z|)
    (hMirror : ∀ x y : ℝ, L x (-y) = L x y)
    (hRigid : ∀ t : ℝ, PrimitiveRigid L (U t) (V t))
    (hU0 : U 0 = 1)
    (hV0 : V 0 = 0)
    (hUderiv : HasDerivAt U p 0)
    (hVderiv : HasDerivAt V omega 0) :
    p = 0 := by
  have hconst : ∀ t : ℝ, U t ^ 2 + V t ^ 2 = 1 := by
    intro t
    exact determinant_one_from_primitive_rigidity
      L (U t) (V t) hAxis hMirror (hRigid t)
  have hderiv : HasDerivAt
      (fun t : ℝ => U t ^ 2 + V t ^ 2)
      (2 * U 0 * p + 2 * V 0 * omega) 0 := by
    convert (hUderiv.fun_pow 2).add (hVderiv.fun_pow 2) using 1 <;> first | rfl | ring
  have hfun : (fun t : ℝ => U t ^ 2 + V t ^ 2) =
      (fun _ : ℝ => (1 : ℝ)) := by
    funext t
    exact hconst t
  rw [hfun] at hderiv
  have hzero : HasDerivAt (fun _ : ℝ => (1 : ℝ)) 0 0 :=
    hasDerivAt_const 0 (1 : ℝ)
  have hd := hderiv.unique hzero
  rw [hU0, hV0] at hd
  nlinarith


/-- Direct generator characterization for an already quarter-turn-equivariant
coordinate flow. The normal form is derived by commuting with the quarter-turn;
its metric property is supplied solely by `hRigid` and `hMirror`.
This theorem does NOT postulate either trace zero or the generator J. -/
theorem infinitesimal_generator_of_rigid_quarter_turn_flow
    (L : ℝ → ℝ → ℝ) (U V : ℝ → ℝ) (p omega : ℝ)
    (hAxis : ∀ z : ℝ, L z 0 = |z|)
    (hMirror : ∀ x y : ℝ, L x (-y) = L x y)
    (hRigid : ∀ t : ℝ, PrimitiveRigid L (U t) (V t))
    (hU0 : U 0 = 1)
    (hV0 : V 0 = 0)
    (hUderiv : HasDerivAt U p 0)
    (hVderiv : HasDerivAt V omega 0) :
    ∀ x y : ℝ,
      (p * x - omega * y, omega * x + p * y) =
        (-omega * y, omega * x) := by
  have hp : p = 0 :=
    radial_derivative_zero_from_rigidity
      L U V p omega hAxis hMirror hRigid hU0 hV0 hUderiv hVderiv
  intro x y
  apply Prod.ext
  · change p * x - omega * y = -omega * y
    rw [hp]
    ring
  · change omega * x + p * y = omega * x
    rw [hp]
    ring

/-- The trace-zero property of the infinitesimal generator is derived
from congruence instead of being explicitly assumed, as in the previous
`generator_from_trace_zero` theorem. -/
theorem generator_J_from_primitive_rigidity
    (p q r s : ℝ)
    (hK : CommutesQuarterTurn p q r s)
    (L : ℝ → ℝ → ℝ) (U V : ℝ → ℝ)
    (hAxis : ∀ z : ℝ, L z 0 = |z|)
    (hMirror : ∀ x y : ℝ, L x (-y) = L x y)
    (hRigid : ∀ t : ℝ, PrimitiveRigid L (U t) (V t))
    (hU0 : U 0 = 1)
    (hV0 : V 0 = 0)
    (hUderiv : HasDerivAt U p 0)
    (hVderiv : HasDerivAt V r 0) :
    p + s = 0 ∧
    ∃ omega : ℝ, ∀ x y : ℝ,
      linearGenerator p q r s x y = (-omega * y, omega * x) := by
  have hp : p = 0 :=
    radial_derivative_zero_from_rigidity
      L U V p r hAxis hMirror hRigid hU0 hV0 hUderiv hVderiv
  obtain ⟨hs, _⟩ := quarter_turn_coefficients p q r s hK
  have hTrace : p + s = 0 := by rw [hs, hp]; ring
  exact ⟨hTrace, generator_from_trace_zero p q r s hK hTrace⟩

/-- Integrated conclusion: derive the generator using primitive
rigidity and then obtain the coordinate Pythagorean theorem. -/
theorem pythagorean_from_rigidity_derived_generator
    (p q r s : ℝ)
    (hK : CommutesQuarterTurn p q r s)
    (L : ℝ → ℝ → ℝ) (U V X Y : ℝ → ℝ)
    (a b c : ℝ)
    (hAxis : ∀ z : ℝ, L z 0 = |z|)
    (hMirror : ∀ x y : ℝ, L x (-y) = L x y)
    (hFlowRigid : ∀ t : ℝ, PrimitiveRigid L (U t) (V t))
    (hU0 : U 0 = 1)
    (hV0 : V 0 = 0)
    (hUderiv : HasDerivAt U p 0)
    (hVderiv : HasDerivAt V r 0)
    (hX : ∀ t : ℝ, HasDerivAt X (p * X t + q * Y t) t)
    (hY : ∀ t : ℝ, HasDerivAt Y (r * X t + s * Y t) t)
    (hTrajectoryRigid : ∀ t : ℝ, L (X t) (Y t) = L (X 0) (Y 0))
    (hToAxis : ∃ T z : ℝ, 0 ≤ z ∧ X T = z ∧ Y T = 0)
    (hX0 : X 0 = a) (hY0 : Y 0 = b) (hc : L a b = c) :
    a ^ 2 + b ^ 2 = c ^ 2 := by
  have hgen := generator_J_from_primitive_rigidity
    p q r s hK L U V hAxis hMirror hFlowRigid hU0 hV0 hUderiv hVderiv
  obtain ⟨htrace, _⟩ := hgen
  obtain ⟨hs, hq⟩ := quarter_turn_coefficients p q r s hK
  have hp : p = 0 := by linarith
  have hsd : s = 0 := by linarith
  have hDX : ∀ t : ℝ, HasDerivAt X (-r * Y t) t := by
    intro t
    have hh : p * X t + q * Y t = -r * Y t := by
      rw [hp, hq]
      ring
    simpa only [hh] using hX t
  have hDY : ∀ t : ℝ, HasDerivAt Y (r * X t) t := by
    intro t
    have hh : r * X t + s * Y t = r * X t := by
      rw [hsd]
      ring
    simpa only [hh] using hY t
  obtain ⟨T, z, hz, hXT, hYT⟩ := hToAxis
  have hConserved := quadratic_conserved_omega r X Y hDX hDY 0 T
  rw [hX0, hY0, hXT, hYT] at hConserved
  have hQuadratic : a ^ 2 + b ^ 2 = z ^ 2 := by
    simpa using hConserved
  have hlen := hTrajectoryRigid T
  rw [hXT, hYT, hX0, hY0, hAxis z, abs_of_nonneg hz, hc] at hlen
  rw [hlen] at hQuadratic
  exact hQuadratic


/-- The same conclusion when the geometric-length invariance of the
trajectory is *derived* from it being an orbit of the rigid linear flow,
instead of being supplied as a separate hypothesis. -/
theorem pythagorean_from_rigid_orbit
    (p q r s : ℝ)
    (hK : CommutesQuarterTurn p q r s)
    (L : ℝ → ℝ → ℝ) (U V X Y : ℝ → ℝ)
    (a b c : ℝ)
    (hAxis : ∀ z : ℝ, L z 0 = |z|)
    (hMirror : ∀ x y : ℝ, L x (-y) = L x y)
    (hFlowRigid : ∀ t : ℝ, PrimitiveRigid L (U t) (V t))
    (hU0 : U 0 = 1)
    (hV0 : V 0 = 0)
    (hUderiv : HasDerivAt U p 0)
    (hVderiv : HasDerivAt V r 0)
    (hOrbitX : ∀ t : ℝ, X t = U t * a - V t * b)
    (hOrbitY : ∀ t : ℝ, Y t = V t * a + U t * b)
    (hX : ∀ t : ℝ, HasDerivAt X (p * X t + q * Y t) t)
    (hY : ∀ t : ℝ, HasDerivAt Y (r * X t + s * Y t) t)
    (hToAxis : ∃ T z : ℝ, 0 ≤ z ∧ X T = z ∧ Y T = 0)
    (hc : L a b = c) :
    a ^ 2 + b ^ 2 = c ^ 2 := by
  have hX0 : X 0 = a := by
    rw [hOrbitX 0, hU0, hV0]
    ring
  have hY0 : Y 0 = b := by
    rw [hOrbitY 0, hU0, hV0]
    ring
  have hTrajectoryRigid : ∀ t : ℝ,
      L (X t) (Y t) = L (X 0) (Y 0) := by
    intro t
    rw [hOrbitX t, hOrbitY t, hX0, hY0]
    exact hFlowRigid t a b
  exact pythagorean_from_rigidity_derived_generator
    p q r s hK L U V X Y a b c hAxis hMirror
    hFlowRigid hU0 hV0 hUderiv hVderiv hX hY hTrajectoryRigid
    hToAxis hX0 hY0 hc

end PythagoreanIsotropy
/-!
The primitive quarter-turn has no metric or inner product in its definition.
Its axis-exchange and half-turn properties determine its matrix algebraically.
For an abelian linear rotation group containing this quarter-turn, group
composition forces the standard rotation-coordinate normal form. Congruence,
mirror symmetry and axial calibration then eliminate radial scaling.
-/

namespace PythagoreanIsotropy

structure LinearPlaneEnd where
  a : ℝ
  b : ℝ
  c : ℝ
  d : ℝ

namespace LinearPlaneEnd
def act (F : LinearPlaneEnd) (x y : ℝ) : ℝ × ℝ :=
  (F.a * x + F.b * y, F.c * x + F.d * y)
end LinearPlaneEnd

/-- A primitive oriented quarter-turn: it exchanges the oriented axes and
its square is a central half-turn, with no metric in the definition. -/
def IsPrimitiveQuarterTurn (Q : LinearPlaneEnd) : Prop :=
  Q.act 1 0 = (0, 1) ∧
  ∀ x y : ℝ,
    Q.act (Q.act x y).1 (Q.act x y).2 = (-x, -y)

theorem primitive_quarter_turn_is_J (Q : LinearPlaneEnd)
    (hQ : IsPrimitiveQuarterTurn Q) :
    ∀ x y : ℝ, Q.act x y = (-y, x) := by
  obtain ⟨hAxis, hSquare⟩ := hQ
  have ha : Q.a = 0 := by
    have h := congrArg Prod.fst hAxis
    simpa [LinearPlaneEnd.act] using h
  have hc : Q.c = 1 := by
    have h := congrArg Prod.snd hAxis
    simpa [LinearPlaneEnd.act] using h
  have hE2 : Q.act 0 1 = (-1, 0) := by
    have h := hSquare 1 0
    rw [hAxis] at h
    simpa using h
  have hb : Q.b = -1 := by
    have h := congrArg Prod.fst hE2
    simpa [LinearPlaneEnd.act] using h
  have hd : Q.d = 0 := by
    have h := congrArg Prod.snd hE2
    simpa [LinearPlaneEnd.act] using h
  intro x y
  apply Prod.ext
  · change Q.a * x + Q.b * y = -y
    rw [ha, hb]
    ring
  · change Q.c * x + Q.d * y = x
    rw [hc, hd]
    ring

theorem commuting_with_primitive_quarter_turn
    (Q F : LinearPlaneEnd)
    (hQ : IsPrimitiveQuarterTurn Q)
    (hComm : ∀ x y : ℝ,
      F.act (Q.act x y).1 (Q.act x y).2 =
        Q.act (F.act x y).1 (F.act x y).2) :
    ∀ x y : ℝ,
      F.act x y = (F.a * x - F.c * y, F.c * x + F.a * y) := by
  have hAxis := hQ.1
  have hQnormal := primitive_quarter_turn_is_J Q hQ
  have h := hComm 1 0
  rw [hAxis, hQnormal] at h
  have hb : F.b = -F.c := by
    have heq := congrArg Prod.fst h
    simpa [LinearPlaneEnd.act] using heq
  have hd : F.d = F.a := by
    have heq := congrArg Prod.snd h
    simpa [LinearPlaneEnd.act] using heq
  intro x y
  apply Prod.ext
  · change F.a * x + F.b * y = F.a * x - F.c * y
    rw [hb]
    ring
  · change F.c * x + F.d * y = F.c * x + F.a * y
    rw [hd]

def AdditiveLinearAction (F : ℝ → LinearPlaneEnd) : Prop :=
  ∀ s t x y : ℝ,
    (F (s + t)).act x y =
      (F s).act ((F t).act x y).1 ((F t).act x y).2

theorem primitive_quarter_turn_forces_flow_shape
    (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (hAction : AdditiveLinearAction F)
    (hQ : IsPrimitiveQuarterTurn Q)
    (hMember : ∃ θ : ℝ, F θ = Q) :
    ∀ t x y : ℝ,
      (F t).act x y =
        ((F t).a * x - (F t).c * y,
         (F t).c * x + (F t).a * y) := by
  obtain ⟨θ, hθ⟩ := hMember
  have hComm : ∀ t x y : ℝ,
      (F t).act (Q.act x y).1 (Q.act x y).2 =
        Q.act ((F t).act x y).1 ((F t).act x y).2 := by
    intro t x y
    calc
      (F t).act (Q.act x y).1 (Q.act x y).2 =
          (F t).act ((F θ).act x y).1 ((F θ).act x y).2 := by rw [hθ]
      _ = (F (t + θ)).act x y := (hAction t θ x y).symm
      _ = (F (θ + t)).act x y := by rw [add_comm t θ]
      _ = (F θ).act ((F t).act x y).1 ((F t).act x y).2 := hAction θ t x y
      _ = Q.act ((F t).act x y).1 ((F t).act x y).2 := by rw [hθ]
  intro t x y
  exact commuting_with_primitive_quarter_turn Q (F t) hQ (hComm t) x y

def IsRigidLinearAction (L : ℝ → ℝ → ℝ)
    (F : ℝ → LinearPlaneEnd) : Prop :=
  ∀ t x y : ℝ,
    L ((F t).act x y).1 ((F t).act x y).2 = L x y

theorem primitive_quarter_turn_flow_is_rigid_normal_form
    (L : ℝ → ℝ → ℝ) (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (hAction : AdditiveLinearAction F)
    (hQ : IsPrimitiveQuarterTurn Q)
    (hMember : ∃ θ : ℝ, F θ = Q)
    (hRigid : IsRigidLinearAction L F) :
    ∀ t : ℝ, PrimitiveRigid L (F t).a (F t).c := by
  have hNormal := primitive_quarter_turn_forces_flow_shape F Q hAction hQ hMember
  intro t x y
  have h := hRigid t x y
  rw [hNormal t x y] at h
  simpa [PrimitiveRigid] using h

theorem infinitesimal_J_from_primitive_quarter_turn
    (L : ℝ → ℝ → ℝ) (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (p omega : ℝ)
    (hAction : AdditiveLinearAction F)
    (hQ : IsPrimitiveQuarterTurn Q)
    (hMember : ∃ θ : ℝ, F θ = Q)
    (hAxis : ∀ z : ℝ, L z 0 = |z|)
    (hMirror : ∀ x y : ℝ, L x (-y) = L x y)
    (hRigid : IsRigidLinearAction L F)
    (hA0 : (F 0).a = 1)
    (hC0 : (F 0).c = 0)
    (hAderiv : HasDerivAt (fun t => (F t).a) p 0)
    (hCderiv : HasDerivAt (fun t => (F t).c) omega 0) :
    p = 0 ∧ ∀ x y : ℝ,
      (p * x - omega * y, omega * x + p * y) =
        (-omega * y, omega * x) := by
  have hRigidNormal := primitive_quarter_turn_flow_is_rigid_normal_form
    L F Q hAction hQ hMember hRigid
  have hp : p = 0 :=
    radial_derivative_zero_from_rigidity L
      (fun t => (F t).a) (fun t => (F t).c) p omega
      hAxis hMirror hRigidNormal hA0 hC0 hAderiv hCderiv
  refine ⟨hp, ?_⟩
  intro x y
  rw [hp]
  apply Prod.ext <;> change _ = _ <;> ring

/-- The main Pythagorean theorem, now without an assumed coordinate rotation
matrix or ODE. The existence of a transitive rigid action remains a premise. -/
theorem pythagoras_from_metric_free_quarter_turn
    (L : ℝ → ℝ → ℝ) (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (a b c : ℝ)
    (hAction : AdditiveLinearAction F)
    (hQ : IsPrimitiveQuarterTurn Q)
    (hMember : ∃ θ : ℝ, F θ = Q)
    (hAxis : ∀ z : ℝ, L z 0 = |z|)
    (hMirror : ∀ x y : ℝ, L x (-y) = L x y)
    (hRigid : IsRigidLinearAction L F)
    (hToAxis : ∃ t z : ℝ, 0 ≤ z ∧ (F t).act a b = (z, 0))
    (hc : L a b = c) :
    a ^ 2 + b ^ 2 = c ^ 2 := by
  have hNormal := primitive_quarter_turn_forces_flow_shape F Q hAction hQ hMember
  have hRigidNormal := primitive_quarter_turn_flow_is_rigid_normal_form
    L F Q hAction hQ hMember hRigid
  obtain ⟨t, z, hz, ht⟩ := hToAxis
  have hShape := hNormal t a b
  rw [hShape] at ht
  have hFirst : (F t).a * a - (F t).c * b = z := by
    have h := congrArg Prod.fst ht
    simpa using h
  have hSecond : (F t).c * a + (F t).a * b = 0 := by
    have h := congrArg Prod.snd ht
    simpa using h
  have hdet : (F t).a ^ 2 + (F t).c ^ 2 = 1 :=
    determinant_one_from_primitive_rigidity L (F t).a (F t).c
      hAxis hMirror (hRigidNormal t)
  have hquad : a ^ 2 + b ^ 2 = z ^ 2 := by
    calc
      a ^ 2 + b ^ 2 =
          ((F t).a ^ 2 + (F t).c ^ 2) * (a ^ 2 + b ^ 2) := by rw [hdet]; ring
      _ = ((F t).a * a - (F t).c * b) ^ 2 +
          ((F t).c * a + (F t).a * b) ^ 2 := by ring
      _ = z ^ 2 := by rw [hFirst, hSecond]; ring
  have hlen := hRigid t a b
  rw [hNormal t a b] at hlen
  rw [hFirst, hSecond, hAxis z, abs_of_nonneg hz, hc] at hlen
  rw [hlen] at hquad
  exact hquad

end PythagoreanIsotropy


/-!
## Kernel-level axiom audit

These commands are evaluated by Lean during compilation. They print the
logical axioms the selected closed theorem declarations ultimately depend on.
The geometric premises `hAction`, `hQ`, `hMember`, `hAxis`,
`hMirror`, `hRigid`, `hToAxis`, and `hc` are explicit PARAMETERS
of the main theorem, so they are not global `axiom` declarations and
will not appear in `#print axioms` output. Consult AXIOMS.md for the
full list of geometric assumptions and the meaning of this audit.
-/

#print axioms PythagoreanIsotropy.primitive_quarter_turn_is_J
#print axioms PythagoreanIsotropy.determinant_one_from_primitive_rigidity
#print axioms PythagoreanIsotropy.infinitesimal_J_from_primitive_quarter_turn
#print axioms PythagoreanIsotropy.pythagoras_from_metric_free_quarter_turn
