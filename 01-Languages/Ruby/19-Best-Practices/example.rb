# Lesson 19 -- Best Practices
# Ruby style: snake_case for methods/variables, CamelCase for classes/modules,
# SCREAMING_SNAKE_CASE for constants, `?` suffix for predicate (boolean-ish)
# methods, `!` suffix for "dangerous"/mutating counterparts of a safer method.

MAX_RETRIES = 3          # constant: SCREAMING_SNAKE_CASE

class UserAccount        # class: CamelCase
  attr_reader :balance

  def initialize(balance)
    @balance = balance    # variable/method: snake_case
  end

  def active?             # predicate method: ends in ?, returns true/false-ish
    @balance > 0
  end

  def withdraw(amount)     # safe: raises on invalid state, does NOT silently clamp
    raise ArgumentError, "amount must be positive" unless amount.positive?
    raise "insufficient funds" if amount > @balance
    @balance -= amount
  end

  def withdraw!(amount)     # "bang" variant: allows overdraft, a deliberately
    @balance -= amount        # more dangerous operation than the safe version above
  end
end

acct = UserAccount.new(100)
puts "active? #{acct.active?}"
acct.withdraw(30)
puts "balance after safe withdraw: #{acct.balance}"
begin
  acct.withdraw(1000)
rescue RuntimeError => e
  puts "safe withdraw correctly refused: #{e.message}"
end
acct.withdraw!(1000)   # the bang version allows this -- by NAMING CONVENTION,
                          # not language enforcement, signaling "this one is riskier"
puts "balance after withdraw! (allowed overdraft): #{acct.balance}"

# --- A real anti-pattern/fix pair: overusing method_missing (Lesson 11) -----
# BEFORE: using method_missing for something that could just be a plain Hash
# lookup -- adds indirection, breaks `respond_to?` if forgotten (Lesson 11),
# and is measurably slower than a direct Hash#[] call for every single access.
class SlowConfigBefore
  def initialize(data)
    @data = data
  end

  def method_missing(name, *args)
    @data.key?(name) ? @data[name] : super
  end

  def respond_to_missing?(name, include_private = false)
    @data.key?(name) || super
  end
end

# AFTER: a plain Hash (or Struct/OpenStruct if dynamic access is genuinely
# needed) with an explicit reader is simpler, faster, and every tool
# (autocomplete, `respond_to?`, static analysis) understands it immediately
# with no metaprogramming indirection at all.
class FastConfigAfter
  def initialize(data)
    @data = data
  end

  def [](key)
    @data.fetch(key)
  end
end

before = SlowConfigBefore.new(host: "localhost", port: 5432)
after = FastConfigAfter.new(host: "localhost", port: 5432)

N = 200_000
start = Time.now
N.times { before.host }
before_time = Time.now - start

start = Time.now
N.times { after[:host] }
after_time = Time.now - start

puts "method_missing lookups (#{N}x): #{before_time.round(4)}s"
puts "plain Hash lookups (#{N}x):      #{after_time.round(4)}s"
puts "method_missing was #{(before_time / after_time).round(1)}x slower for the identical #{N} lookups"
