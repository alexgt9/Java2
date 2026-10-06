#!/usr/bin/env bash
# Regenera ../lib/csvlite-1.0.jar. Solo hace falta si cambias el código de la librería.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out
javac --release 17 -d out $(find src -name "*.java")
jar --create --file ../lib/csvlite-1.0.jar -C out .
rm -rf out
