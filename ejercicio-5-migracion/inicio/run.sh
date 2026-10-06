#!/usr/bin/env bash
# Compila y ejecuta la versión NO modular (classpath) de la biblioteca.
# Uso: ./run.sh [formato]
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out

javac -d out -cp lib/csvlite-1.0.jar $(find src -name "*.java")
cp -R src/META-INF out/

if [ $# -gt 0 ]; then
    echo "$1" | java -cp out:lib/csvlite-1.0.jar com.biblioteca.app.Main
else
    java -cp out:lib/csvlite-1.0.jar com.biblioteca.app.Main
fi
