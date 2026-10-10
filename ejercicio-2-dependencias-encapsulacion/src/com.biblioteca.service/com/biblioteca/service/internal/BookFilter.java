package com.biblioteca.service.internal;

import com.biblioteca.model.Book;

public interface BookFilter {
    boolean test(Book book);
}

