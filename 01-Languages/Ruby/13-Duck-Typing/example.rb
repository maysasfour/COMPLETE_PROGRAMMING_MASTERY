# Lesson 13 -- Duck Typing (Ruby has NO generics at all)
# "If it walks like a duck and quacks like a duck, it's a duck" -- Ruby
# cares only whether an object RESPONDS to the methods actually being
# called on it, never its declared type (there is no declared type,
# and no <T> generic-parameter syntax anywhere in the language).

class Duck
  def speak
    "Quack!"
  end
end

class Person
  def speak
    "I'm quacking like a duck!"
  end
end

class RubberDuck
  def speak
    "Squeak! (I'm not a real duck, but I respond to .speak too)"
  end
end

# make_it_speak has NO type constraint on `thing` whatsoever -- it works on
# ANY object that happens to respond to `.speak`, regardless of class or
# inheritance relationship between them.
def make_it_speak(thing)
  thing.speak
end

[Duck.new, Person.new, RubberDuck.new].each { |t| puts make_it_speak(t) }

# respond_to? is the idiomatic way to check duck-type compatibility BEFORE
# calling a method, when the call isn't already guaranteed to work --
# genuinely the Ruby-idiomatic alternative to a compile-time generic
# constraint (like Java/C#'s `<T extends Speaker>`) since Ruby has none.
def safe_speak(thing)
  if thing.respond_to?(:speak)
    thing.speak
  else
    "#{thing.class} doesn't know how to speak"
  end
end
puts safe_speak(Duck.new)
puts safe_speak(42)                 # Integer has no #speak -- handled gracefully
puts safe_speak("a string")

# A container-like class with NO generic type parameter, holding literally
# ANYTHING -- proven by pushing genuinely mismatched types into the SAME
# stack with zero compile-time or runtime complaint (unlike Java's
# `Stack<Integer>`, which a generic type parameter would reject at compile
# time for a String push).
class Stack
  def initialize
    @items = []
  end

  def push(item)
    @items.push(item)
    self
  end

  def pop
    @items.pop
  end

  def peek
    @items.last
  end

  def empty?
    @items.empty?
  end
end

mixed_stack = Stack.new
mixed_stack.push(42).push("a string").push([1, 2, 3]).push(:a_symbol)
puts "mixed types pushed with zero complaint: #{mixed_stack.instance_variable_get(:@items).map(&:class).inspect}"
until mixed_stack.empty?
  puts mixed_stack.pop.inspect
end

# Contrast (documented, not executed -- Ruby has no such syntax at all):
# Java:  Stack<Integer> s = new Stack<>(); s.push("oops"); // COMPILE ERROR
# Ruby:  stack.push(42); stack.push("oops")                // runs fine, no error, ever
puts "Ruby has no generic type parameters -- duck typing + respond_to? is the idiomatic substitute."
