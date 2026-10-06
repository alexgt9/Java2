package com.biblioteca.model;

public class Book {
    private final String title;
    private final String author;
    private final int year;
    private final double price;
    private final boolean available;

    public Book(String title, String author, int year, double price, boolean available) {
        this.title = title;
        this.author = author;
        this.year = year;
        this.price = price;
        this.available = available;
    }

    public String getTitle() { return title; }
    public String getAuthor() { return author; }
    public int getYear() { return year; }
    public double getPrice() { return price; }
    public boolean isAvailable() { return available; }

    @Override
    public String toString() {
        return String.format("%s (%s, %d) - %.2f €%s", title, author, year, price, available ? "" : " [prestado]");
    }
}
