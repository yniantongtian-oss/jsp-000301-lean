# Repository integrity checks

Run `python .github/quality/check_repository.py` with Python 3.12 or newer.

The check uses Git's tracked tree, including paths omitted by a sparse checkout.
It catches filenames that prevent Windows checkout, case-insensitive filename
collisions, malformed package manifests, and duplicate keys in JSON manifests.

`check_no_sorry.py` scans tracked `.lean` files for the tokens `sorry` and
`admit`. Line and block comments are ignored; string literals are not, so a
placeholder hidden in a string fails the check. It runs a built-in lexer
self-test on every invocation. The Lean workflow also runs `axiom-audit`, which
rejects a compiled declaration that depends on `sorryAx`.
Test fixtures containing intentionally invalid manifests are excluded.

These checks complement the project's tests and builds. They do not execute
application code, certify security, or establish scientific or hardware validity.
Existing platform and dependency requirements still apply.

An exact-path exception may be recorded in `exceptions.json` with `code`, `path`
and a specific `reason` for an intentionally platform-specific fixture. There are
no implicit suppressions of failing checks and no blanket directory exceptions.
