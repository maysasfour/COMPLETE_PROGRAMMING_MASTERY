# Lesson 04 -- Operators
# Ruby's arithmetic/comparison operators are NOT special syntax at all --
# they are ordinary method calls. `a + b` is really `a.+(b)` under the hood,
# which means a class can override `+`, `-`, `==`, etc. simply by defining
# a method with that operator's name.

class Money
  attr_reader :cents

  def initialize(cents)
    @cents = cents
  end

  def +(other)
    Money.new(cents + other.cents)
  end

  def to_s
    format("$%.2f", cents / 100.0)
  end

  # <=> is the "spaceship operator": returns -1, 0, or 1 (or nil if
  # not comparable). Defining it plus `include Comparable` gives a class
  # <, <=, ==, >, >=, and between? FOR FREE -- one method, six behaviors.
  include Comparable
  def <=>(other)
    cents <=> other.cents
  end
end

a = Money.new(500)   # $5.00
b = Money.new(250)   # $2.50
puts "a + b = #{a + b}"           # uses our overloaded +
puts "a.+(b) explicit call = #{a.+(b)}"   # proves + really is a method call
puts "a > b?  #{a > b}"            # from Comparable, built on our <=>
puts "a == Money.new(500)? #{a == Money.new(500)}"
puts [b, a].sort.map(&:to_s).inspect   # sort uses <=> too

# Spaceship on plain built-ins:
puts (1 <=> 2)   # -1
puts (2 <=> 2)   #  0
puts (3 <=> 2)   #  1

# Ruby has no ++ or -- operators at all (a genuine, deliberate omission).
n = 5
n += 1
puts n

# Integer division vs float division, and the safe-navigation operator:
puts 7 / 2          # 3 (integer division)
puts 7 / 2.0         # 3.5
user = nil
puts user&.name.inspect   # &. short-circuits to nil instead of raising NoMethodError
