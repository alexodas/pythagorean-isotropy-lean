module

public import Mathlib.Analysis.Calculus.Deriv.Basic
public import Mathlib.Analysis.Real.Sqrt

public section

/-!
# Coordinate Pythagorean identity from explicit planar symmetry hypotheses

This statement surface is independent of the project proof module. The four
archived theorems retain exactly the signatures of the v0.1.0 source.
Additional statements below describe the continuous-action characterization
and finite-symmetry obstruction developed in RESEARCH.md.
Only their proofs are deliberately replaced by `sorry` in this Challenge.

`L` is an arbitrary primitive length function, not a definition by a norm.
Linearity is built into the four-coordinate structure below. In the four
archived declarations, the action law,
quarter-turn membership, axial calibration, mirror symmetry, rigidity and
axis reachability are assumptions. In particular the existence of such an
action and reachability do not follow here from weaker incidence axioms.
The archived `pythagoras_from_metric_free_quarter_turn` needs reachability for
the chosen vector only. No positivity of a or b, continuity of the action, or
differentiability is assumed in that archived theorem. The new continuous
characterization below instead derives reachability and mirror symmetry.
The separate infinitesimal theorem has its own derivative assumptions.

This is a formalized conditional derivation of a known identity. It establishes
neither historical novelty nor independence or minimality of the hypotheses.
The Lie-theoretic discussion in the manuscript is not advertised as wholly
formalized. See PALOMAR.md, AXIOMS.md and formalization.yaml for provenance.
-/

namespace PythagoreanIsotropy

structure LinearPlaneEnd where
  a : ℝ
  b : ℝ
  c : ℝ
  d : ℝ

namespace LinearPlaneEnd
@[expose] def act (F : LinearPlaneEnd) (x y : ℝ) : ℝ × ℝ :=
  (F.a * x + F.b * y, F.c * x + F.d * y)
end LinearPlaneEnd

@[expose] def IsPrimitiveQuarterTurn (Q : LinearPlaneEnd) : Prop :=
  Q.act 1 0 = (0, 1) ∧
  ∀ x y : ℝ,
    Q.act (Q.act x y).1 (Q.act x y).2 = (-x, -y)

@[expose] def AdditiveLinearAction (F : ℝ → LinearPlaneEnd) : Prop :=
  ∀ s t x y : ℝ,
    (F (s + t)).act x y =
      (F s).act ((F t).act x y).1 ((F t).act x y).2

@[expose] def IsRigidLinearAction (L : ℝ → ℝ → ℝ)
    (F : ℝ → LinearPlaneEnd) : Prop :=
  ∀ t x y : ℝ,
    L ((F t).act x y).1 ((F t).act x y).2 = L x y

@[expose] def PrimitiveRigid (L : ℝ → ℝ → ℝ) (u v : ℝ) : Prop :=
  ∀ x y : ℝ, L (u * x - v * y) (v * x + u * y) = L x y

/-- Axis exchange and the half-turn law determine the coordinate quarter-turn. -/
theorem primitive_quarter_turn_is_J (Q : LinearPlaneEnd)
    (hQ : IsPrimitiveQuarterTurn Q) :
    ∀ x y : ℝ, Q.act x y = (-y, x) := by
  sorry

/-- Axial calibration, reflection symmetry and rigidity force u² + v² = 1. -/
theorem determinant_one_from_primitive_rigidity
    (L : ℝ → ℝ → ℝ) (u v : ℝ)
    (hAxis : ∀ z : ℝ, L z 0 = |z|)
    (hMirror : ∀ x y : ℝ, L x (-y) = L x y)
    (hRigid : PrimitiveRigid L u v) :
    u ^ 2 + v ^ 2 = 1 := by
  sorry

/-- With the stated derivatives and normalization, radial scaling vanishes and the generator is omega J. -/
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
  sorry

/-- The conditional coordinate Pythagorean identity. All eight geometric premises remain explicit. -/
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
  sorry

end PythagoreanIsotropy

/-! New development: continuity replaces per-vector reachability, compactness
removes the mirror premise, and an explicit model supplies the converse.
These statements do not assert historical novelty. -/

namespace PythagoreanIsotropy

theorem axis_reachable_of_continuous_action
    (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (hAction : AdditiveLinearAction F)
    (hQ : IsPrimitiveQuarterTurn Q)
    (hMember : ∃ θ : ℝ, F θ = Q)
    (hContinuousA : Continuous (fun t : ℝ => (F t).a))
    (hContinuousC : Continuous (fun t : ℝ => (F t).c))
    (a b : ℝ) :
    ∃ t z : ℝ, 0 ≤ z ∧ (F t).act a b = (z, 0) := by
  sorry

theorem continuous_action_preserves_quadratic
    (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (hAction : AdditiveLinearAction F) (hQ : IsPrimitiveQuarterTurn Q)
    (hMember : ∃ θ : ℝ, F θ = Q)
    (hContinuousA : Continuous (fun t : ℝ => (F t).a))
    (hContinuousC : Continuous (fun t : ℝ => (F t).c)) :
    ∀ t x y : ℝ,
      ((F t).act x y).1 ^ 2 + ((F t).act x y).2 ^ 2 = x ^ 2 + y ^ 2 := by
  sorry

theorem length_eq_sqrt_without_mirror
    (L : ℝ → ℝ → ℝ) (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (hAction : AdditiveLinearAction F) (hQ : IsPrimitiveQuarterTurn Q)
    (hMember : ∃ θ : ℝ, F θ = Q)
    (hContinuousA : Continuous (fun t : ℝ => (F t).a))
    (hContinuousC : Continuous (fun t : ℝ => (F t).c))
    (hAxis : ∀ z : ℝ, L z 0 = |z|)
    (hRigid : IsRigidLinearAction L F) :
    ∀ x y : ℝ, L x y = Real.sqrt (x ^ 2 + y ^ 2) := by
  sorry

theorem continuous_isotropy_iff_euclidean_length
    (L : ℝ → ℝ → ℝ)
    (hAxis : ∀ z : ℝ, L z 0 = |z|) :
    (∃ (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd),
      AdditiveLinearAction F ∧
      IsPrimitiveQuarterTurn Q ∧
      (∃ θ : ℝ, F θ = Q) ∧
      Continuous (fun t : ℝ => (F t).a) ∧
      Continuous (fun t : ℝ => (F t).c) ∧
      IsRigidLinearAction L F) ↔
    (∀ x y : ℝ, L x y = Real.sqrt (x ^ 2 + y ^ 2)) := by
  sorry

namespace Counterexamples

@[expose] def boxLength (x y : ℝ) : ℝ := max |x| |y|

theorem boxLength_rigid_normal_iff (u v : ℝ) :
    PrimitiveRigid boxLength u v ↔
      (u = 0 ∧ |v| = 1) ∨ (|u| = 1 ∧ v = 0) := by
  sorry

end Counterexamples

namespace Counterexamples

theorem boxLength_not_pythagorean :
    ¬ ∀ x y : ℝ, x ^ 2 + y ^ 2 = boxLength x y ^ 2 := by
  sorry

end Counterexamples

namespace Counterexamples

theorem boxLength_no_additive_quarter_turn_action
    (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (hAction : AdditiveLinearAction F)
    (hQ : IsPrimitiveQuarterTurn Q)
    (hMember : ∃ θ : ℝ, F θ = Q) :
    ¬ IsRigidLinearAction boxLength F := by
  sorry

end Counterexamples

end PythagoreanIsotropy
