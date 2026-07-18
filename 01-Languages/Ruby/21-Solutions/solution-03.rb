# Solution 3 -- Vending Machine via case/when
def vend(code, balance_cents)
  cost = case code
         when :soda  then 150
         when :chips then 200
         when :candy then 100
         else raise ArgumentError, "unrecognized product code: #{code.inspect}"
         end

  if balance_cents >= cost
    change = balance_cents - cost
    "Dispensed #{code} -- change: #{change}"
  else
    shortfall = cost - balance_cents
    "Insufficient funds -- need #{shortfall} more"
  end
end

puts vend(:soda, 200)
puts vend(:chips, 200)
puts vend(:candy, 500)
puts vend(:soda, 100)
begin
  vend(:water, 500)
rescue ArgumentError => e
  puts "caught: #{e.message}"
end
