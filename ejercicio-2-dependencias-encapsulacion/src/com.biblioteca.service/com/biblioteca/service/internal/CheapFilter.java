package com.biblioteca.service.internal;

import com.biblioteca.model.Book;

public class CheapFilter implements BookFilter {
    public boolean test(Book book) {
        return book.getPrice() < 12;
    }
}
