package com.biblioteca.service;

import com.biblioteca.model.Book;
import com.biblioteca.service.internal.PriceCalculator;

import java.util.List;
import java.util.function.Predicate;

public class BookService {
    private final List<Book> books;

    public BookService(List<Book> books) {
        this.books = List.copyOf(books);
    }

    public List<Book> filter(Predicate<Book> condition) {
        return books.stream().filter(condition).toList();
    }

    public List<Book> available() {
        return filter(Book::isAvailable);
    }

    public List<Book> byAuthor(String author) {
        return filter(book -> book.getAuthor().equals(author));
    }

    /** Libros cuyo precio final (con IVA) es inferior a {@code max}. */
    public List<Book> cheaperThan(double max) {
        return filter(book -> PriceCalculator.withVat(book) < max);
    }
}
