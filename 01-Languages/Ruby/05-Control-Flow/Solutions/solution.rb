# Solutions -- Control Flow

# Exercise 1
def fizzbuzz(n)
  case
  when (n % 15).zero? then "FizzBuzz"
  when (n % 3).zero?  then "Fizz"
  when (n % 5).zero?  then "Buzz"
  else n.to_s
  end
end
puts (1..20).map { |n| fizzbuzz(n) }.join(" ")

# Exercise 2
def leap_year?(year)
  return true if (year % 400).zero?
  return false if (year % 100).zero?
  (year % 4).zero?
end

[2000, 1900, 2024, 2023].each do |year|
  puts "#{year}: #{leap_year?(year)}"
end
