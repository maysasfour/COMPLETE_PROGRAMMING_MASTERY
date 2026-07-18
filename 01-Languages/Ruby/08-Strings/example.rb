# Lesson 08 -- Strings
# frozen_string_literal: false  (deliberately NOT frozen here, so mutation below works --
# contrast with Python, where strings are immutable and none of this would even compile.)

name = "Ada"
greeting = "Hello, #{name}!"     # interpolation
puts greeting

# Ruby strings are MUTABLE -- a genuine, deliberate contrast with Python's
# immutable str. `<<` and `concat`/`replace`/`upcase!` mutate the SAME
# object in place rather than allocating a new one, verified via object_id.
s = "hello"
original_id = s.object_id
s << " world"          # mutates in place
puts s
puts "same object? #{s.object_id == original_id}"

s2 = "hello"
s2_id = s2.object_id
s2 = s2 + " world"      # `+` allocates a NEW string -- does NOT mutate in place
puts "same object after +? #{s2.object_id == s2_id}"

s3 = "hello"
s3.upcase!               # bang methods mutate in place
puts s3

# Heredocs -- multi-line string literals
document = <<~TEXT
  Dear #{name},

  Thank you for using Ruby.
  Line three, still interpolated.
TEXT
puts document

# The squiggly heredoc (<<~) strips leading indentation from every line;
# the plain heredoc (<<-) or (<<) does not, kept here for contrast.
raw = <<-RAW
    This line keeps its leading indentation.
  RAW
puts raw

# Common string methods
puts "  padded  ".strip
puts "ruby".center(10, "*")
puts "a,b,,c".split(",").inspect     # keeps the empty string between commas
puts "a-b-c".gsub("-", "_")
puts "Hello".reverse
puts "Hello" * 3
puts "Hello".length
