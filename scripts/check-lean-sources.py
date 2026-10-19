#!/usr/bin/env python3
"""Preflight for this repository; Lean and Palomar perform the full parsing."""
from pathlib import Path

root = Path(__file__).resolve().parents[1]
for path in root.rglob("*.lean"):
    relative = path.relative_to(root)
    if any(part in {".git", ".lake"} for part in relative.parts):
        continue
    assert not path.is_symlink(), f"Symlink forbidden: {relative}"
    text = path.read_text(encoding="utf-8")
    if path.name != "lakefile.lean":
        assert text.startswith("module\n"), f"Missing initial module header: {relative}"
    assert len(text.splitlines()) <= 10000, f"Source too large: {relative}"
print("PASS: all project Lean sources have module headers and satisfy the line cap.")
