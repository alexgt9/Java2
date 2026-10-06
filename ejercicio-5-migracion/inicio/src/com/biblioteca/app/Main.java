package com.biblioteca.app;

import com.biblioteca.export.BookExporter;
import com.biblioteca.model.Book;
import com.biblioteca.service.BookService;

import java.util.List;
import java.util.Scanner;
import java.util.ServiceLoader;

public class Main {
    public static void main(String[] args) {
        List<Book> books = new BookService(List.of(
                new Book("El Hobbit", "Tolkien", 1937, 10.50, true),
                new Book("El Señor de los Anillos", "Tolkien", 1954, 24.90, false),
                new Book("Dune", "Frank Herbert", 1965, 14.00, true),
                new Book("Cien años de soledad", "García Márquez", 1967, 11.95, true),
                new Book("Orgullo y prejuicio", "Jane Austen", 1813, 8.50, true)))
                .available();

        ServiceLoader<BookExporter> loader = ServiceLoader.load(BookExporter.class);

        // 1. Listar los exportadores disponibles y usar cada uno
        for (BookExporter exporter : loader) {
            System.out.println("== Formato: " + exporter.name());
            System.out.println(exporter.export(books));
        }

        // 2. Elegir un formato por nombre con streams y Optional (módulo 1)
        System.out.print("\n¿Qué formato quieres? ");
        Scanner scanner = new Scanner(System.in);
        String format = scanner.hasNextLine() ? scanner.nextLine().trim() : "";
        System.out.println();

        loader.stream()
                .map(ServiceLoader.Provider::get)
                .filter(exporter -> exporter.name().equalsIgnoreCase(format))
                .findFirst()
                .ifPresentOrElse(
                        exporter -> System.out.println(exporter.export(books)),
                        () -> System.out.println("Formato no disponible: " + format));
    }
}
