# JSP-000301 — Two consecutive powerful numbers need not include a perfect square

Lean 4 formalization of a negative answer to [JSP-000301](https://github.com/TheJustinSunPrize/awards/blob/main/problems/catalog-0301-0400.md#JSP-000301), the yes/no part of [Erdős Problem #365](https://www.erdosproblems.com/365).

## Problem

A natural number `n` is *powerful* (Golomb) when every prime `p` dividing `n` satisfies `p² ∣ n`: every exponent in its prime factorization is at least two. Perfect squares are powerful, since every exponent in a square is even and hence at least two whenever the prime occurs.

> If two consecutive positive integers are powerful, must at least one of them be a perfect square?

## Answer

**No.**

Solomon W. Golomb, *Powerful numbers*, Amer. Math. Monthly 77(8) (1970), 848–852, [doi:10.2307/2317020](https://doi.org/10.2307/2317020), gave the counterexample

```text
12167 = 23³            (powerful, not a square)
12168 = 2³ · 3² · 13²  (powerful, not a square)
```

Both sit strictly between consecutive squares: `110² = 12100 < 12167 < 12168 < 12321 = 111²`.

## Proof status

**Complete.** Every declaration in `JSP000301` is proved. The sources contain no `sorry` and no `admit`.

The only axioms used by the answer theorems are the standard kernel axioms `propext`, `Classical.choice`, and `Quot.sound` (the last two through Mathlib's classical arithmetic). CI rejects a source token `sorry` or `admit`, and `axiom-audit` rejects any compiled declaration whose transitive axioms leave that allowlist (in particular `sorryAx`).

What is proved:

- `Powerful` matches Golomb's definition, and for `n ≠ 0` it is equivalent to every prime factor having exponent at least `2`.
- `n ^ k` is powerful whenever `2 ≤ k`, and a product of powerful numbers is powerful. Every perfect square is therefore powerful.
- `12167` and `12168` are powerful and neither is a square.
- There exist consecutive positive integers, both powerful, neither a square.
- The universal claim "every such pair contains a square" is false.

Out of scope, as in the original repository: the counting and density questions also asked in Erdős Problem #365, and whether infinitely many consecutive powerful pairs exist.

## Proof outline

The argument is in `JSP000301/Powerful.lean` (the predicate and its closure properties) and `JSP000301/Main.lean` (Golomb's pair).

1. If a prime `p` divides `n ^ k`, then `p` divides `n`, so `p ^ k` divides `n ^ k`. For `2 ≤ k` this yields `p ^ 2 ∣ n ^ k`.
2. If a prime divides a product, it divides one of the factors, and the square of that prime divides the product. Powerful numbers are therefore closed under multiplication.
3. `12167 = 23 ^ 3` is a third power, and `12168 = 2 ^ 3 * 3 ^ 2 * 13 ^ 2` is a product of three such powers. Both are powerful.
4. Mathlib's `Nat.not_exists_sq'` says nothing strictly between `m ^ 2` and `(m + 1) ^ 2` is a square. Taking `m = 110` rules out both `12167` and `12168`.
5. The pair is consecutive and positive, so it is a counterexample to the universal statement.

## Main theorems

| Theorem | Statement |
| --- | --- |
| `JSP000301.powerful_12167` | `Powerful 12167` |
| `JSP000301.powerful_12168` | `Powerful 12168` |
| `JSP000301.not_isSquare_12167` | `¬ IsSquare 12167` |
| `JSP000301.not_isSquare_12168` | `¬ IsSquare 12168` |
| `JSP000301.exists_consecutive_powerful_not_isSquare` | consecutive positive powerful non-squares exist |
| `JSP000301.not_forall_consecutive_powerful_isSquare` | the answer to JSP-000301 is negative |

Supporting lemmas: `powerful_zero`, `powerful_one`, `powerful_pow`, `powerful_mul`, `IsSquare.powerful`, `powerful_iff_two_le_factorization`, `not_isSquare_of_between`, `eq_12167`, `eq_12168`.

## Build and verify

```bash
# Install elan if needed: https://github.com/leanprover/elan
# The pinned toolchain is installed from ./lean-toolchain.

lake exe cache get
lake build
lake env lean Audit.lean
python3 .github/quality/check_no_sorry.py
```

Expected audit output:

```text
'JSP000301.powerful_12167' depends on axioms: [propext, Classical.choice, Quot.sound]
'JSP000301.powerful_12168' depends on axioms: [propext, Classical.choice, Quot.sound]
'JSP000301.not_isSquare_12167' depends on axioms: [propext, Classical.choice, Quot.sound]
'JSP000301.not_isSquare_12168' depends on axioms: [propext, Classical.choice, Quot.sound]
'JSP000301.exists_consecutive_powerful_not_isSquare' depends on axioms: [propext, Classical.choice, Quot.sound]
'JSP000301.not_forall_consecutive_powerful_isSquare' depends on axioms: [propext, Classical.choice, Quot.sound]
```

## Toolchain

- Lean: `leanprover/lean4:v4.36.0-rc1` (`lean-toolchain`)
- Mathlib: tag `v4.36.0-rc1`, commit `625d8914199bc567cca9b91f90e8e5afafa5ae51` (`lake-manifest.json`)

`v4.36.0-rc1` is the newest Lean release with a matching Mathlib tag. It is a release candidate; the previous pin was `v4.35.0-rc2`. Library files are Lean modules (`module` / `public import`), which is what this Mathlib release expects.

## Attribution

- Mathematical solution: **Solomon W. Golomb (1970)**
- Lean formalization: **yniantongtian-oss (GitHub), with AI assistance**

## License

Apache-2.0 (same as Mathlib). See `LICENSE`.
