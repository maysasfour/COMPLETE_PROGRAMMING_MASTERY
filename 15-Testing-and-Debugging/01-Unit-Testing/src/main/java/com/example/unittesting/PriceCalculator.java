package com.example.unittesting;

public class PriceCalculator {
    // discountPercent is meant as a whole-number percentage (20 means 20%).
    public double applyDiscount(double price, double discountPercent) {
        return price - (price * discountPercent / 100.0);
    }
}
