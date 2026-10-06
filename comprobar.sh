#!/usr/bin/env bash
# Comprueba tu solución de un ejercicio (o de todos).
# Uso: ./comprobar.sh [número]     Ejemplo: ./comprobar.sh 2
#
# Compila tu código y revisa la estructura de los módulos con `java --describe-module`:
# qué exporta, qué requiere, qué ofrece y qué usa cada uno.
set -uo pipefail
cd "$(dirname "$0")"
ROOT="$PWD"
fails=0; passes=0

ok()   { echo "  OK     $1"; passes=$((passes + 1)); }
fail() { echo "  FALLO  $1"; [ -n "${2:-}" ] && echo "$2" | head -8 | sed 's/^/           /'; fails=$((fails + 1)); }

# compile <dir> [module-path]: compila todos los módulos de <dir>/src en <dir>/out
compile() {
    local dir="$1" mp="${2:-}" modules out
    if [ ! -d "$dir/src" ]; then fail "existe $dir/src"; return 1; fi
    modules="$(cd "$dir/src" && ls -d */ 2>/dev/null | tr -d / | paste -sd, -)"
    rm -rf "$dir/out"
    if out="$(javac -d "$dir/out" --module-source-path "$dir/src" ${mp:+--module-path "$mp"} --module "$modules" 2>&1)"; then
        ok "compila ($modules)"
    else
        fail "compila" "$out"; return 1
    fi
}

# describe <module-path> <módulo>: muestra el descriptor de un módulo compilado
describe() { java -p "$1" --describe-module "$2" 2>&1; }

has() {   # has <descripción> <texto> <qué se comprueba>
    if grep -qE -- "$2" <<<"$1"; then ok "$3"; else fail "$3"; fi
}
lacks() {
    if grep -qE -- "$2" <<<"$1"; then fail "$3"; else ok "$3"; fi
}

runs() {  # runs <qué se comprueba> <entrada> <comando...>
    local desc="$1" input="$2" out; shift 2
    if out="$(echo "$input" | "$@" 2>&1)"; then ok "$desc"; LAST_OUTPUT="$out"; else fail "$desc" "$out"; LAST_OUTPUT=""; return 1; fi
}

ej1() {
    local d=ejercicio-1-primeros-modulos
    compile $d || return
    local model app
    model="$(describe $d/out com.biblioteca.model)"; app="$(describe $d/out com.biblioteca.app)"
    has   "$model" '^exports com\.biblioteca\.model$'      "com.biblioteca.model exporta su paquete"
    has   "$app"   '^requires com\.biblioteca\.model'      "com.biblioteca.app requiere com.biblioteca.model"
    runs  "la aplicación arranca y termina sin errores" "" java -p $d/out -m com.biblioteca.app/com.biblioteca.app.Main
}

ej2() {
    local d=ejercicio-2-dependencias-encapsulacion
    compile $d || return
    local service app
    service="$(describe $d/out com.biblioteca.service)"; app="$(describe $d/out com.biblioteca.app)"
    has   "$service" '^exports com\.biblioteca\.service$'                 "service exporta com.biblioteca.service"
    lacks "$service" '^exports com\.biblioteca\.service\.internal'        "service NO exporta el paquete internal"
    has   "$service" '^contains com\.biblioteca\.service\.internal$'      "PriceCalculator sigue dentro de service (paquete internal)"
    has   "$service" '^requires com\.biblioteca\.model transitive'        "service requiere model con transitive"
    has   "$app"     '^requires com\.biblioteca\.service'                 "app requiere service"
    lacks "$app"     '^requires com\.biblioteca\.model'                   "app ya no necesita requires com.biblioteca.model"
    runs  "la aplicación arranca y termina sin errores (sin TODO pendientes)" "" java -p $d/out -m com.biblioteca.app/com.biblioteca.app.Main
}

ej3() {
    local d=ejercicio-3-compilar-empaquetar
    runs "comandos.sh se ejecuta sin errores" "" "$d/comandos.sh" || return
    local n; n="$(ls $d/mods/*.jar 2>/dev/null | wc -l | tr -d ' ')"
    [ "$n" -ge 3 ] && ok "hay un JAR por módulo en mods/ ($n)" || fail "hay un JAR por módulo en mods/ (encontrados: $n)"
    runs "java -p mods -m com.biblioteca.app (sin indicar la clase principal)" "" java -p $d/mods -m com.biblioteca.app
    if [ -x $d/runtime/bin/biblioteca ]; then
        ok "existe el lanzador runtime/bin/biblioteca"
        runs "el runtime de jlink ejecuta la aplicación" "" $d/runtime/bin/biblioteca
    else
        fail "existe el lanzador runtime/bin/biblioteca"
    fi
}

