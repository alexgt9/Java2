package com.biblioteca.service;

import com.biblioteca.model.Book;

import java.util.List;
import java.util.function.Predicate;

public class BookService {
    private final List<Book> books;

    public BookService(List<Book> books) {
        this.books = List.copyOf(books);
    }

    public List<Book> filter(Predicate<Book> condition) {
        throw new UnsupportedOperationException("TODO");
    }

    public List<Book> available() {
        throw new UnsupportedOperationException("TODO");
    }

    public List<Book> byAuthor(String author) {
        throw new UnsupportedOperationException("TODO");
    }

    /** Libros cuyo precio final (con IVA) es inferior a {@code max}. Usa PriceCalculator. */
    public List<Book> cheaperThan(double max) {
        throw new UnsupportedOperationException("TODO");
    }
}
