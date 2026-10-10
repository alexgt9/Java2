package com.biblioteca.app;

// Punto de partida del ejercicio 1: código del módulo 1, sin paquete y sin módulo.
import com.biblioteca.model.Book;
import com.biblioteca.service.BookService;

import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<Book> books = List.of(
                new Book("El Hobbit", "Tolkien", 1937, 10.50, true),
                new Book("El Señor de los Anillos", "Tolkien", 1954, 24.90, false),
                new Book("Dune", "Frank Herbert", 1965, 14.00, true),
                new Book("Cien años de soledad", "García Márquez", 1967, 11.95, true),
                new Book("Orgullo y prejuicio", "Jane Austen", 1813, 8.50, true));

        List<Book> cheapBooks = new BookService(books).cheaperThan(12.00);

        cheapBooks.forEach(System.out::println);
    }
}
