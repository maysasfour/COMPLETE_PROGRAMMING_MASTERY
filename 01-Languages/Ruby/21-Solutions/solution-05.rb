# Solution 5 -- Top-N Word Frequencies via Enumerable Chaining
def top_n_words(text, n)
  text.downcase
      .split
      .map { |w| w.gsub(/[^a-z0-9]/, "") }
      .reject(&:empty?)
      .each_with_object(Hash.new(0)) { |word, counts| counts[word] += 1 }
      .sort_by { |word, count| [-count, word] }
      .first(n)
end

paragraph = "the quick brown fox. The fox jumps! The lazy dog sleeps, and the fox runs."
top_n_words(paragraph, 3).each { |word, count| puts "#{word}: #{count}" }
