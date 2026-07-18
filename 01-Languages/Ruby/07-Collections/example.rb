# Lesson 07 -- Collections (Array, Hash, Range, Enumerable)

# Arrays
nums = [5, 3, 8, 1, 9]
puts nums.sort.inspect
puts nums.map { |n| n * 2 }.inspect
puts nums.select { |n| n.even? }.inspect
puts nums.reject { |n| n.even? }.inspect
puts nums.reduce(0) { |sum, n| sum + n }
puts nums.reduce(:+)          # symbol-to-proc shorthand for the same reduce
puts nums.sum
puts nums.min, nums.max
puts nums.first(2).inspect
puts nums.last(2).inspect

# Hashes -- symbol keys are idiomatic (Lesson 03)
person = { name: "Ada", age: 36, langs: ["Ruby", "Python"] }
puts person[:name]
person.each { |key, value| puts "#{key} => #{value}" }
puts person.keys.inspect
puts person.select { |k, v| v.is_a?(Integer) }.inspect
transformed = person.transform_values { |v| v.is_a?(String) ? v.upcase : v }
puts transformed.inspect

# Ranges
r = (1..5)
puts r.to_a.inspect
puts (1...5).to_a.inspect     # exclusive end
puts r.include?(5)
puts (1...5).include?(5)
puts ("a".."e").to_a.inspect   # ranges work over any Comparable, not just numbers

# Enumerable chaining -- map/select/reduce compose freely
result = (1..20).select(&:even?).map { |n| n ** 2 }.reduce(:+)
puts "sum of squares of even numbers 1..20 = #{result}"

# each_with_object and group_by, two less-obvious but very idiomatic Enumerable methods
words = %w[apple banana cherry date elderberry fig]
by_length = words.group_by(&:length)
puts by_length.inspect

totals = [["a", 1], ["b", 2], ["a", 3]].each_with_object(Hash.new(0)) do |(key, val), acc|
  acc[key] += val
end
puts totals.inspect

# Array/Hash destructuring in block params
pairs = { x: 1, y: 2 }
pairs.each { |(k, v)| puts "#{k}: #{v}" }
