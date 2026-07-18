# Lesson 03 -- Variables and Data Types
# Dynamic typing: a variable's type is determined by whatever it currently
# holds, and can change over its lifetime -- no declared type anywhere.
x = 42
puts "#{x} is a #{x.class}"
x = "now a string"
puts "#{x} is a #{x.class}"
x = [1, 2, 3]
puts "#{x} is a #{x.class}"

# nil is Ruby's "nothing here" value -- like Python's None, JS's null.
missing = nil
puts missing.nil?          # true
puts missing.inspect        # "nil" (inspect shows the literal, unlike puts which prints blank)

# Symbols (:name) are a genuinely distinctive Ruby feature: lightweight,
# immutable, interned identifiers -- the SAME symbol literal is always the
# SAME object in memory, unlike two equal-but-distinct String objects.
sym1 = :status
sym2 = :status
str1 = "status"
str2 = "status"
puts "symbols same object?  #{sym1.equal?(sym2)}"   # true  -- interned
puts "strings same object?  #{str1.equal?(str2)}"   # false -- two distinct objects
puts "symbol object_id stable: #{sym1.object_id == sym2.object_id}"

# Symbols are commonly used as cheap, meaningful hash keys:
config = { host: "localhost", port: 5432 }   # shorthand for { :host => ..., :port => ... }
puts config[:host]

# Everything is an object -- even integers and nil have real methods,
# unlike primitive int/bool types in most other languages in this repository.
puts 5.even?
puts (-3).abs
puts nil.to_s.inspect      # ""
puts nil.to_a.inspect      # []

# Multiple assignment and parallel swap, real Ruby idioms:
p, q = 1, 2
p, q = q, p
puts "p=#{p} q=#{q}"

# Frozen (immutable) objects: strings CAN be frozen explicitly.
frozen_name = "Ada".freeze
begin
  frozen_name << " Lovelace"
rescue FrozenError => e
  puts "caught: #{e.class}"
end
