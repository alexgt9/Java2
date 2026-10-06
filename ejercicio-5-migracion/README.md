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

## Pistas

- La salida de `jdeps -verbose:package` es casi el diagrama de módulos: cada flecha entre paquetes de módulos distintos será un `requires`.
- ¿Cómo se llamará `csvlite-1.0.jar` como módulo automático? `jar --describe-module --file inicio/lib/csvlite-1.0.jar` te lo dice.
- ¿Qué sustituye al fichero `META-INF/services/...` en un módulo con nombre?
- Recuerda lo que hicimos con `internal` en el ejercicio 2.
