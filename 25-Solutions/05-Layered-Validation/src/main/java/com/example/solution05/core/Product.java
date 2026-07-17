package com.example.solution05.core;

public class Product {
    public final String name;
    public final double price;
    public Product(String name, double price) { this.name = name; this.price = price; }
    @Override public String toString() { return name + " ($" + price + ")"; }
}
