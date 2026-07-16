import kotlin.test.Test
import kotlin.test.BeforeTest
import kotlin.test.assertEquals
import kotlin.test.assertTrue
import kotlin.test.assertFalse
import kotlin.test.assertFailsWith

class CalculatorTest {
    private lateinit var calc: Calculator // lateinit: a non-null property initialized later,
                                             // not at declaration -- Kotlin's answer to "I know
                                             // this will be set before use, but not right here"

    @BeforeTest
    fun setUp() {
        calc = Calculator() // runs before EVERY test method -- fresh instance each time
    }

    @Test
    fun addsTwoPositiveNumbers() {
        assertEquals(5, calc.add(2, 3))
    }

    @Test
    fun addsNegativeNumbers() {
        assertEquals(-5, calc.add(-2, -3))
    }

    // Table-driven style: a plain list of Triple(a, b, expected), looped over manually --
    // Kotlin/JUnit5 has @ParameterizedTest too, but a plain loop over data is equally idiomatic
    // and mirrors the array-of-tuples pattern from this repository's Rust course.
    @Test
    fun dividesCorrectly() {
        val cases = listOf(
            Triple(10.0, 2.0, 5.0),
            Triple(9.0, 3.0, 3.0),
            Triple(-6.0, 2.0, -3.0),
        )
        for ((a, b, expected) in cases) {
            assertEquals(expected, calc.divide(a, b), "divide($a, $b) failed")
        }
    }

    @Test
    fun divisionByZeroThrows() {
        val exception = assertFailsWith<IllegalArgumentException> {
            calc.divide(5.0, 0.0)
        }
        assertEquals("division by zero", exception.message)
    }

    @Test
    fun detectsPalindromes() {
        assertTrue(calc.isPalindrome("racecar"))
        assertTrue(calc.isPalindrome("A man a plan a canal Panama"))
        assertFalse(calc.isPalindrome("hello"))
        assertTrue(calc.isPalindrome(""))
    }
}
