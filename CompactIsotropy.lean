module

public import PythagoreanIsotropy
public import CompactCharacter
public import ContinuousIsotropy
import Mathlib.Topology.Instances.Real.Lemmas
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum

public section

namespace PythagoreanIsotropy

/-! A continuous real action containing a primitive quarter-turn has compact
image: its coefficient functions are periodic. Compactness alone rules out
radial scaling; neither a length function nor mirror symmetry is needed. -/

theorem action_normalization
    (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (hAction : AdditiveLinearAction F) (hQ : IsPrimitiveQuarterTurn Q)
    (hMember : ∃ θ : ℝ, F θ = Q) :
    (F 0).a = 1 ∧ (F 0).c = 0 := by
  obtain ⟨θ, hθ⟩ := hMember
  have hn := primitive_quarter_turn_forces_flow_shape F Q hAction hQ ⟨θ, hθ⟩
  have h := hAction 0 θ 1 0
  rw [zero_add, hθ, hQ.1, hn 0 0 1] at h
  have ha := congrArg Prod.snd h
  have hc := congrArg Prod.fst h
  constructor
  · simpa using ha.symm
  · dsimp at hc
    linarith

theorem action_radius_multiplicative
    (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (hAction : AdditiveLinearAction F) (hQ : IsPrimitiveQuarterTurn Q)
    (hMember : ∃ θ : ℝ, F θ = Q) (s t : ℝ) :
    ((F (s + t)).a ^ 2 + (F (s + t)).c ^ 2) =
      ((F s).a ^ 2 + (F s).c ^ 2) * ((F t).a ^ 2 + (F t).c ^ 2) := by
  have hn := primitive_quarter_turn_forces_flow_shape F Q hAction hQ hMember
  have h := hAction s t 1 0
  rw [hn (s + t) 1 0, hn t 1 0, hn s] at h
  have ha := congrArg Prod.fst h
  have hc := congrArg Prod.snd h
  simp only [mul_one, mul_zero, sub_zero, add_zero] at ha hc
  rw [ha, hc]
  ring

theorem action_radius_periodic
    (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (hAction : AdditiveLinearAction F) (hQ : IsPrimitiveQuarterTurn Q)
    (θ : ℝ) (hθ : F θ = Q) :
    θ ≠ 0 ∧ Function.Periodic (fun t => (F t).a ^ 2 + (F t).c ^ 2) θ := by
  have hn := primitive_quarter_turn_forces_flow_shape F Q hAction hQ ⟨θ, hθ⟩
  have h0 := action_normalization F Q hAction hQ ⟨θ, hθ⟩
  have haxis := hQ.1
  rw [← hθ, hn θ 1 0] at haxis
  have hθa : (F θ).a = 0 := by
    simpa using congrArg Prod.fst haxis
  have hθc : (F θ).c = 1 := by
    simpa using congrArg Prod.snd haxis
  constructor
  · intro hzero
    rw [hzero, h0.1] at hθa
    norm_num at hθa
  · intro t
    change (F (t + θ)).a ^ 2 + (F (t + θ)).c ^ 2 = (F t).a ^ 2 + (F t).c ^ 2
    rw [action_radius_multiplicative F Q hAction hQ ⟨θ, hθ⟩ t θ,
      hθa, hθc]
    ring

/-- Compactness of the continuous character rules out radial scaling.
No length function, mirror symmetry, or differentiability is assumed. -/
theorem continuous_action_preserves_quadratic
    (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (hAction : AdditiveLinearAction F) (hQ : IsPrimitiveQuarterTurn Q)
    (hMember : ∃ θ : ℝ, F θ = Q)
    (hContinuousA : Continuous (fun t : ℝ => (F t).a))
    (hContinuousC : Continuous (fun t : ℝ => (F t).c)) :
    ∀ t x y : ℝ,
      ((F t).act x y).1 ^ 2 + ((F t).act x y).2 ^ 2 = x ^ 2 + y ^ 2 := by
  obtain ⟨θ, hθ⟩ := hMember
  have hperiod := action_radius_periodic F Q hAction hQ θ hθ
  have h0 := action_normalization F Q hAction hQ ⟨θ, hθ⟩
  have hs : ∀ t : ℝ, (F t).a ^ 2 + (F t).c ^ 2 = 1 := by
    apply periodic_nonnegative_character_eq_one
      (fun t => (F t).a ^ 2 + (F t).c ^ 2) θ
    · exact (hContinuousA.pow 2).add (hContinuousC.pow 2)
    · exact action_radius_multiplicative F Q hAction hQ ⟨θ, hθ⟩
    · rw [h0.1, h0.2]
      norm_num
    · intro t
      positivity
    · exact hperiod.2
    · exact hperiod.1
  have hn := primitive_quarter_turn_forces_flow_shape F Q hAction hQ ⟨θ, hθ⟩
  intro t x y
  rw [hn t x y]
  change ((F t).a * x - (F t).c * y) ^ 2 +
    ((F t).c * x + (F t).a * y) ^ 2 = x ^ 2 + y ^ 2
  calc
    _ = ((F t).a ^ 2 + (F t).c ^ 2) * (x ^ 2 + y ^ 2) := by ring
    _ = _ := by rw [hs t, one_mul]

/-- Continuous isotropy determines the entire primitive length function.
Mirror symmetry, reachability, nonnegativity, continuity of L, homogeneity,
and the triangle inequality are not premises. -/
theorem length_eq_sqrt_without_mirror
    (L : ℝ → ℝ → ℝ) (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (hAction : AdditiveLinearAction F) (hQ : IsPrimitiveQuarterTurn Q)
    (hMember : ∃ θ : ℝ, F θ = Q)
    (hContinuousA : Continuous (fun t : ℝ => (F t).a))
    (hContinuousC : Continuous (fun t : ℝ => (F t).c))
    (hAxis : ∀ z : ℝ, L z 0 = |z|)
    (hRigid : IsRigidLinearAction L F) :
    ∀ x y : ℝ, L x y = Real.sqrt (x ^ 2 + y ^ 2) := by
  intro x y
  obtain ⟨t, z, hz, ht⟩ := axis_reachable_of_continuous_action F Q hAction hQ
    hMember hContinuousA hContinuousC x y
  have hlen := hRigid t x y
  rw [ht, hAxis z, abs_of_nonneg hz] at hlen
  have hquad := continuous_action_preserves_quadratic F Q hAction hQ hMember
    hContinuousA hContinuousC t x y
  rw [ht] at hquad
  have hquad' : z ^ 2 = x ^ 2 + y ^ 2 := by simpa using hquad
  rw [← hlen, ← hquad', Real.sqrt_sq_eq_abs, abs_of_nonneg hz]

/-- Reflection symmetry follows from continuous isotropy; it need not be postulated. -/
theorem mirror_symmetry_of_continuous_isotropy
    (L : ℝ → ℝ → ℝ) (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (hAction : AdditiveLinearAction F) (hQ : IsPrimitiveQuarterTurn Q)
    (hMember : ∃ θ : ℝ, F θ = Q)
    (hContinuousA : Continuous (fun t : ℝ => (F t).a))
    (hContinuousC : Continuous (fun t : ℝ => (F t).c))
    (hAxis : ∀ z : ℝ, L z 0 = |z|)
    (hRigid : IsRigidLinearAction L F) :
    ∀ x y : ℝ, L x (-y) = L x y := by
  have h := length_eq_sqrt_without_mirror L F Q hAction hQ hMember
    hContinuousA hContinuousC hAxis hRigid
  intro x y
  rw [h x (-y), h x y, neg_sq]

end PythagoreanIsotropy

#print axioms PythagoreanIsotropy.continuous_action_preserves_quadratic
#print axioms PythagoreanIsotropy.length_eq_sqrt_without_mirror
