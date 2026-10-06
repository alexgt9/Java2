package com.biblioteca.export.json;

import com.biblioteca.export.BookExporter;
import com.biblioteca.model.Book;

import java.util.List;
import java.util.stream.Collectors;

public class JsonExporter implements BookExporter {
    @Override
    public String name() {
        return "json";
    }

    @Override
    public String export(List<Book> books) {
        return books.stream()
                .map(b -> String.format("  {\"title\": \"%s\", \"author\": \"%s\", \"year\": %d}",
                        quote(b.getTitle()), quote(b.getAuthor()), b.getYear()))
                .collect(Collectors.joining(",\n", "[\n", "\n]"));
    }

    private static String quote(String text) {
        return text.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
