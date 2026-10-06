#!/usr/bin/env bash
# Paso 2 de la migración: analizar la aplicación antes de tocar código.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf out biblioteca.jar

javac -d out -cp lib/csvlite-1.0.jar $(find src -name "*.java")
jar --create --file biblioteca.jar -C out . -C src META-INF

echo "== Resumen de dependencias (jdeps -s)"
jdeps -s -cp lib/csvlite-1.0.jar biblioteca.jar

echo; echo "== Dependencias por paquete"
jdeps -verbose:package -cp lib/csvlite-1.0.jar biblioteca.jar | grep -v "java.base"

echo; echo "== ¿Usamos APIs internas del JDK?"
jdeps --jdk-internals -cp lib/csvlite-1.0.jar biblioteca.jar || true

echo; echo "== ¿Cómo se llamaría la librería como módulo automático?"
jar --describe-module --file lib/csvlite-1.0.jar

rm -rf out biblioteca.jar
