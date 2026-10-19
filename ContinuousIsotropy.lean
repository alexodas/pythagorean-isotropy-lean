module

public import PythagoreanIsotropy
import Mathlib.Topology.Order.IntermediateValue
import Mathlib.Analysis.Real.Sqrt

public section

/-!
# Continuous isotropy without a reachability axiom

The original conditional theorem assumes that the selected displacement can
be moved to the positive horizontal axis.  Here that property is proved for
every displacement from continuity of the two action coefficients.  The
argument uses the intermediate value theorem between the identity and the
half-turn, and needs no differentiability or differential equations.

This is an extension of the formalization, not a claim of historical novelty.
-/

namespace PythagoreanIsotropy

/-- The additive action law and the presence of an invertible quarter-turn
already force the action at zero to be the identity. -/
theorem action_zero_of_primitive_quarter_turn
    (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (hAction : AdditiveLinearAction F)
    (hQ : IsPrimitiveQuarterTurn Q)
    (hMember : ∃ θ : ℝ, F θ = Q) :
    ∀ x y : ℝ, (F 0).act x y = (x, y) := by
  obtain ⟨θ, hθ⟩ := hMember
  have hNormal := primitive_quarter_turn_is_J Q hQ
  intro x y
  have h := hAction 0 θ y (-x)
  simpa only [zero_add, hθ, hNormal, neg_neg] using h.symm

/-- Continuity replaces the per-vector reachability premise.  The path from
the identity to the half-turn crosses the horizontal axis.  If the crossing
is on its negative ray, a further half-turn gives a positive-ray crossing. -/
theorem axis_reachable_of_continuous_action
    (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (hAction : AdditiveLinearAction F)
    (hQ : IsPrimitiveQuarterTurn Q)
    (hMember : ∃ θ : ℝ, F θ = Q)
    (hContinuousA : Continuous (fun t : ℝ => (F t).a))
    (hContinuousC : Continuous (fun t : ℝ => (F t).c))
    (a b : ℝ) :
    ∃ t z : ℝ, 0 ≤ z ∧ (F t).act a b = (z, 0) := by
  obtain ⟨θ, hθ⟩ := hMember
  have hZero := action_zero_of_primitive_quarter_turn F Q hAction hQ ⟨θ, hθ⟩
  have hNormal := primitive_quarter_turn_forces_flow_shape F Q hAction hQ ⟨θ, hθ⟩
  have hHalf : ∀ x y : ℝ, (F (θ + θ)).act x y = (-x, -y) := by
    intro x y
    have h := hAction θ θ x y
    rw [hθ] at h
    exact h.trans (hQ.2 x y)
  let f : ℝ → ℝ := fun t => ((F t).act a b).2
  have hf : Continuous f := by
    have hfun : f = fun t => (F t).c * a + (F t).a * b := by
      funext t
      simp only [f, hNormal]
    rw [hfun]
    exact (hContinuousC.mul continuous_const).add (hContinuousA.mul continuous_const)
  have hf0 : f 0 = b := by simp only [f, hZero]
  have hfHalf : f (θ + θ) = -b := by simp only [f, hHalf]
  have hExists : ∃ t : ℝ, f t = 0 := by
    by_cases hb : 0 ≤ b
    · apply intermediate_value_univ₂ hf continuous_const (a := θ + θ) (b := 0)
      · rw [hfHalf]
        linarith
      · simpa only [hf0] using hb
    · apply intermediate_value_univ₂ hf continuous_const (a := 0) (b := θ + θ)
      · rw [hf0]
        linarith
      · rw [hfHalf]
        linarith
  obtain ⟨t, ht⟩ := hExists
  let z : ℝ := ((F t).act a b).1
  have hAxis : (F t).act a b = (z, 0) := by
    apply Prod.ext
    · rfl
    · exact ht
  by_cases hz : 0 ≤ z
  · exact ⟨t, z, hz, hAxis⟩
  · refine ⟨θ + θ + t, -z, by linarith, ?_⟩
    rw [hAction (θ + θ) t a b, hAxis]
    simpa only [neg_zero] using hHalf z 0

/-- Global squared-length characterization: there is no reachability
hypothesis for the selected vector.  Continuity of the action implies it. -/
theorem length_sq_of_continuous_isotropy
    (L : ℝ → ℝ → ℝ) (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (hAction : AdditiveLinearAction F)
    (hQ : IsPrimitiveQuarterTurn Q)
    (hMember : ∃ θ : ℝ, F θ = Q)
    (hContinuousA : Continuous (fun t : ℝ => (F t).a))
    (hContinuousC : Continuous (fun t : ℝ => (F t).c))
    (hAxis : ∀ z : ℝ, L z 0 = |z|)
    (hMirror : ∀ x y : ℝ, L x (-y) = L x y)
    (hRigid : IsRigidLinearAction L F)
    (a b : ℝ) :
    L a b ^ 2 = a ^ 2 + b ^ 2 := by
  have hReach := axis_reachable_of_continuous_action F Q hAction hQ hMember
    hContinuousA hContinuousC a b
  exact (pythagoras_from_metric_free_quarter_turn L F Q a b (L a b)
    hAction hQ hMember hAxis hMirror hRigid hReach rfl).symm

/-- The primitive length itself is uniquely determined, not only its square.
Positivity is a consequence of axial calibration and derived reachability. -/
theorem length_eq_sqrt_of_continuous_isotropy
    (L : ℝ → ℝ → ℝ) (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (hAction : AdditiveLinearAction F)
    (hQ : IsPrimitiveQuarterTurn Q)
    (hMember : ∃ θ : ℝ, F θ = Q)
    (hContinuousA : Continuous (fun t : ℝ => (F t).a))
    (hContinuousC : Continuous (fun t : ℝ => (F t).c))
    (hAxis : ∀ z : ℝ, L z 0 = |z|)
    (hMirror : ∀ x y : ℝ, L x (-y) = L x y)
    (hRigid : IsRigidLinearAction L F)
    (a b : ℝ) :
    L a b = Real.sqrt (a ^ 2 + b ^ 2) := by
  obtain ⟨t, z, hz, ht⟩ := axis_reachable_of_continuous_action F Q hAction hQ hMember
    hContinuousA hContinuousC a b
  have hlen := hRigid t a b
  rw [ht, hAxis z, abs_of_nonneg hz] at hlen
  have hnonneg : 0 ≤ L a b := by linarith
  have hsq := length_sq_of_continuous_isotropy L F Q hAction hQ hMember
    hContinuousA hContinuousC hAxis hMirror hRigid a b
  have hsum : 0 ≤ a ^ 2 + b ^ 2 := add_nonneg (sq_nonneg a) (sq_nonneg b)
  have hsqrt := Real.sq_sqrt hsum
  have hsqrt_nonneg := Real.sqrt_nonneg (a ^ 2 + b ^ 2)
  nlinarith

end PythagoreanIsotropy

#print axioms PythagoreanIsotropy.axis_reachable_of_continuous_action
#print axioms PythagoreanIsotropy.length_eq_sqrt_of_continuous_isotropy
