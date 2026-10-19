module

public import PythagoreanIsotropy
public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
public import Mathlib.Analysis.Real.Sqrt

public section

/-!
# An explicit model of the continuous isotropy hypotheses

The standard trigonometric rotation action supplies a model, so the extended
axioms are jointly satisfiable.  This is a consistency/model construction
inside the existing real analysis library.  It is not a construction of
Euclidean geometry from synthetic axioms, and does not establish novelty.
-/

namespace PythagoreanIsotropy

@[expose] noncomputable def euclideanLength (x y : ℝ) : ℝ :=
  Real.sqrt (x ^ 2 + y ^ 2)

@[expose] noncomputable def standardRotation (t : ℝ) : LinearPlaneEnd where
  a := Real.cos t
  b := -Real.sin t
  c := Real.sin t
  d := Real.cos t

@[expose] def standardQuarterTurn : LinearPlaneEnd where
  a := 0
  b := -1
  c := 1
  d := 0

theorem standardRotation_additive : AdditiveLinearAction standardRotation := by
  intro s t x y
  apply Prod.ext <;>
    simp only [LinearPlaneEnd.act, standardRotation, Real.cos_add, Real.sin_add] <;>
    ring

theorem standardQuarterTurn_primitive : IsPrimitiveQuarterTurn standardQuarterTurn := by
  constructor
  · simp [LinearPlaneEnd.act, standardQuarterTurn]
  · intro x y
    apply Prod.ext <;> simp [LinearPlaneEnd.act, standardQuarterTurn]

theorem standardQuarterTurn_member :
    ∃ θ : ℝ, standardRotation θ = standardQuarterTurn := by
  refine ⟨Real.pi / 2, ?_⟩
  simp [standardRotation, standardQuarterTurn]

theorem standardRotation_continuousA :
    Continuous (fun t : ℝ => (standardRotation t).a) :=
  Real.continuous_cos

theorem standardRotation_continuousC :
    Continuous (fun t : ℝ => (standardRotation t).c) :=
  Real.continuous_sin

theorem standardRotation_preserves_quadratic (t x y : ℝ) :
    ((standardRotation t).act x y).1 ^ 2 +
      ((standardRotation t).act x y).2 ^ 2 = x ^ 2 + y ^ 2 := by
  change (Real.cos t * x + -Real.sin t * y) ^ 2 +
    (Real.sin t * x + Real.cos t * y) ^ 2 = _
  calc
    (Real.cos t * x + -Real.sin t * y) ^ 2 +
        (Real.sin t * x + Real.cos t * y) ^ 2 =
      (Real.sin t ^ 2 + Real.cos t ^ 2) * (x ^ 2 + y ^ 2) := by ring
    _ = x ^ 2 + y ^ 2 := by rw [Real.sin_sq_add_cos_sq]; ring

theorem euclideanLength_axis (z : ℝ) : euclideanLength z 0 = |z| := by
  simp [euclideanLength, Real.sqrt_sq_eq_abs]

theorem euclideanLength_mirror (x y : ℝ) :
    euclideanLength x (-y) = euclideanLength x y := by
  simp [euclideanLength]

theorem standardRotation_rigid : IsRigidLinearAction euclideanLength standardRotation := by
  intro t x y
  change Real.sqrt (((standardRotation t).act x y).1 ^ 2 +
    ((standardRotation t).act x y).2 ^ 2) = _
  rw [standardRotation_preserves_quadratic]
  rfl

/-- Every pointwise Euclidean length admits the explicit continuous action.
Together with a converse characterization this yields an existence iff,
rather than only a conditional implication from an uninstantiated action. -/
theorem continuous_isotropy_model_of_euclidean_length
    (L : ℝ → ℝ → ℝ)
    (hL : ∀ x y : ℝ, L x y = Real.sqrt (x ^ 2 + y ^ 2)) :
    ∃ (F : ℝ → LinearPlaneEnd) (Q : LinearPlaneEnd),
      AdditiveLinearAction F ∧
      IsPrimitiveQuarterTurn Q ∧
      (∃ θ : ℝ, F θ = Q) ∧
      Continuous (fun t : ℝ => (F t).a) ∧
      Continuous (fun t : ℝ => (F t).c) ∧
      IsRigidLinearAction L F := by
  refine ⟨standardRotation, standardQuarterTurn,
    standardRotation_additive, standardQuarterTurn_primitive,
    standardQuarterTurn_member, standardRotation_continuousA,
    standardRotation_continuousC, ?_⟩
  intro t x y
  simp only [hL, standardRotation_preserves_quadratic]

end PythagoreanIsotropy

#print axioms PythagoreanIsotropy.continuous_isotropy_model_of_euclidean_length
