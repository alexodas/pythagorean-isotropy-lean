#!/usr/bin/env bash
# Reproduce the bundled independent-kernel registration documented by Palomar.
set -euo pipefail
cd "$(dirname "$0")/.."
command -v bwrap >/dev/null
if ! bwrap --help | grep -q -- '--clearenv'; then
  echo "Comparator requires a newer Bubblewrap with --clearenv support." >&2
  echo "Use the included GitHub workflow or an up-to-date Linux environment." >&2
  exit 1
fi
export PALOMAR_LEAN_PREFIX="$(lean --print-prefix)"
for binary in leanexport leanchecker nanoda_bin con-ron; do
  test -x "$PALOMAR_LEAN_PREFIX/bin/$binary" || {
    echo "Missing bundled checker: $binary" >&2
    exit 1
  }
done
PALOMAR_CONFIG=$(mktemp)
export PALOMAR_CONFIG
trap 'rm -f "$PALOMAR_CONFIG"' EXIT
python3 - <<'PY'
import json
import os
from pathlib import Path
config = json.loads(Path("comparator.json").read_text())
assert "external_kernels" not in config, "Do not submit external_kernels"
config.pop("enable_nanoda", None)
prefix = Path(os.environ["PALOMAR_LEAN_PREFIX"]) / "bin"
config["external_kernels"] = {
    "nanoda": [str(prefix / "nanoda_bin")],
    "con-ron": [str(prefix / "con-ron")],
}
Path(os.environ["PALOMAR_CONFIG"]).write_text(json.dumps(config))
PY
lake comparator --config "$PALOMAR_CONFIG"
