/-
Copyright (c) 2026 yniantongtian-oss. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: yniantongtian-oss
-/
import JSP000301.Powerful

/-!
# JSP-000301 · Consecutive powerful numbers need not contain a square

Question (JSP-000301 / part of Erdős Problem #365): if two consecutive positive
integers are both powerful, must one of them be a perfect square?

Answer: **no** (S. W. Golomb, *Powerful numbers*, Amer. Math. Monthly 77 (1970), 848–852).
The pair `12167 = 23 ^ 3` and `12168 = 2 ^ 3 * 3 ^ 2 * 13 ^ 2` is a counterexample:
both are powerful and both lie strictly between `110 ^ 2` and `111 ^ 2`.
-/

namespace JSP000301

theorem eq_12167 : (12167 : ℕ) = 23 ^ 3 := by norm_num
theorem eq_12168 : (12168 : ℕ) = 2 ^ 3 * 3 ^ 2 * 13 ^ 2 := by norm_num

theorem powerful_12167 : Powerful 12167 := by
  intro p hp hdvd
  rw [eq_12167] at hdvd
  have h23 : p ∣ 23 := hp.dvd_of_dvd_pow hdvd
  have hpeq : p = 23 := (Nat.prime_dvd_prime_iff_eq hp (by norm_num)).mp h23
  subst hpeq
  rw [eq_12167]
  exact pow_dvd_pow 23 (by norm_num)

theorem powerful_12168 : Powerful 12168 := by
  intro p hp hdvd
  rw [eq_12168] at hdvd
  rcases hp.dvd_mul.mp hdvd with h | h
  · rcases hp.dvd_mul.mp h with h | h
    · have hpeq : p = 2 :=
        (Nat.prime_dvd_prime_iff_eq hp (by norm_num)).mp (hp.dvd_of_dvd_pow h)
      subst hpeq
      norm_num
    · have hpeq : p = 3 :=
        (Nat.prime_dvd_prime_iff_eq hp (by norm_num)).mp (hp.dvd_of_dvd_pow h)
      subst hpeq
      norm_num
  · have hpeq : p = 13 :=
      (Nat.prime_dvd_prime_iff_eq hp (by norm_num)).mp (hp.dvd_of_dvd_pow h)
    subst hpeq
    norm_num

theorem not_isSquare_12167 : ¬ IsSquare (12167 : ℕ) := by
  rintro ⟨r, hr⟩
  exact Nat.not_exists_sq (m := 110) (n := 12167) (by norm_num) (by norm_num) ⟨r, hr.symm⟩

theorem not_isSquare_12168 : ¬ IsSquare (12168 : ℕ) := by
  rintro ⟨r, hr⟩
  exact Nat.not_exists_sq (m := 110) (n := 12168) (by norm_num) (by norm_num) ⟨r, hr.symm⟩

/-- **Main theorem (existential form).** There are two consecutive positive integers
that are both powerful while neither is a perfect square. -/
theorem exists_consecutive_powerful_not_isSquare :
    ∃ n : ℕ, 0 < n ∧ Powerful n ∧ Powerful (n + 1) ∧ ¬ IsSquare n ∧ ¬ IsSquare (n + 1) := by
  exact ⟨12167, by norm_num, powerful_12167, powerful_12168,
    not_isSquare_12167, not_isSquare_12168⟩

/-- **Main theorem (negated-question form).** The answer to JSP-000301 is negative. -/
theorem not_forall_consecutive_powerful_isSquare :
    ¬ ∀ n : ℕ, 0 < n → Powerful n → Powerful (n + 1) → IsSquare n ∨ IsSquare (n + 1) := by
  intro h
  rcases h 12167 (by norm_num) powerful_12167 powerful_12168 with h' | h'
  · exact not_isSquare_12167 h'
  · exact not_isSquare_12168 h'

end JSP000301
