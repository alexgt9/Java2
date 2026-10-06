package com.biblioteca.export.json;

import com.biblioteca.export.BookExporter;
import com.biblioteca.model.Book;

import java.util.List;

public class JsonExporter implements BookExporter {
    @Override
    public String name() {
        return "json";
    }

    @Override
    public String export(List<Book> books) {
        // TODO: devuelve los libros en formato JSON
        throw new UnsupportedOperationException("TODO");
    }
}
