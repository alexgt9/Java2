# Ejercicio 4 · Servicios

Diapositivas 26–33.

## Antes de empezar

Copia tus módulos del ejercicio 3 (model, service y app). Desde la raíz del repositorio:

```bash
cp -R ejercicio-3-compilar-empaquetar/src/* ejercicio-4-servicios/src/
```

En `src/` ya tienes los tres módulos nuevos:

- `com.biblioteca.export`, con la interfaz del servicio ya escrita:
  ```java
  public interface BookExporter {
      String name();
      String export(List<Book> books);
  }
  ```
- `com.biblioteca.export.csv` y `com.biblioteca.export.json`, con el esqueleto de `CsvExporter` y `JsonExporter`.

## Enunciado

1. Completa el `module-info.java` de `com.biblioteca.export`.
2. Implementa `CsvExporter` y `JsonExporter` y regístralos como proveedores del servicio en sus `module-info.java`.
3. En `Main`, lista todos los exportadores disponibles y exporta los libros con cada uno.
4. Pide al usuario un formato y busca el exportador con `stream()`, `filter` y `Optional`. Si no existe, muestra un mensaje.
5. Ejecuta la aplicación sin el módulo JSON. ¿Qué pasa? ¿Ha hecho falta recompilar?

## Comprobar

```bash
./ejecutar.sh 4 json
./comprobar.sh 4
```

`comprobar.sh` también prueba el paso 5: borra el módulo JSON compilado y vuelve a ejecutar la aplicación, que tiene que seguir funcionando.

## Si lo ejecutas desde IntelliJ

El proyecto de IntelliJ de este ejercicio ya está configurado: abre la carpeta `ejercicio-4-servicios` y ejecuta **Main**.

Fíjate en cómo está hecho (*File → Project Structure → Modules → `com.biblioteca.app` → Dependencies*): `com.biblioteca.export.csv` y `com.biblioteca.export.json` aparecen con **Scope: Runtime**. IntelliJ solo pone en el module path el módulo que ejecutas y sus dependencias. Sin esas dos, los proveedores no estarían en el module path y `ServiceLoader` no encontraría ningún exportador.

Con *Runtime*, IntelliJ los incluye al ejecutar, pero app no los ve al compilar: tu `module-info.java` sigue sin `requires` de los proveedores. Con el scope por defecto (*Compile*), app podría importar `CsvExporter`, justo lo que queremos evitar.

Haz la prueba: quita esas dos dependencias y ejecuta. Es el mismo experimento del paso 5: un proveedor que no está en el module path, para la aplicación, no existe.

## Pistas

- La interfaz va en un paquete **exportado**. Las implementaciones, no.
- Proveedor: `provides <interfaz> with <implementación>;`
- Consumidor: `uses <interfaz>;` y `ServiceLoader.load(BookExporter.class)`.
- El módulo app **no** debe tener `requires` de los módulos csv ni json. Si lo necesitas, algo no está bien.
- Si `ServiceLoader` lanza `ServiceConfigurationError`, probablemente falta `uses`. Si no encuentra ningún proveedor, revisa `provides`.
- Para leer el formato: `new Scanner(System.in).nextLine()`.
