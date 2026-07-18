# Lesson 06 -- Functions (Methods, Blocks, Procs, Lambdas)

# A method (def) with default and keyword arguments.
def greet(name, greeting: "Hello")
  "#{greeting}, #{name}!"
end
puts greet("Ada")
puts greet("Grace", greeting: "Hi")

# Splat (*args) and double-splat (**kwargs) for variable arity.
def summarize(*nums, **opts)
  total = nums.sum
  label = opts.fetch(:label, "total")
  "#{label}: #{total}"
end
puts summarize(1, 2, 3)
puts summarize(4, 5, label: "sum")

# --- The three-way split: blocks, Procs, and Lambdas -----------------------
# 1. A BLOCK is not an object -- it's syntax attached to a method call,
#    received inside the method via `yield` or an explicit `&block` param.
def twice
  yield 1
  yield 2
end
twice { |n| puts "block call ##{n}" }

def twice_explicit(&block)
  block.call(10)
  block.call(20)
end
twice_explicit { |n| puts "explicit block param ##{n}" }

# 2. A PROC is a block turned into a real, storable, passable object.
add_one = Proc.new { |n| n + 1 }
puts add_one.call(5)
puts add_one.(5)     # alternate call syntax
puts add_one[5]       # yet another alternate call syntax

# 3. A LAMBDA is a stricter Proc: it checks argument count (raises
#    ArgumentError on mismatch, a Proc silently ignores extras/fills nils),
#    and `return` inside a lambda returns from the LAMBDA only -- a `return`
#    inside a plain Proc returns from the ENCLOSING METHOD, a genuine, sharp
#    difference proven live below.
square = lambda { |n| n * n }
square2 = ->(n) { n * n }  # "stabby lambda" syntax, equivalent
puts square.call(4)
puts square2.call(4)
puts "square.lambda? = #{square.lambda?}"
puts "add_one.lambda? = #{add_one.lambda?}"

def proc_return_test
  p = Proc.new { return "returned from Proc, exits the METHOD" }
  p.call
  "this line never runs if the Proc's return fires"
end
puts proc_return_test

def lambda_return_test
  l = lambda { return "returned from lambda, exits the LAMBDA only" }
  result = l.call
  "lambda returned #{result.inspect}, but THIS is the method's real return value"
end
puts lambda_return_test

# Arity strictness: a Proc tolerates a wrong argument count, a lambda doesn't.
lenient_proc = Proc.new { |a, b| "a=#{a.inspect} b=#{b.inspect}" }
puts lenient_proc.call(1)   # missing arg silently becomes nil, no error

strict_lambda = ->(a, b) { "a=#{a} b=#{b}" }
begin
  strict_lambda.call(1)
rescue ArgumentError => e
  puts "caught: #{e.class}: #{e.message}"
end
