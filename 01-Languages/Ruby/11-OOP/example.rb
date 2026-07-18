# Lesson 11 -- OOP: classes, modules (mixins), attr_accessor, method_missing

module Greetable
  def greet
    "Hi, I'm #{name}."
  end
end

module Auditable
  def last_action
    "#{self.class}: no actions logged yet"
  end
end

class Animal
  attr_accessor :name, :age   # generates name/name=/age/age= in one line

  include Greetable            # mixin -- Animal gets `greet` with ZERO inheritance
  include Auditable

  def initialize(name, age)
    @name = name
    @age = age
  end

  def speak
    raise NotImplementedError, "#{self.class} must implement speak"
  end

  def to_s
    "#{self.class.name}(#{name}, #{age})"
  end
end

class Dog < Animal
  def speak
    "#{name} says Woof!"
  end
end

class Cat < Animal
  def speak
    "#{name} says Meow!"
  end
end

dog = Dog.new("Rex", 3)
cat = Cat.new("Tom", 2)
puts dog.speak
puts cat.speak
puts dog.greet          # from the Greetable mixin, no inheritance involved
puts dog.last_action     # from the Auditable mixin
puts dog.to_s
dog.age += 1
puts "dog is now #{dog.age}"

# `include` mixes a module's instance methods in; `extend` mixes them in as
# CLASS/singleton methods on the receiver instead -- a real, verified difference.
module Describable
  def description
    "a describable thing"
  end
end

class Widget
  extend Describable   # class-level: Widget.description, NOT widget_instance.description
end
puts Widget.description
begin
  Widget.new.description
rescue NoMethodError => e
  puts "confirmed: extend gives a CLASS method, not an instance method (#{e.class})"
end

# Polymorphism: same message, different classes' own implementation.
[dog, cat].each { |a| puts a.speak }

# method_missing -- Ruby's uniquely dynamic metaprogramming hook: intercepts
# calls to methods that don't actually exist, letting a class respond to an
# open-ended set of method names computed at runtime.
class DynamicRecord
  def initialize(data)
    @data = data
  end

  def method_missing(name, *args)
    key = name.to_s.chomp("=")
    if name.to_s.end_with?("=")
      @data[key.to_sym] = args.first
    elsif @data.key?(name)
      @data[name]
    else
      super   # IMPORTANT: fall back to real method_missing (raises NoMethodError) for truly unknown names
    end
  end

  # respond_to_missing? MUST be overridden alongside method_missing, or
  # respond_to?/methods introspection will lie about what actually works.
  def respond_to_missing?(name, include_private = false)
    key = name.to_s.chomp("=")
    @data.key?(key.to_sym) || @data.key?(name) || super
  end
end

record = DynamicRecord.new(title: "Ruby Course", pages: 22)
puts record.title            # dynamically dispatched -- no `title` method was ever defined
puts record.pages
record.pages = 23             # dynamically dispatched setter
puts record.pages
puts "responds_to? title = #{record.respond_to?(:title)}"
puts "responds_to? nope = #{record.respond_to?(:nonexistent_field)}"
begin
  record.nonexistent_field
rescue NoMethodError => e
  puts "correctly raised for truly unknown method: #{e.class}"
end
