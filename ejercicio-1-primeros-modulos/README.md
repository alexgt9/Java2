# Ejercicio 1 · Primeros módulos

Diapositivas 9–13.

## Enunciado

En `inicio/` tienes la clase `Book` y un `Main` del módulo 1, sin paquetes y sin módulos. En `src/` tienes la estructura de los dos módulos, con sus `module-info.java` a medio hacer.

1. Completa el módulo `com.biblioteca.model`:
   - Mueve la clase `Book` a `src/com.biblioteca.model/com/biblioteca/model/Book.java`, en el paquete `com.biblioteca.model`.
   - Completa su `module-info.java` exportando ese paquete.
2. Completa el módulo `com.biblioteca.app`:
   - Mueve `Main` a `src/com.biblioteca.app/com/biblioteca/app/Main.java`, en el paquete `com.biblioteca.app`, para que cree varios libros y los muestre por pantalla.
   - ¿Qué falta en el `module-info.java` de app para que compile?

```
src/
├── com.biblioteca.model/
│   ├── module-info.java
│   └── com/biblioteca/model/Book.java
└── com.biblioteca.app/
    ├── module-info.java
    └── com/biblioteca/app/Main.java
```

## Comprobar

```bash
./ejecutar.sh 1
./comprobar.sh 1
```

Es lo mismo que hacer a mano, desde esta carpeta:

```bash
javac -d out --module-source-path src --module com.biblioteca.model,com.biblioteca.app
java --module-path out --module com.biblioteca.app/com.biblioteca.app.Main
```

## Pistas

- `module-info.java` va en la raíz de cada módulo, **no** dentro de la carpeta de un paquete.
- Si ves `package com.biblioteca.model is not visible`, falta una línea en el `module-info.java` de uno de los dos módulos. ¿En cuál?
- Al mover las clases a un paquete, `Main` tendrá que importar `Book`.
