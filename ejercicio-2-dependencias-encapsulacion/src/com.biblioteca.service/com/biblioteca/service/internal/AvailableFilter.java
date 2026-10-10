package com.biblioteca.service.internal;

import com.biblioteca.model.Book;

public class AvailableFilter implements BookFilter {
    public boolean test(Book book) {
        return book.isAvailable();
    }
}
