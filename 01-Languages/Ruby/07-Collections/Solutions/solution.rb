# Solutions -- Collections

# Exercise 1
sentence = "the quick brown fox jumps over the lazy dog the fox runs"
counts = sentence.split.each_with_object(Hash.new(0)) { |word, acc| acc[word] += 1 }
counts.sort_by { |_word, count| -count }.each do |word, count|
  puts "#{word}: #{count}"
end

# Exercise 2
inventory = [
  { name: "Widget", category: :hardware, qty: 5 },
  { name: "Bolt", category: :hardware, qty: 100 },
  { name: "Manual", category: :docs, qty: 20 }
]

by_category = inventory.group_by { |item| item[:category] }
totals = by_category.transform_values { |items| items.sum { |item| item[:qty] } }
totals.each { |category, total| puts "#{category}: #{total}" }
