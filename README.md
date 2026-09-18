# JSP-000301 — Two consecutive powerful numbers need not include a perfect square (Lean 4 / Mathlib)

## Problem

> If two consecutive positive integers are powerful, must at least one be a perfect square?

- JSP catalog entry: [JSP-000301](https://github.com/TheJustinSunPrize/awards/blob/main/problems/catalog-0301-0400.md#JSP-000301)
- Related: [Erdős Problem #365](https://www.erdosproblems.com/365)

A natural number `n` is *powerful* (Golomb) if every prime `p` dividing `n`
satisfies `p² ∣ n`, i.e. every prime factor occurs with exponent at least two.

## Answer

**No.**

Counterexample (Solomon W. Golomb, *Powerful numbers*, Amer. Math. Monthly
77(8) (1970), 848–852, [doi:10.2307/2317020](https://doi.org/10.2307/2317020)):

    12167 = 23³            (powerful)
    12168 = 2³ · 3² · 13²  (powerful)

and `110² = 12100 < 12167 < 12168 < 12321 = 111²`, so neither is a perfect square.

## Attribution

- Mathematical solution: **Solomon W. Golomb (1970)**
- Lean formalization: **yniantongtian-oss (GitHub), with AI assistance (Devin by Cognition)**

## Main theorems

All in `JSP000301/Main.lean` (the `Powerful` predicate and its factorization
characterisation are in `JSP000301/Powerful.lean`):

- `JSP000301.powerful_12167` — `Powerful 12167`
- `JSP000301.powerful_12168` — `Powerful 12168`
- `JSP000301.not_isSquare_12167` — `¬ IsSquare 12167`
- `JSP000301.not_isSquare_12168` — `¬ IsSquare 12168`
- `JSP000301.exists_consecutive_powerful_not_isSquare` — there exist two
  consecutive positive integers, both powerful, neither a perfect square
- `JSP000301.not_forall_consecutive_powerful_isSquare` — the answer to
  JSP-000301 is negative

## Build & verify

```bash
# 1. Install elan (https://github.com/leanprover/elan) if not already present;
#    the pinned toolchain is installed automatically from ./lean-toolchain.

# 2. Fetch the precompiled Mathlib cache (avoids rebuilding Mathlib):
lake exe cache get

# 3. Build the project:
lake build

# 4. Axiom audit:
lake env lean Audit.lean
```

Expected audit output:

```
'JSP000301.powerful_12167' depends on axioms: [propext, Classical.choice, Quot.sound]
'JSP000301.powerful_12168' depends on axioms: [propext, Classical.choice, Quot.sound]
'JSP000301.not_isSquare_12167' depends on axioms: [propext, Classical.choice, Quot.sound]
'JSP000301.not_isSquare_12168' depends on axioms: [propext, Classical.choice, Quot.sound]
'JSP000301.exists_consecutive_powerful_not_isSquare' depends on axioms: [propext, Classical.choice, Quot.sound]
'JSP000301.not_forall_consecutive_powerful_isSquare' depends on axioms: [propext, Classical.choice, Quot.sound]
```

## Toolchain

- Lean: `leanprover/lean4:v4.35.0-rc2` (see `lean-toolchain`)
- Mathlib: rev `065356127b1dc0016f66b7283ce0ce2c4055aa55` (tag `v4.35.0-rc2`,
  pinned in `lake-manifest.json`)

## Scope

This formalization covers only the yes/no sub-question of Erdős Problem #365
(whether two consecutive powerful numbers must include a perfect square). It
does not cover the counting/density questions also asked in #365.

## License

Apache-2.0 (same as Mathlib). See `LICENSE`.
