#!/usr/bin/env bash
# Build openair-iris-compat. Usage: build.sh <javac-dir> <fabric-loader.jar> <out.jar>
set -euo pipefail
B="$(cd "$(dirname "$0")" && pwd)"; J="$1"; LOADER="$2"; OUT="$3"; C="$(mktemp -d)"
"$J/javac" --release 21 -cp "$LOADER" -d "$C" "$B"/src/openair/iriscompat/*.java
"$J/jar" --create --file "$OUT" -C "$C" . -C "$B/resources" .
echo "built $OUT"
