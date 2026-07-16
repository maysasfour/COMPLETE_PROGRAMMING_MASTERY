package com.example.tdd;

public class PasswordStrengthValidator {
    public boolean isStrong(String password) {
        return password.length() >= 8
                && password.chars().anyMatch(Character::isDigit)
                && password.chars().anyMatch(Character::isUpperCase);
    }
}
