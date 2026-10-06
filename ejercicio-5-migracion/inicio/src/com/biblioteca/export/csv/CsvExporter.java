package com.biblioteca.export.csv;

import com.biblioteca.export.BookExporter;
import com.biblioteca.model.Book;
import org.csvlite.CsvWriter;

import java.util.List;
import java.util.stream.Collectors;

public class CsvExporter implements BookExporter {
    private final CsvWriter writer = new CsvWriter(';');

    @Override
    public String name() {
        return "csv";
    }

    @Override
    public String export(List<Book> books) {
        return books.stream()
                .map(b -> writer.row(List.of(b.getTitle(), b.getAuthor(), String.valueOf(b.getYear()),
                        String.valueOf(b.getPrice()))))
                .collect(Collectors.joining("\n", "titulo;autor;año;precio\n", ""));
    }
}
