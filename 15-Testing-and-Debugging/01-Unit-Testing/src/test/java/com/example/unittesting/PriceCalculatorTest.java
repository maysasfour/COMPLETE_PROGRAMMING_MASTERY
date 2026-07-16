package com.example.unittesting;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

// A unit test exercises ONE unit of behavior (here, PriceCalculator.applyDiscount)
// in complete isolation -- no database, no network, no other real dependency.
// This test is what actually CAUGHT the real bug in PriceCalculator, before this
// lesson's README was written -- run it yourself with `mvn test` to see it live.
class PriceCalculatorTest {

    private final PriceCalculator calculator = new PriceCalculator();

    @Test
    void twentyPercentDiscountOnHundredDollarsIsEighty() {
        double result = calculator.applyDiscount(100.0, 20.0);
        assertEquals(80.0, result, 0.001, "20% off $100 should be $80");
    }

    @Test
    void zeroPercentDiscountLeavesPriceUnchanged() {
        double result = calculator.applyDiscount(50.0, 0.0);
        assertEquals(50.0, result, 0.001, "0% off should leave the price unchanged");
    }

    @Test
    void hundredPercentDiscountMakesItFree() {
        double result = calculator.applyDiscount(75.0, 100.0);
        assertEquals(0.0, result, 0.001, "100% off should make the price $0");
    }
}
