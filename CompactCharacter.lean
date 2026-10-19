module

public import Mathlib.Topology.Instances.Real.Lemmas
public import Mathlib.Topology.Order.Compact

public section

namespace PythagoreanIsotropy

/-- A nonnegative continuous real character with a nonzero period is trivial.

The compact range has a positive global maximum. Multiplication by any value
of the character cannot increase that maximum, so the value is at most one.
Applying the same observation at the negative argument gives the reverse bound.
-/
theorem periodic_nonnegative_character_eq_one
    (f : ℝ → ℝ) (period : ℝ)
    (hf : Continuous f)
    (hadd : ∀ s t : ℝ, f (s + t) = f s * f t)
    (hzero : f 0 = 1)
    (hnonneg : ∀ t : ℝ, 0 ≤ f t)
    (hperiod : Function.Periodic f period)
    (hperiod_ne : period ≠ 0) :
    ∀ t : ℝ, f t = 1 := by
  have hcompact : IsCompact (Set.range f) :=
    hperiod.compact_of_continuous hperiod_ne hf
  obtain ⟨M, hM⟩ := hcompact.exists_isGreatest (Set.range_nonempty f)
  obtain ⟨r, hr⟩ := hM.1
  have hMone : 1 ≤ M := by
    simpa only [hzero] using hM.2 (Set.mem_range_self 0)
  have hMpos : 0 < M := lt_of_lt_of_le zero_lt_one hMone
  have hle : ∀ t : ℝ, f t ≤ 1 := by
    intro t
    have h := hM.2 (Set.mem_range_self (t + r))
    rw [hadd, hr] at h
    have h' : f t * M ≤ 1 * M := by simpa only [one_mul] using h
    exact le_of_mul_le_mul_right h' hMpos
  intro t
  have hinverse : f t * f (-t) = 1 := by
    simpa only [add_neg_cancel, hzero] using (hadd t (-t)).symm
  have hlower := mul_le_mul_of_nonneg_left (hle (-t)) (hnonneg t)
  rw [hinverse, mul_one] at hlower
  exact le_antisymm (hle t) hlower

end PythagoreanIsotropy
