# Lesson 02 -- Syntax
# No semicolons required: a newline ends a statement. Semicolons are legal
# (useful for cramming two statements on one line) but never mandatory.
a = 1; b = 2
puts a + b

# `end` closes blocks (if/def/class/while/...) instead of braces {}.
def shout(word)
  word.upcase + "!"
end
puts shout("hello")

# Everything is an EXPRESSION in Ruby, including if/case/begin -- they all
# evaluate to a value that can be assigned or returned directly.
status = if a < b
           "a is smaller"
         else
           "a is not smaller"
         end
puts status

grade = case 85
        when 90..100 then "A"
        when 80...90 then "B"
        else "C"
        end
puts grade

# A method's last evaluated expression is its implicit return value --
# no explicit `return` needed (though `return` is legal and sometimes clearer).
def add(x, y)
  x + y
end
puts add(3, 4)

# Postfix (statement) modifiers read almost like English.
puts "positive" if 5 > 0
puts "unreachable" unless true

# Everything, even a plain integer literal, has a value AND is itself an
# object with real methods -- proven directly, not just asserted:
puts 5.class          # Integer
puts (a = 10).class   # assignment itself is an expression; its value is 10
