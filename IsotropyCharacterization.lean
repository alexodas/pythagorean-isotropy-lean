module

public import CompactIsotropy
public import EuclideanModel

public section

namespace PythagoreanIsotropy

/-- Among functions calibrated on the horizontal axis, exactly Euclidean
length admits a continuous additive linear action containing a primitive
quarter-turn and preserving that function. No mirror or reachability premise
is needed, and no norm or regularity property of the function is assumed.

The reverse implication supplies an explicit trigonometric model. It does not
construct these motions from synthetic congruence axioms. -/
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
  constructor
  · rintro ⟨F, Q, hAction, hQ, hMember, hA, hC, hRigid⟩
    exact length_eq_sqrt_without_mirror L F Q hAction hQ hMember hA hC hAxis hRigid
  · exact continuous_isotropy_model_of_euclidean_length L

end PythagoreanIsotropy

#print axioms PythagoreanIsotropy.continuous_isotropy_iff_euclidean_length
