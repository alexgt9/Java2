# Ejercicio 5 · Migración a una aplicación modular

Diapositivas 34–42.

## Punto de partida

`inicio/` es la biblioteca completa **sin módulos**: todo en un único árbol de fuentes y ejecutada con el classpath.

```
inicio/
├── src/com/biblioteca/...        # model, service, service/internal, export, export/csv, export/json, app
├── src/META-INF/services/...     # registro de servicios al estilo del classpath
├── lib/csvlite-1.0.jar           # librería externa (sin module-info)
├── libreria-csvlite/             # código de esa librería, por si quieres verlo
├── run.sh                        # compila y ejecuta con el classpath
└── analizar.sh                   # análisis con jdeps
```

`csvlite` hace el papel de una librería de terceros que todavía no es modular: la usa `CsvExporter`.

## Enunciado

1. Ejecuta la versión actual con `inicio/run.sh` y comprueba que funciona.
2. Analízala con `jdeps` (o con `inicio/analizar.sh`) y anota qué dependencias tiene cada paquete.
3. Migra a módulos en una carpeta nueva, `ejercicio-5-migracion/src/`, sin tocar `inicio/`:
   - Bottom-up para nuestro código: `com.biblioteca.model`, `com.biblioteca.service`, `com.biblioteca.export`, `com.biblioteca.export.csv`, `com.biblioteca.export.json` y `com.biblioteca.app`.
   - La librería externa, como módulo automático (déjala en `inicio/lib`).
4. Comprueba que los exportadores siguen funcionando como servicios.
5. Intenta crear un runtime con `jlink`. ¿Funciona? ¿Por qué?

## Comprobar

```bash
./ejecutar.sh 5 csv
./comprobar.sh 5
```

Para compilar a mano, la librería tiene que estar en el module path:

```bash
javac -d out --module-source-path src --module-path inicio/lib --module <módulos separados por comas>
```

## Si lo ejecutas desde IntelliJ

IntelliJ solo pone en el module path el módulo que ejecutas y sus dependencias. Para la versión modular necesitas dos cosas en *File → Project Structure → Modules*:

1. **Los proveedores, como dependencias de Runtime de app.** En `com.biblioteca.app` → *Dependencies* → **+** → *Module Dependency…*, elige `com.biblioteca.export.csv` y `com.biblioteca.export.json` y pon su **Scope** en **Runtime**. Si no, `ServiceLoader` no encuentra ningún exportador (es lo mismo que en el ejercicio 4).
2. **La librería, como dependencia de `com.biblioteca.export.csv`.** En ese módulo → *Dependencies* → **+** → *JARs or Directories…*, elige `inicio/lib/csvlite-1.0.jar`. Es el equivalente a `--module-path inicio/lib` en la terminal.

## Pistas

- La salida de `jdeps -verbose:package` es casi el diagrama de módulos: cada flecha entre paquetes de módulos distintos será un `requires`.
- ¿Cómo se llamará `csvlite-1.0.jar` como módulo automático? `jar --describe-module --file inicio/lib/csvlite-1.0.jar` te lo dice.
- ¿Qué sustituye al fichero `META-INF/services/...` en un módulo con nombre?
- Recuerda lo que hicimos con `internal` en el ejercicio 2.
