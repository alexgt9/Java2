package com.biblioteca.export;

import com.biblioteca.model.Book;

import java.util.List;

/** El contrato del servicio: cualquier módulo puede ofrecer un formato de exportación nuevo. */
public interface BookExporter {
    /** Nombre corto del formato, por ejemplo "csv". */
    String name();

    String export(List<Book> books);
}
