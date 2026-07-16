package com.example.tdd;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

// STAGE 3: the final requirement (must contain an uppercase letter) is added the
// same way -- one new failing test first (passwordWithNoUppercaseIsNotStrong),
// plus a final positive test confirming a password satisfying ALL three rules
// is accepted.
class PasswordStrengthValidatorTest {

    private final PasswordStrengthValidator validator = new PasswordStrengthValidator();

    @Test
    void passwordShorterThanEightCharsIsNotStrong() {
        assertFalse(validator.isStrong("abc1A"));
    }

    @Test
    void passwordWithNoDigitIsNotStrong() {
        assertFalse(validator.isStrong("Abcdefgh")); // 8 chars, has uppercase, but NO digit
    }

    @Test
    void passwordWithNoUppercaseIsNotStrong() {
        assertFalse(validator.isStrong("abcdefg1")); // 8 chars, has a digit, but NO uppercase
    }

    @Test
    void passwordSatisfyingAllRulesIsStrong() {
        assertTrue(validator.isStrong("Abcdefg1")); // 8 chars, has a digit, has uppercase
    }
}
