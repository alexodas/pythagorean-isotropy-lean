module

public import PythagoreanIsotropy
import Mathlib.Topology.Order.Lattice

public section

/-!
# What finite coordinate symmetries do not determine

The maximum norm is a continuous, positive, homogeneous length satisfying the
triangle inequality, horizontal calibration, mirror symmetry, and quarter-turn
invariance. Nevertheless its value at `(1,1)` is `1`, not `sqrt 2`.

Thus finite coordinate symmetries and the elementary length properties do not
by themselves characterize Euclidean length. This is a counterexample to that
weaker package, NOT a model of all the hypotheses of
`pythagoras_from_metric_free_quarter_turn` with just `hToAxis` removed. Indeed,
`boxLength_no_additive_quarter_turn_action` proves that this length cannot
admit a rigid additive real action containing a primitive quarter turn.
-/

namespace PythagoreanIsotropy.Counterexamples

/-- A genuine non-Euclidean length with the required finite coordinate symmetries. -/
@[expose] def boxLength (x y : ℝ) : ℝ := max |x| |y|

theorem boxLength_nonneg (x y : ℝ) : 0 ≤ boxLength x y := by
  exact le_trans (abs_nonneg x) (le_max_left _ _)

theorem boxLength_eq_zero_iff (x y : ℝ) :
    boxLength x y = 0 ↔ x = 0 ∧ y = 0 := by
  constructor
  · intro h
    have hx : |x| ≤ 0 := by rw [← h]; exact le_max_left _ _
    have hy : |y| ≤ 0 := by rw [← h]; exact le_max_right _ _
    exact ⟨abs_eq_zero.mp (le_antisymm hx (abs_nonneg x)),
      abs_eq_zero.mp (le_antisymm hy (abs_nonneg y))⟩
  · rintro ⟨rfl, rfl⟩
    simp [boxLength]

theorem boxLength_axis (x : ℝ) : boxLength x 0 = |x| := by
  simp [boxLength]

theorem boxLength_mirror (x y : ℝ) : boxLength x (-y) = boxLength x y := by
  simp [boxLength]

theorem boxLength_quarter_turn (x y : ℝ) :
    boxLength (-y) x = boxLength x y := by
  simp [boxLength, max_comm]

theorem boxLength_homogeneous (r x y : ℝ) :
    boxLength (r * x) (r * y) = |r| * boxLength x y := by
  simp only [boxLength, abs_mul]
  exact (mul_max_of_nonneg _ _ (abs_nonneg r)).symm

theorem boxLength_triangle (x₁ y₁ x₂ y₂ : ℝ) :
    boxLength (x₁ + x₂) (y₁ + y₂) ≤
      boxLength x₁ y₁ + boxLength x₂ y₂ := by
  apply max_le
  · exact le_trans (abs_add_le _ _) (add_le_add (le_max_left _ _) (le_max_left _ _))
  · exact le_trans (abs_add_le _ _) (add_le_add (le_max_right _ _) (le_max_right _ _))

theorem boxLength_continuous : Continuous (fun p : ℝ × ℝ => boxLength p.1 p.2) := by
  exact continuous_fst.abs.max continuous_snd.abs

theorem boxLength_not_pythagorean :
    ¬ ∀ x y : ℝ, x ^ 2 + y ^ 2 = boxLength x y ^ 2 := by
  intro h
  have h11 := h 1 1
  norm_num [boxLength] at h11

/-- The primitive quarter turn itself is rigid for this non-Euclidean length. -/
@[expose] def boxQuarterTurn : LinearPlaneEnd := ⟨0, -1, 1, 0⟩

theorem boxQuarterTurn_primitive : IsPrimitiveQuarterTurn boxQuarterTurn := by
  constructor
  · norm_num [boxQuarterTurn, LinearPlaneEnd.act]
  · intro x y
    simp [boxQuarterTurn, LinearPlaneEnd.act]

theorem boxQuarterTurn_rigid (x y : ℝ) :
    boxLength (boxQuarterTurn.act x y).1 (boxQuarterTurn.act x y).2 =
      boxLength x y := by
  simpa [boxQuarterTurn, LinearPlaneEnd.act] using boxLength_quarter_turn x y

