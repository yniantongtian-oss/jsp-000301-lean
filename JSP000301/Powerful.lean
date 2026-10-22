/-
Copyright (c) 2026 yniantongtian-oss. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: yniantongtian-oss
-/
module

public import Mathlib.Algebra.Group.Even
public import Mathlib.Data.Nat.Factorization.Basic
public import Mathlib.Data.Nat.Prime.Basic

/-!
# Powerful numbers

A natural number `n` is *powerful* (Golomb, 1970) if every prime `p` dividing `n`
satisfies `p ^ 2 ∣ n`. Equivalently, in the prime factorization of a positive `n`,
every exponent is at least two.

Powers `n ^ k` with `2 ≤ k` are powerful, and the property is closed under
multiplication, so every perfect square is powerful. The converse fails:
`23 ^ 3` is powerful but not a square (see `JSP000301.Main`).
-/

public section

namespace JSP000301

/-- `Powerful n` : every prime factor of `n` divides `n` at least twice. -/
def Powerful (n : ℕ) : Prop := ∀ p : ℕ, p.Prime → p ∣ n → p ^ 2 ∣ n

/-- `0` is powerful: `p ^ 2` divides `0` for every prime `p`. -/
theorem powerful_zero : Powerful 0 := by
  intro _ _ _
  exact dvd_zero _

/-- `1` is powerful: it has no prime divisors. -/
theorem powerful_one : Powerful 1 := by
  intro p hp hdvd
  exact absurd hdvd hp.not_dvd_one

/-- A `k`-th power with `2 ≤ k` is powerful. The base need not be prime. -/
theorem powerful_pow {n k : ℕ} (hk : 2 ≤ k) : Powerful (n ^ k) := by
  intro p hp hdvd
  rcases hp.dvd_of_dvd_pow hdvd with ⟨t, ht⟩
  rw [ht, mul_pow]
  exact dvd_mul_of_dvd_left (pow_dvd_pow p hk) (t ^ k)

/-- Powerful numbers are closed under multiplication. -/
theorem powerful_mul {m n : ℕ} (hm : Powerful m) (hn : Powerful n) : Powerful (m * n) := by
  intro p hp hdvd
  rcases hp.dvd_mul.mp hdvd with hpm | hpn
  · exact dvd_trans (hm p hp hpm) (dvd_mul_right _ _)
  · exact dvd_trans (hn p hp hpn) (dvd_mul_left _ _)

/-- Every perfect square is powerful. -/
theorem IsSquare.powerful {n : ℕ} (h : IsSquare n) : Powerful n := by
  rcases h with ⟨r, hr⟩
  rw [hr, ← pow_two]
  exact powerful_pow le_rfl

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
