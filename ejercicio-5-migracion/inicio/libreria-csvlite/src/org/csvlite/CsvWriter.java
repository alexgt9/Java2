package org.csvlite;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Librería "externa" mínima para escribir CSV. Se distribuye como un JAR clásico:
 * sin module-info.class y sin Automatic-Module-Name en el MANIFEST.
 */
public class CsvWriter {
    private final char separator;

    public CsvWriter(char separator) {
        this.separator = separator;
    }

    public String row(List<String> values) {
        return values.stream().map(this::escape).collect(Collectors.joining(String.valueOf(separator)));
    }

    private String escape(String value) {
        boolean needsQuotes = value.indexOf(separator) >= 0 || value.contains("\"") || value.contains("\n");
        return needsQuotes ? "\"" + value.replace("\"", "\"\"") + "\"" : value;
    }
}
