// test_mathutils.cpp - Catch2 tests for mathutils.
#define CATCH_CONFIG_MAIN
#include "catch_amalgamated.hpp"
#include "mathutils.hpp"

TEST_CASE("add sums two positive numbers", "[math]") {
    REQUIRE(add(2, 3) == 5);
}

TEST_CASE("add handles negative numbers", "[math]") {
    REQUIRE(add(-2, -3) == -5);
}

TEST_CASE("divideValues divides correctly", "[math]") {
    REQUIRE(divideValues(10, 2) == 5.0);
}

TEST_CASE("divideValues throws on division by zero", "[math]") {
    REQUIRE_THROWS_AS(divideValues(10, 0), std::invalid_argument);
}

TEST_CASE("add parameterized cases", "[math]") {
    auto [a, b, expected] = GENERATE(table<int, int, int>({
        {1, 1, 2},
        {0, 0, 0},
        {-1, 1, 0}
    }));
    REQUIRE(add(a, b) == expected);
}
