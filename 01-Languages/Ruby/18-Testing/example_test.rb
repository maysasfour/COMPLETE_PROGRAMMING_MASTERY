# Lesson 18 -- Testing (Minitest, ships with Ruby's standard library -- no gem install needed)
require "minitest/autorun"

class Calculator
  def add(a, b) = a + b
  def divide(a, b)
    raise ZeroDivisionError, "cannot divide by zero" if b.zero?
    a / b
  end
end

class CalculatorTest < Minitest::Test
  def setup
    @calc = Calculator.new    # runs fresh before EVERY test method
  end

  def test_add
    assert_equal 5, @calc.add(2, 3)
  end

  def test_add_negative
    assert_equal(-1, @calc.add(2, -3))
  end

  def test_divide
    assert_equal 4, @calc.divide(8, 2)
  end

  def test_divide_by_zero_raises
    assert_raises(ZeroDivisionError) { @calc.divide(1, 0) }
  end

  # Minitest's built-in "spec-ish" style still lets refutations read clearly.
  def test_add_is_commutative
    refute_equal @calc.add(1, 2), @calc.add(1, 3)
  end
end
