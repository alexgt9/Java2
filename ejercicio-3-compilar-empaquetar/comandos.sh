#!/usr/bin/env bash
# Ejercicio 3: escribe aquí los comandos de cada paso.
# Antes, copia en esta carpeta el src/ de tu ejercicio 2.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out mods runtime

# 1. Compila los tres módulos en out/ usando --module-source-path
# TODO

# 2. Empaqueta cada módulo como JAR modular en mods/
#    (el de app, con la clase principal, para poder ejecutarlo solo con su nombre)
# TODO

# 3. Ejecuta la aplicación con: java -p mods -m com.biblioteca.app
# TODO

# 4. Crea en runtime/ un runtime con jlink, con un lanzador llamado "biblioteca"
# TODO