ej4() {
    local d=ejercicio-4-servicios
    compile $d || return
    local export csv json app
    export="$(describe $d/out com.biblioteca.export)"; app="$(describe $d/out com.biblioteca.app)"
    csv="$(describe $d/out com.biblioteca.export.csv)"; json="$(describe $d/out com.biblioteca.export.json)"
    has   "$export" '^exports com\.biblioteca\.export$'                            "export exporta la interfaz del servicio"
    has   "$csv"    '^provides com\.biblioteca\.export\.BookExporter with '        "export.csv se registra como proveedor (provides … with)"
    has   "$json"   '^provides com\.biblioteca\.export\.BookExporter with '        "export.json se registra como proveedor (provides … with)"
    lacks "$csv$json" '^exports '                                                  "los proveedores no exportan sus paquetes"
    has   "$app"    '^uses com\.biblioteca\.export\.BookExporter$'                 "app declara uses BookExporter"
    lacks "$app"    '^requires com\.biblioteca\.export\.(csv|json)'                "app NO requiere ningún proveedor"
    runs  "la aplicación funciona eligiendo json" "json" java -p $d/out -m com.biblioteca.app/com.biblioteca.app.Main || return
    grep -q '{' <<<"$LAST_OUTPUT" && ok "la salida incluye JSON" || fail "la salida incluye JSON"
    select_format $d
    # sin el módulo json (sin recompilar): la aplicación tiene que seguir funcionando
    local tmp="$d/out-sin-json"; rm -rf "$tmp"; cp -R $d/out "$tmp"; rm -rf "$tmp/com.biblioteca.export.json"
    runs  "sin el módulo json la aplicación sigue arrancando" "json" java -p "$tmp" -m com.biblioteca.app/com.biblioteca.app.Main
    rm -rf "$tmp"
}

# select_format <dir>: el formato elegido decide el exportador.
# Si Main lista antes todos los exportadores, esa parte sale igual con cualquier entrada,
# así que comparamos salidas: elegir un formato añade su exportación; uno desconocido, nada.
# ponytail: "añade una exportación" = más de 50 caracteres extra; 5 libros exportados siempre lo superan
select_format() {
    local d="$1" app="com.biblioteca.app/com.biblioteca.app.Main" out_csv out_json out_xml
    out_csv="$(echo csv | java -p $d/out -m $app 2>&1)"
    out_json="$(echo json | java -p $d/out -m $app 2>&1)"
    out_xml="$(echo xml | java -p $d/out -m $app 2>&1)"
    local base=${#out_xml}

    if [ "$out_csv" != "$out_json" ] && [ $(( ${#out_csv} - base )) -gt 50 ] && [ $(( ${#out_json} - base )) -gt 50 ]; then
        ok "csv y json dan exportaciones distintas"
    else
        fail "csv y json dan exportaciones distintas" "¿Se usa el formato introducido para elegir el exportador?"
    fi
    for input in "" s j; do
        local out label="${input:-(vacío)}"
        out="$(echo "$input" | java -p $d/out -m $app 2>&1)"
        if [ $(( ${#out} - base )) -gt 50 ]; then
            fail "el formato «$label» no exporta nada (como un formato desconocido)" \
                 "Has elegido un exportador cuyo nombre solo contiene «$input». Compara el nombre completo (equals / equalsIgnoreCase)."
        else
            ok "el formato «$label» no exporta nada (como un formato desconocido)"
        fi
    done
}

ej5() {
    local d=ejercicio-5-migracion
    compile $d $d/inicio/lib || return
    local csv app
    csv="$(describe $d/out:$d/inicio/lib com.biblioteca.export.csv)"; app="$(describe $d/out:$d/inicio/lib com.biblioteca.app)"
    for m in model service export export.csv export.json app; do
        [ -d "$d/out/com.biblioteca.$m" ] && ok "existe el módulo com.biblioteca.$m" || fail "existe el módulo com.biblioteca.$m"
    done
    has   "$csv" '^requires csvlite'                                     "export.csv requiere la librería como módulo automático"
    has   "$csv" '^provides com\.biblioteca\.export\.BookExporter with ' "CsvExporter se registra con provides … with"
    has   "$app" '^uses com\.biblioteca\.export\.BookExporter$'          "app declara uses BookExporter"
    runs  "la versión modular exporta en CSV" "csv" java -p $d/out:$d/inicio/lib -m com.biblioteca.app/com.biblioteca.app.Main || return
    grep -q ';' <<<"$LAST_OUTPUT" && ok "la salida incluye CSV" || fail "la salida incluye CSV"
}

java -version 2>&1 | head -1
for n in "${@:-1 2 3 4 5}"; do
    for i in $n; do
        echo; echo "== Ejercicio $i"
        cd "$ROOT"; "ej$i"
        find "$ROOT"/ejercicio-* -maxdepth 1 -type d \( -name out -o -name mods -o -name runtime \) -prune -exec rm -rf {} +
    done
done

echo
echo "$passes comprobaciones correctas, $fails fallidas."
[ "$fails" -eq 0 ]
