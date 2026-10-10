package com.biblioteca.service.internal;

import com.biblioteca.model.Book;

// Clase pública, pero solo debe poder usarla el propio módulo com.biblioteca.service.
public class PriceCalculator {
    private static final double VAT = 0.04; // IVA superreducido de los libros

    public static double withVat(Book book) {
        return book.getPrice() * (1 + VAT);
    }
}
