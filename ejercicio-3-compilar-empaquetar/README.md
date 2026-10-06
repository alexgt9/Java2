# Ejercicio 3 · Compilar, empaquetar y ejecutar módulos

Diapositivas 21–25. El código no cambia: este ejercicio va de herramientas.

## Antes de empezar

Copia tus módulos del ejercicio 2. Desde la raíz del repositorio:

```bash
cp -R ejercicio-2-dependencias-encapsulacion/src ejercicio-3-compilar-empaquetar/
```

## Enunciado

Escribe en `comandos.sh` los comandos de cada paso (cada paso tiene su `TODO`):

1. Compila los tres módulos con `--module-source-path`.
2. Empaqueta cada módulo como JAR modular en una carpeta `mods`.
3. Ejecuta la aplicación solo con `java -p mods -m com.biblioteca.app`, sin indicar la clase principal.
4. Crea un runtime con `jlink` en la carpeta `runtime`, con un lanzador llamado `biblioteca`. Compara su tamaño con el del JDK completo.

Y además, a mano:

5. Quita `biblioteca-model.jar` (o como hayas llamado al JAR de model) de `mods` y vuelve a ejecutar. ¿Cuándo falla: al arrancar o al usar la clase `Book`?

## Comprobar

```bash
./ejercicio-3-compilar-empaquetar/comandos.sh
./comprobar.sh 3
```

## Pistas

- `jar --create --file <jar> --main-class <clase> -C <carpeta> .` guarda la clase principal en el JAR.
- `jar --describe-module --file <jar>` muestra qué requiere y exporta un JAR modular.
- `java -p mods --show-module-resolution -m com.biblioteca.app` muestra cómo la JVM resuelve el grafo de módulos.
- `jlink --module-path … --add-modules … --launcher <nombre>=<módulo> --output runtime`
- Para que el runtime ocupe menos: `--strip-debug --no-header-files --no-man-pages`.
- El tamaño de una carpeta: `du -sh runtime`.
