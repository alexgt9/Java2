# Ejercicio 2 · Dependencias y encapsulación

Diapositivas 14–20.

## Antes de empezar

Copia tus módulos del ejercicio 1 en esta carpeta. Desde la raíz del repositorio:

```bash
cp -R ejercicio-1-primeros-modulos/src/* ejercicio-2-dependencias-encapsulacion/src/
```

En `src/com.biblioteca.service/` ya tienes el esqueleto del nuevo módulo: `BookService` con los métodos por implementar y `PriceCalculator` en el paquete `internal`.

## Enunciado

1. Completa el módulo `com.biblioteca.service`:
   - Implementa los métodos de `BookService` con los filtrados del módulo 1: disponibles, por autor y por precio. `cheaperThan` debe usar `PriceCalculator` para calcular el precio con IVA.
   - Completa su `module-info.java`. El paquete `com.biblioteca.service.internal` **no** se debe exportar.
2. Haz que `Main` use `BookService` y muestre el resultado de cada filtro.
3. Desde `Main`, intenta importar `PriceCalculator`. ¿Qué error obtienes? ¿Por qué, si la clase es `public`? (Después, quita el `import` para que compile.)
4. Usa `requires transitive` para que el módulo app no tenga que declarar `requires com.biblioteca.model`.

## Comprobar

```bash
./ejecutar.sh 2
./comprobar.sh 2
```

## Pistas

- Se exportan **paquetes**, no clases. Para esconder una clase, ponla en un paquete que no exportes.
- `BookService` devuelve `List<Book>`: quien use el servicio necesita conocer `Book`. ¿Qué módulo debería «regalar» esa dependencia?
- `filter(Predicate<Book>)` se puede reutilizar en los otros tres métodos.
