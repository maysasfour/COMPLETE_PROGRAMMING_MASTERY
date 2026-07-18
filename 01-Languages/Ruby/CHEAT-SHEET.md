# Ruby Cheat Sheet

[Back to course overview](README.md)

## Variables and Types (Dynamic, Everything's an Object)

```ruby
age = 30                 # Integer
price = 19.99              # Float
name = "Ada"                  # String
active = true                    # TrueClass
nothing = nil                       # NilClass -- Ruby's one "nothing" value

age.class          # Integer -- even integers are real objects
5.even?              # true -- even Integer has real methods
nil.to_a               # []   -- nil responds to real methods too

status = :active          # Symbol -- immutable, interned identifier
status.equal?(:active)       # true -- SAME object every time, unlike strings
```

## Syntax

```ruby
a = 1; b = 2              # semicolons optional, only needed for same-line statements
def greet(name) = "Hi, #{name}"   # endless method (one-liner), Ruby 3.0+

result = if a < b then "a" else "b" end   # if/case/begin are EXPRESSIONS
puts "positive" if 5 > 0     # postfix conditional
```

## Operators (All Method Calls -- Overloadable)

```ruby
class Money
  include Comparable
  def initialize(c) = @c = c
  def +(other) = Money.new(@c + other.instance_variable_get(:@c))
  def <=>(other) = @c <=> other.instance_variable_get(:@c)   # spaceship: -1/0/1
end
# defining <=> + include Comparable gives <, <=, ==, >, >=, between? FOR FREE

1 <=> 2   # -1
a&.method   # safe navigation -- nil instead of NoMethodError if a is nil
```

## Control Flow

```ruby
case score
when 90..100 then "A"     # Range === membership
when String  then "text"    # Class === is_a? check
when /^\d+$/ then "digits"    # Regexp === match
else "other"
end

i += 1 while i < 3          # postfix while
loop { break "done" }          # break returns a value from loop itself
```

## Functions: Methods, Blocks, Procs, Lambdas (THREE distinct forms)

```ruby
def greet(name, greeting: "Hi") = "#{greeting}, #{name}"   # keyword args

def twice
  yield 1; yield 2            # BLOCK: not an object, invoked via yield
end
twice { |n| puts n }

add = Proc.new { |n| n + 1 }     # PROC: lenient arity, `return` exits ENCLOSING METHOD
square = ->(n) { n * n }           # LAMBDA ("stabby"): strict arity, `return` exits itself
```

## Collections: Array, Hash, Range, Enumerable

```ruby
nums = [5, 3, 8]
nums.map { |n| n * 2 }.select(&:even?).reduce(:+)   # chainable Enumerable methods

person = { name: "Ada", age: 36 }        # symbol keys -- idiomatic
person.each { |k, v| puts "#{k}: #{v}" }
person.group_by { }; person.transform_values { }

(1..5).to_a       # [1,2,3,4,5] inclusive
(1...5).to_a       # [1,2,3,4]   exclusive
```

## Strings (MUTABLE -- unlike Python)

```ruby
s = "hello"
s << " world"          # mutates IN PLACE (same object_id)
s2 = s + "!"              # allocates a NEW string (different object_id)
s.upcase!                   # bang methods mutate in place

doc = <<~TEXT
  Interpolates #{name}, strips common leading indentation.
TEXT
```

## Error Handling

```ruby
class InsufficientFundsError < StandardError; end   # subclass StandardError, NOT Exception!

begin
  risky_call
rescue SpecificError => e
  puts e.message
  retry if attempts < 3        # re-runs the begin block from the top
ensure
  cleanup                       # always runs
end
```

## OOP: Classes, Mixins, method_missing

```ruby
module Greetable
  def greet = "Hi, I'm #{name}."
end

class Animal
  attr_accessor :name             # generates name/name= in one line
  include Greetable                 # mixin: INSTANCE methods, zero inheritance needed
end

class Widget
  extend SomeModule                  # extend: CLASS methods instead of instance methods
end

class DynamicRecord
  def method_missing(name, *args)      # uniquely dynamic metaprogramming hook
    # ... handle or `super` for real NoMethodError
  end
  def respond_to_missing?(name, priv = false)   # MUST pair with method_missing
    # ...
  end
end
```

## Duck Typing (NO Generics At All)

```ruby
def make_it_speak(thing) = thing.speak   # no type constraint whatsoever

thing.respond_to?(:speak)   # idiomatic runtime check, the substitute for a
                              # compile-time generic constraint Ruby doesn't have
```

## Threads, the GVL, and Fibers

```ruby
# MRI/CRuby's GVL (Global VM Lock): only ONE thread runs Ruby bytecode at a time.
# Measured in this course: 4 CPU-bound threads = 0.97x speedup (NO real parallelism).
# 4 I/O-bound (sleep-based) threads = 3.21x speedup (GVL IS released during I/O).
threads = 4.times.map { Thread.new { do_work } }
threads.each(&:join)

fiber = Fiber.new { Fiber.yield "paused"; "done" }   # cooperative, explicit resume/yield
fiber.resume   # "paused"
fiber.resume   # "done"
```

## Modules and Gems

```ruby
require "json"              # stdlib or installed gem, searched via $LOAD_PATH
require_relative "helper"     # resolves relative to THIS FILE, not the working directory
```

```ruby
# Gemfile (Bundler)
source "https://rubygems.org"
gem "sqlite3", "~> 2.9"
```

## Database (sqlite3 gem)

```ruby
require "sqlite3"
db = SQLite3::Database.new("app.db")
db.results_as_hash = true
db.execute("INSERT INTO users (name) VALUES (?)", [name])   # ALWAYS parameterize
db.execute("SELECT * FROM users WHERE id = ?", [id]).first
```

## HTTP / JSON

```ruby
require "net/http"
require "json"

response = Net::HTTP.get_response(URI("https://api.example.com/data"))
# Net::HTTP does NOT raise on 404 -- check response.is_a?(Net::HTTPSuccess) explicitly!
data = JSON.parse(response.body)                     # STRING keys by default
data = JSON.parse(response.body, symbolize_names: true)  # symbol keys, opt-in
```

## Testing (Minitest -- ships with Ruby)

```ruby
require "minitest/autorun"

class MyTest < Minitest::Test
  def setup = @thing = Thing.new   # fresh state before EVERY test
  def test_it_works = assert_equal 4, 2 + 2
  def test_it_raises = assert_raises(ArgumentError) { Thing.new(-1) }
end
```

## Running Code

```bash
ruby script.rb                 # no build step, runs directly
irb                              # interactive REPL
gem install sqlite3               # RubyGems package manager
bundle install                      # Bundler, resolves Gemfile -> Gemfile.lock
```
