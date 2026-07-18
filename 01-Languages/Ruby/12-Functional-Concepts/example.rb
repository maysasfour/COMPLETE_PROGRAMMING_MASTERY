# Lesson 12 -- Functional Concepts (blocks/procs/lambdas revisited, Enumerable, chaining)

# Method chaining as function composition -- each Enumerable call returns a
# new Enumerator/collection, letting a pipeline read left-to-right.
words = %w[ruby is a genuinely fun dynamic language]
pipeline = words
           .select { |w| w.length > 2 }
           .map(&:upcase)
           .sort
           .first(3)
puts pipeline.inspect

# `&:symbol` is shorthand for `{ |x| x.symbol }` -- Symbol#to_proc.
puts words.map(&:length).inspect
puts words.map { |w| w.length }.inspect   # identical result, spelled out

# Composing two lambdas into a new one, real function composition.
double = ->(x) { x * 2 }
increment = ->(x) { x + 1 }
composed = double >> increment    # >> : apply double THEN increment
reverse_composed = double << increment  # << : apply increment THEN double
puts composed.call(5)             # (5*2)+1 = 11
puts reverse_composed.call(5)     # (5+1)*2 = 12

# Higher-order functions: a method that takes AND returns a callable.
def multiplier(factor)
  ->(x) { x * factor }
end
triple = multiplier(3)
puts triple.call(7)

# Enumerable::lazy -- builds a pipeline that only actually computes as many
# elements as are ultimately consumed, useful over large/infinite sequences.
lazy_result = (1..Float::INFINITY).lazy.select(&:even?).first(5)
puts lazy_result.inspect

# each_slice / each_cons -- functional-style windowing over a collection.
puts (1..10).each_slice(3).to_a.inspect
puts (1..5).each_cons(2).to_a.inspect

# reduce with a symbol AND an explicit initial value together.
puts [1, 2, 3, 4].reduce(100, :+)

# Immutability-flavored functional style: `map` (not `map!`) always returns
# a NEW array, leaving the original untouched -- verified directly.
original = [1, 2, 3]
doubled = original.map { |n| n * 2 }
puts "original unchanged: #{original.inspect}"
puts "doubled: #{doubled.inspect}"
