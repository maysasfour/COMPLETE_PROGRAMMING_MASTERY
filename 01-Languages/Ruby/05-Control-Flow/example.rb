# Lesson 05 -- Control Flow

# if / elsif / else, plus `unless` (the inverse of `if`)
def describe(n)
  if n > 0
    "positive"
  elsif n < 0
    "negative"
  else
    "zero"
  end
end
[5, -3, 0].each { |n| puts "#{n}: #{describe(n)}" }

puts "not empty" unless [].any?  # postfix unless
puts "has items" if [1].any?     # postfix if

# case/when -- matches with === under the hood, so it works with ranges,
# classes, regexes, not just literal equality.
def bucket(score)
  case score
  when 90..100 then "A"
  when 80...90 then "B"
  when 70...80 then "C"
  else "F"
  end
end
[95, 82, 71, 40].each { |s| puts "#{s} -> #{bucket(s)}" }

# case/when on class and regex, proving === is doing real work, not just `==`
def classify(value)
  case value
  when Integer then "integer"
  when String  then "string"
  when /^\d+\.\d+$/ then "looks like a decimal string" # unreachable after String above, shown deliberately
  when Array   then "array"
  else "other"
  end
end
[42, "hi", [1, 2]].each { |v| puts "#{v.inspect} -> #{classify(v)}" }

# while / until, both with postfix forms too
i = 0
i += 1 while i < 3
puts "i ended at #{i}"

j = 5
j -= 1 until j <= 0
puts "j ended at #{j}"

# loop + break with a value -- `break` can return a value from `loop`
result = loop do
  break "done!"
end
puts result
