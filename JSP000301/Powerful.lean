/-
Copyright (c) 2026 yniantongtian-oss. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: yniantongtian-oss
-/
import Mathlib.Algebra.Group.Even
import Mathlib.Data.Nat.Factorization.Basic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Nat.Sqrt
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.NormNum.Prime

/-!
# Powerful numbers

A natural number `n` is *powerful* (Golomb, 1970) if every prime `p` dividing `n`
satisfies `p ^ 2 ∣ n`.
-/

namespace JSP000301

/-- `Powerful n` : every prime factor of `n` divides `n` at least twice. -/
def Powerful (n : ℕ) : Prop := ∀ p : ℕ, p.Prime → p ∣ n → p ^ 2 ∣ n

/-- Equivalent characterisation via `Nat.factorization`: every prime factor has
exponent at least two. -/
theorem powerful_iff_two_le_factorization {n : ℕ} (hn : n ≠ 0) :
    Powerful n ↔ ∀ p : ℕ, p.Prime → p ∣ n → 2 ≤ n.factorization p := by
  unfold Powerful
  constructor
  · intro h p hp hdvd
    exact (hp.pow_dvd_iff_le_factorization hn).mp (h p hp hdvd)
  · intro h p hp hdvd
    exact (hp.pow_dvd_iff_le_factorization hn).mpr (h p hp hdvd)

end JSP000301
