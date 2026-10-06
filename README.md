# Java Programming II · Módulo 2: Servicios y migración a una programación modular

Ejercicios del módulo 2. Acompañan a las diapositivas `Modulo2_ES-ProgramacionModular.pptx`.

Todos los ejercicios trabajan sobre el mismo ejemplo: la **biblioteca** del módulo 1, que vamos dividiendo en módulos.

| Ejercicio | Diapositiva | Qué se practica | Punto de partida |
|---|---|---|---|
| [1 · Primeros módulos](ejercicio-1-primeros-modulos/) | 13 | `module-info.java`, `requires`, `exports` | Código del módulo 1 en `inicio/` |
| [2 · Dependencias y encapsulación](ejercicio-2-dependencias-encapsulacion/) | 20 | Paquetes no exportados, `requires transitive` | Tu ejercicio 1 |
| [3 · Compilar y empaquetar](ejercicio-3-compilar-empaquetar/) | 25 | Module path, JAR modulares, `jlink` | Tu ejercicio 2 |
| [4 · Servicios](ejercicio-4-servicios/) | 33 | `uses`, `provides … with`, `ServiceLoader` | Tu ejercicio 3 |
| [5 · Migración](ejercicio-5-migracion/) | 42 | Classpath → módulos, módulos automáticos, `jdeps` | Aplicación no modular en `inicio/` |

Cada carpeta tiene un `README.md` con el enunciado y las pistas, y los ficheros de partida. Donde hay que escribir algo verás un `TODO`.

## Cómo trabajar

Escribe tu código en la carpeta `src/` de cada ejercicio, con una carpeta por módulo:

```
ejercicio-N-…/src/
├── com.biblioteca.model/
│   ├── module-info.java
│   └── com/biblioteca/model/…
└── com.biblioteca.app/
    ├── module-info.java
    └── com/biblioteca/app/Main.java
```

Desde la raíz del repositorio:

```bash
./ejecutar.sh 1          # compila y ejecuta el ejercicio 1
./ejecutar.sh 4 json     # el ejercicio 4, escribiendo "json" cuando pida el formato
./comprobar.sh 1         # comprueba tu solución del ejercicio 1
./comprobar.sh           # comprueba todos
```

`comprobar.sh` compila tu código y revisa cómo están declarados tus módulos (qué exporta, requiere, ofrece y usa cada uno). Si algo falla, te dice qué comprobación no se cumple. Lee también el mensaje completo del compilador: casi siempre dice exactamente qué falta.

Los ejercicios 2, 3 y 4 continúan el anterior: empieza copiando tu `src/` del ejercicio previo, como se explica en cada README.

## IntelliJ IDEA

Abre **cada carpeta de ejercicio por separado** (*File → Open → `ejercicio-N-…`*), no la raíz del repositorio. Cada ejercicio tiene su propio proyecto de IntelliJ, con un módulo de IntelliJ por módulo de Java, y una configuración de ejecución **Main** lista para usar.

Al abrirlo por primera vez, si IntelliJ te pide el JDK, elige uno de la versión 17 o superior.

En los ejercicios 2, 3 y 4, algunos módulos (model, app…) aparecen vacíos hasta que copias tu `src/` del ejercicio anterior.

## Requisitos

- **JDK 17 o superior** (recomendado JDK 21). Comprueba la versión con `java -version`.
- Una terminal **bash**: macOS, Linux, Git Bash o WSL en Windows.

No usamos Maven ni Gradle a propósito: queremos ver qué hace realmente el module path.

## Windows (PowerShell o cmd)

Los scripts son de bash. Si no tienes Git Bash ni WSL, puedes escribir los comandos a mano con estos cambios:

- Indica los módulos por nombre: `javac -d out --module-source-path src --module com.biblioteca.model,com.biblioteca.app`
- La barra `\` del final de línea no existe: escribe el comando en una sola línea (o usa `` ` `` en PowerShell).
- En el classpath (solo en el ejercicio 5), el separador es `;` en lugar de `:`.

## Soluciones

Las soluciones están en la rama `solutions`. Intenta resolver cada ejercicio antes de mirarlas.
