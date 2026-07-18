# Lesson 09 -- Error Handling

# begin/rescue/ensure -- Ruby's try/catch/finally equivalent
def divide(a, b)
  a / b
rescue ZeroDivisionError => e
  puts "caught inline (method-level rescue): #{e.message}"
  nil
end
puts divide(10, 2)
puts divide(10, 0).inspect

def divide_block(a, b)
  result = begin
             a / b
           rescue ZeroDivisionError => e
             puts "caught in begin/rescue block: #{e.class}"
             nil
           ensure
             puts "ensure always runs"
           end
  result
end
puts divide_block(9, 3).inspect
puts divide_block(9, 0).inspect

# Custom exception classes -- subclass StandardError (NOT Exception directly;
# Exception's other direct descendants include things like SystemExit/
# NoMemoryError that generic rescue clauses should not blanket-catch).
class InsufficientFundsError < StandardError
  attr_reader :shortfall

  def initialize(shortfall)
    @shortfall = shortfall
    super("insufficient funds, short by #{shortfall}")
  end
end

def withdraw(balance, amount)
  raise InsufficientFundsError, amount - balance if amount > balance
  balance - amount
end

begin
  withdraw(50, 75)
rescue InsufficientFundsError => e
  puts "caught: #{e.message} (shortfall=#{e.shortfall})"
end

# Multiple rescue clauses, most specific first
def risky(mode)
  case mode
  when :type  then raise TypeError, "bad type"
  when :arg   then raise ArgumentError, "bad argument"
  else raise "generic error"
  end
end

[:type, :arg, :other].each do |mode|
  begin
    risky(mode)
  rescue TypeError => e
    puts "TypeError: #{e.message}"
  rescue ArgumentError => e
    puts "ArgumentError: #{e.message}"
  rescue StandardError => e
    puts "StandardError: #{e.message}"
  end
end

# retry -- re-runs the begin block from the top, genuinely distinctive vs.
# most languages' error handling (no built-in "retry this block" keyword).
attempts = 0
begin
  attempts += 1
  raise "transient failure" if attempts < 3
  puts "succeeded after #{attempts} attempts"
rescue RuntimeError
  retry if attempts < 3
end
