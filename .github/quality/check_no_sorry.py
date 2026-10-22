"""Reject `sorry` and `admit` tokens in tracked Lean sources.

Comments are ignored. String literals are scanned, so a placeholder hidden in a
string still fails the check. The scan is lexical: `notSorry` is not a hit.
"""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

FORBIDDEN = {"sorry", "admit"}


def tracked_lean(root: Path) -> list[str]:
    result = subprocess.check_output(
        ["git", "ls-tree", "-r", "-z", "--name-only", "HEAD"], cwd=root
    )
    paths = [item.decode("utf-8") for item in result.split(b"\0") if item]
    return [path for path in paths if path.endswith(".lean")]


def scan(path: str, text: str) -> list[dict]:
    """Return `{path, line, column, token}` hits for forbidden identifiers."""
    findings: list[dict] = []
    i = 0
    line = 1
    column = 1
    length = len(text)

    def bump(count: int) -> None:
        nonlocal i, line, column
        end = i + count
        while i < end:
            if text[i] == "\n":
                line += 1
                column = 1
            else:
                column += 1
            i += 1

    def identifier(start_line: int, start_column: int) -> None:
        nonlocal i, line, column
        j = i + 1
        while j < length and (text[j].isalnum() or text[j] in "_'"):
            j += 1
        token = text[i:j]
        token_column = start_column
        token_line = start_line
        bump(j - i)
        if token in FORBIDDEN:
            findings.append(
                {
                    "path": path,
                    "line": token_line,
                    "column": token_column,
                    "token": token,
                }
            )

    while i < length:
        if text.startswith("--", i):
            newline = text.find("\n", i)
            bump(length - i if newline < 0 else newline - i)
            continue
        if text.startswith("/-", i):
            depth = 1
            bump(2)
            while i < length and depth:
                if text.startswith("/-", i):
                    depth += 1
                    bump(2)
                elif text.startswith("-/", i):
                    depth -= 1
                    bump(2)
                else:
                    bump(1)
            continue
        if text[i] == '"':
            bump(1)
            while i < length:
                if text[i] == "\\" and i + 1 < length:
                    bump(2)
                    continue
                if text[i] == '"':
                    bump(1)
                    break
                if text[i].isalpha() or text[i] == "_":
                    identifier(line, column)
                    continue
                bump(1)
            continue
        if text[i].isalpha() or text[i] == "_":
            identifier(line, column)
            continue
        bump(1)
    return findings


def self_test() -> None:
    sample = "\n".join(
        [
            "-- sorry",
            "/- admit -/",
            "/- nested /- sorry -/ still a comment -/",
            'def message := "sorry"',
            'def quoted := "-- admit"',
            "theorem notSorry : True := trivial",
            "theorem bad : True := by",
            "  sorry",
            "theorem badAdmit : True := by",
            "  admit",
            "",
        ]
    )
    found = scan("SelfTest.lean", sample)
    got = [(item["line"], item["token"]) for item in found]
    expected = [(4, "sorry"), (5, "admit"), (8, "sorry"), (10, "admit")]
    if got != expected:
        raise SystemExit(f"no-sorry self-test failed: {got} != {expected}")


def check(root: Path) -> list[dict]:
    findings: list[dict] = []
    for path in tracked_lean(root):
        location = root / path
        text = (
            location.read_text(encoding="utf-8")
            if location.is_file()
            else subprocess.check_output(["git", "show", f"HEAD:{path}"], cwd=root).decode("utf-8")
        )
        findings.extend(scan(path, text))
    return findings


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", nargs="?", type=Path, default=Path("."))
    args = parser.parse_args()
    self_test()
    findings = check(args.root.resolve())
    if findings:
        for item in findings:
            print(
                f"{item['path']}:{item['line']}:{item['column']}: "
                f"forbidden {item['token']}",
                file=sys.stderr,
            )
        print(f"error: {len(findings)} sorry/admit token(s) in Lean sources", file=sys.stderr)
        return 1
    print("no sorry or admit in tracked Lean sources")
    return 0


if __name__ == "__main__":
    sys.exit(main())
