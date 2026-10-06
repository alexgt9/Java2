package com.biblioteca.export.csv;

import com.biblioteca.export.BookExporter;
import com.biblioteca.model.Book;

import java.util.List;

public class CsvExporter implements BookExporter {
    @Override
    public String name() {
        return "csv";
    }

    @Override
    public String export(List<Book> books) {
        // TODO: devuelve los libros en formato CSV
        throw new UnsupportedOperationException("TODO");
    }
}
