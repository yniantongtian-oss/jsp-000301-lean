/-
Copyright (c) 2026 yniantongtian-oss. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: yniantongtian-oss
-/
module

public import JSP000301.Powerful
import Mathlib.Data.Nat.Sqrt
import Mathlib.Tactic.NormNum

/-!
# JSP-000301 · Consecutive powerful numbers need not contain a square

Question (JSP-000301 / part of Erdős Problem #365): if two consecutive positive
integers are both powerful, must one of them be a perfect square?

Answer: **no** (S. W. Golomb, *Powerful numbers*, Amer. Math. Monthly 77 (1970),
848–852). The pair

* `12167 = 23 ^ 3`
* `12168 = 2 ^ 3 * 3 ^ 2 * 13 ^ 2`

is a counterexample. Both factors on the right are powers with exponent at least
two, hence powerful, and a product of powerful numbers is powerful. Both integers
lie strictly between `110 ^ 2 = 12100` and `111 ^ 2 = 12321`, so neither is a square.
-/

public section

namespace JSP000301

/-- No natural number strictly between `m ^ 2` and `(m + 1) ^ 2` is a perfect square. -/
theorem not_isSquare_of_between {n m : ℕ} (hlo : m ^ 2 < n) (hhi : n < (m + 1) ^ 2) :
    ¬ IsSquare n := by
  intro h
  rcases h with ⟨r, hr⟩
  exact Nat.not_exists_sq' hlo hhi ⟨r, by simpa [pow_two] using hr.symm⟩

/-- Golomb's first term, as a prime power. -/
theorem eq_12167 : (12167 : ℕ) = 23 ^ 3 := by norm_num

/-- Golomb's second term, factored into powers of exponent at least two. -/
theorem eq_12168 : (12168 : ℕ) = 2 ^ 3 * 3 ^ 2 * 13 ^ 2 := by norm_num

/-- `12167 = 23 ^ 3` is powerful. -/
theorem powerful_12167 : Powerful 12167 := by
  rw [eq_12167]
  exact powerful_pow (by norm_num)

/-- `12168 = 2 ^ 3 * 3 ^ 2 * 13 ^ 2` is powerful. -/
theorem powerful_12168 : Powerful 12168 := by
  rw [eq_12168]
  exact powerful_mul
    (powerful_mul (powerful_pow (by norm_num)) (powerful_pow (by norm_num)))
    (powerful_pow (by norm_num))

/-- `12167` lies strictly between `110 ^ 2` and `111 ^ 2`. -/
theorem not_isSquare_12167 : ¬ IsSquare (12167 : ℕ) :=
  not_isSquare_of_between (m := 110) (by norm_num) (by norm_num)

/-- `12168` lies strictly between `110 ^ 2` and `111 ^ 2`. -/
theorem not_isSquare_12168 : ¬ IsSquare (12168 : ℕ) :=
  not_isSquare_of_between (m := 110) (by norm_num) (by norm_num)

/-- **Main theorem (existential form).** There are two consecutive positive integers
that are both powerful while neither is a perfect square. -/
theorem exists_consecutive_powerful_not_isSquare :
    ∃ n : ℕ, 0 < n ∧ Powerful n ∧ Powerful (n + 1) ∧ ¬ IsSquare n ∧ ¬ IsSquare (n + 1) :=
  ⟨12167, by norm_num, powerful_12167, powerful_12168, not_isSquare_12167, not_isSquare_12168⟩

/-- **Main theorem (negated-question form).** The answer to JSP-000301 is negative. -/
theorem not_forall_consecutive_powerful_isSquare :
    ¬ ∀ n : ℕ, 0 < n → Powerful n → Powerful (n + 1) → IsSquare n ∨ IsSquare (n + 1) := by
  intro h
  rcases h 12167 (by norm_num) powerful_12167 powerful_12168 with h' | h'
  · exact not_isSquare_12167 h'
  · exact not_isSquare_12168 h'

end JSP000301
