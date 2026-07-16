// MathHelpersTests.cs - xUnit tests for MathHelpers.

public class MathHelpersTests {
    [Fact]
    public void Add_SumsTwoPositiveNumbers() {
        Assert.Equal(5, MathHelpers.Add(2, 3));
    }

    [Fact]
    public void Add_HandlesNegativeNumbers() {
        Assert.Equal(-5, MathHelpers.Add(-2, -3));
    }

    [Fact]
    public void Divide_DividesCorrectly() {
        Assert.Equal(5, MathHelpers.Divide(10, 2));
    }

    [Fact]
    public void Divide_ThrowsOnDivisionByZero() {
        var ex = Assert.Throws<ArgumentException>(() => MathHelpers.Divide(10, 0));
        Assert.Contains("Cannot divide by zero", ex.Message);
    }

    [Theory]
    [InlineData(1, 1, 2)]
    [InlineData(0, 0, 0)]
    [InlineData(-1, 1, 0)]
    public void Add_ParameterizedCases(int a, int b, int expected) {
        Assert.Equal(expected, MathHelpers.Add(a, b));
    }
}
