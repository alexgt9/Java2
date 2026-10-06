package com.biblioteca.service.internal;

import com.biblioteca.model.Book;

// Pensada como clase interna del servicio... pero en el classpath cualquiera puede usarla.
// Al migrar, ¿cómo conseguimos que solo la use com.biblioteca.service?
public class PriceCalculator {
    private static final double VAT = 0.04; // IVA superreducido de los libros

    public static double withVat(Book book) {
        return book.getPrice() * (1 + VAT);
    }
}
