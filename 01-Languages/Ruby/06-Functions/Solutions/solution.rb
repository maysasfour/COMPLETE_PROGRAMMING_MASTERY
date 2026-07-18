# Solutions -- Functions

# Exercise 1
def measure(label)
  start = Time.now
  result = yield
  elapsed = Time.now - start
  puts "#{label}: #{elapsed.round(4)}s"
  result
end

total = measure("sum 1..1_000_000") { (1..1_000_000).sum }
puts "returned sum = #{total}"

# Exercise 2
def make_incrementer
  count = 0
  ->() { count += 1 }   # lambda: safe to call() repeatedly
end

inc = make_incrementer
puts inc.call   # 1
puts inc.call   # 2
puts inc.call   # 3

def broken_incrementer
  count = 0
  p = Proc.new {
    count += 1
    return count   # <-- return here exits broken_incrementer ITSELF, not just the Proc
  }
  p.call           # this line executes fully...
  puts "unreachable: broken_incrementer's own return already fired inside p.call"
end

result = broken_incrementer
puts "broken_incrementer actually returned: #{result.inspect}"
puts "note: the 'unreachable' line inside broken_incrementer never printed --"
puts "the Proc's `return` exited the enclosing METHOD the moment p.call ran,"
puts "proving live that Proc `return` is method-scoped, unlike a lambda's."
