#!/usr/bin/env bash
# Compila y ejecuta un ejercicio.  Uso: ./ejecutar.sh <número> [texto para la entrada estándar]
# Ejemplo: ./ejecutar.sh 4 json
set -euo pipefail
cd "$(dirname "$0")"

n="${1:?Uso: ./ejecutar.sh <número de ejercicio> [entrada]}"
dir="$(ls -d ejercicio-"$n"-* 2>/dev/null | head -1)"
[ -d "$dir/src" ] || { echo "No encuentro $dir/src"; exit 1; }
cd "$dir"

libs=()
[ -d inicio/lib ] && [ "$n" = 5 ] && libs=(--module-path inicio/lib)
modules="$(cd src && ls -d */ | tr -d / | paste -sd, -)"

rm -rf out
javac -d out --module-source-path src ${libs[@]+"${libs[@]}"} --module "$modules"

path=out
[ "$n" = 5 ] && path=out:inicio/lib
if [ $# -gt 1 ]; then
    echo "$2" | java -p "$path" -m com.biblioteca.app/com.biblioteca.app.Main
else
    java -p "$path" -m com.biblioteca.app/com.biblioteca.app.Main
fi
