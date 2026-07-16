// MathHelpersTest.java - JUnit 5 tests for MathHelpers.

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import static org.junit.jupiter.api.Assertions.*;

public class MathHelpersTest {
    @Test
    void addSumsTwoPositiveNumbers() {
        assertEquals(5, MathHelpers.add(2, 3));
    }

    @Test
    void addHandlesNegativeNumbers() {
        assertEquals(-5, MathHelpers.add(-2, -3));
    }

    @Test
    void divideDividesCorrectly() {
        assertEquals(5.0, MathHelpers.divide(10, 2));
    }

    @Test
    void divideThrowsOnDivisionByZero() {
        Exception ex = assertThrows(ArithmeticException.class, () -> MathHelpers.divide(10, 0));
        assertTrue(ex.getMessage().contains("Cannot divide by zero"));
    }

    @ParameterizedTest
    @CsvSource({"1,1,2", "0,0,0", "-1,1,0"})
    void addParameterizedCases(int a, int b, int expected) {
        assertEquals(expected, MathHelpers.add(a, b));
    }
}