/-- Among matrices commuting with the quarter turn, the rigid matrices of the
maximum norm are exactly the four signed coordinate quarter turns. -/
theorem boxLength_rigid_normal_iff (u v : ℝ) :
    PrimitiveRigid boxLength u v ↔
      (u = 0 ∧ |v| = 1) ∨ (|u| = 1 ∧ v = 0) := by
  constructor
  · intro hRigid
    have hdet := determinant_one_from_primitive_rigidity boxLength u v
      boxLength_axis boxLength_mirror hRigid
    have hmax : max |u| |v| = 1 := by
      simpa [boxLength] using hRigid 1 0
    rcases le_total |u| |v| with hle | hle
    · have hv : |v| = 1 := by simpa [max_eq_right hle] using hmax
      have hvsq : v ^ 2 = 1 := by nlinarith [sq_abs v]
      have husq : u ^ 2 = 0 := by nlinarith
      exact Or.inl ⟨(sq_eq_zero_iff).mp husq, hv⟩
    · have hu : |u| = 1 := by simpa [max_eq_left hle] using hmax
      have husq : u ^ 2 = 1 := by nlinarith [sq_abs u]
      have hvsq : v ^ 2 = 0 := by nlinarith
      exact Or.inr ⟨hu, (sq_eq_zero_iff).mp hvsq⟩
  · rintro (⟨hu, hv⟩ | ⟨hu, hv⟩) x y
    · simp [boxLength, hu, abs_mul, hv, max_comm]
    · simp [boxLength, hv, abs_mul, hu]

/-- A real additive action containing a quarter turn would also contain its
square root. The maximum norm admits no such rigid rotation-coordinate root. -/
theorem boxLength_no_rigid_quarter_turn_root (u v : ℝ)
    (hRigid : PrimitiveRigid boxLength u v) :
    ¬ (u ^ 2 - v ^ 2 = 0 ∧ 2 * u * v = 1) := by
  intro hroot
  rcases (boxLength_rigid_normal_iff u v).mp hRigid with ⟨hu, _⟩ | ⟨_, hv⟩
  · simp [hu] at hroot
  · simp [hv] at hroot

/-- The obstruction already applies to abstract real additive actions, with no
continuity premise: divisibility supplies a rigid square root of the quarter
turn, which the maximum norm cannot admit. -/
theorem boxLength_no_additive_quarter_turn_action
    (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd)
    (hAction : AdditiveLinearAction F)
    (hQ : IsPrimitiveQuarterTurn Q)
    (hMember : ∃ θ : ℝ, F θ = Q) :
    ¬ IsRigidLinearAction boxLength F := by
  intro hRigid
  obtain ⟨θ, hθ⟩ := hMember
  have hNormal := primitive_quarter_turn_forces_flow_shape F Q hAction hQ ⟨θ, hθ⟩
  have hHalfRigid := primitive_quarter_turn_flow_is_rigid_normal_form
    boxLength F Q hAction hQ ⟨θ, hθ⟩ hRigid (θ / 2)
  have hDouble := hAction (θ / 2) (θ / 2) 1 0
  have hsum : θ / 2 + θ / 2 = θ := by ring
  rw [hsum, hθ, hQ.1] at hDouble
  simp only [hNormal, mul_one, mul_zero, sub_zero, add_zero] at hDouble
  have hFirst := congrArg Prod.fst hDouble
  have hSecond := congrArg Prod.snd hDouble
  have hRoot : (F (θ / 2)).a ^ 2 - (F (θ / 2)).c ^ 2 = 0 ∧
      2 * (F (θ / 2)).a * (F (θ / 2)).c = 1 := by
    constructor
    · dsimp at hFirst
      nlinarith
    · dsimp at hSecond
      nlinarith
  exact boxLength_no_rigid_quarter_turn_root _ _ hHalfRigid hRoot

/-- The lack of axis reachability is real: no length-preserving map of the
rotation-coordinate shape can carry `(1,1)` onto the horizontal axis. -/
theorem boxLength_no_normal_rigid_axis_reachability (u v : ℝ)
    (hRigid : PrimitiveRigid boxLength u v) :
    ¬ ∃ z : ℝ, u - v = z ∧ v + u = 0 := by
  rintro ⟨z, _hz, hzero⟩
  have hv : v = -u := by linarith
  have h10 := hRigid 1 0
  have h11 := hRigid 1 1
  have habs : |u| = 1 := by
    simpa [boxLength, hv] using h10
  have htwice : |2 * u| = 1 := by
    have heq : u - -u = 2 * u := by ring
    simpa [boxLength, hv, heq] using h11
  rw [abs_mul] at htwice
  norm_num [habs] at htwice

end PythagoreanIsotropy.Counterexamples

#print axioms PythagoreanIsotropy.Counterexamples.boxLength_not_pythagorean
#print axioms PythagoreanIsotropy.Counterexamples.boxLength_no_normal_rigid_axis_reachability
#print axioms PythagoreanIsotropy.Counterexamples.boxLength_no_additive_quarter_turn_action
