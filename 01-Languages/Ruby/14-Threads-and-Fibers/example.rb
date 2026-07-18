# Lesson 14 -- Threads and Fibers
# Ruby's MRI/CRuby interpreter (RUBY_ENGINE == "ruby", confirmed in Lesson 01)
# has a GVL (Global VM Lock, Ruby's name for what Python calls the GIL) --
# only one thread executes Ruby bytecode at a time, no matter how many
# `Thread`s are running or how many CPU cores are available.

puts "cores available (approx, via etc/nproc if present): #{Etc.nprocessors rescue 'unknown'}" if defined?(Etc)
require "etc"
puts "CPU cores: #{Etc.nprocessors}"

# A genuinely CPU-bound piece of work (no I/O at all) -- if threads gave
# real parallelism, running N of these concurrently on an N-core machine
# should take roughly the SAME wall-clock time as running just one.
def cpu_bound_work(iterations)
  total = 0
  iterations.times { |i| total += i * i }
  total
end

ITERATIONS = 40_000_000

# Baseline: run the work sequentially, once.
start = Time.now
cpu_bound_work(ITERATIONS)
sequential_one = Time.now - start
puts "one sequential run:  #{sequential_one.round(3)}s"

# Run it FOUR times sequentially (no threads at all) -- the honest baseline
# for "no parallelism whatsoever".
start = Time.now
4.times { cpu_bound_work(ITERATIONS) }
sequential_four = Time.now - start
puts "four sequential runs: #{sequential_four.round(3)}s"

# Now run the SAME four calls concurrently across four real OS Threads.
# If the GVL truly prevented parallel execution of Ruby bytecode, this
# should take roughly the SAME time as the four sequential runs above --
# NOT a quarter of it, despite genuinely using 4 OS-level threads.
start = Time.now
threads = 4.times.map { Thread.new { cpu_bound_work(ITERATIONS) } }
threads.each(&:join)
threaded_four = Time.now - start
puts "four CONCURRENT threads: #{threaded_four.round(3)}s"

speedup = sequential_four / threaded_four
puts "speedup from threading: #{speedup.round(2)}x (a true 4-core parallel win would be ~4x; the GVL means it isn't)"

# Threads DO still help for I/O-bound work, because the GVL is released
# during blocking I/O (file/network waits) -- simulated here with `sleep`,
# which Ruby's scheduler treats as blocking I/O, not CPU work.
def io_bound_work
  sleep 0.3
  "done"
end

start = Time.now
4.times { io_bound_work }
io_sequential = Time.now - start
puts "four sequential sleeps: #{io_sequential.round(3)}s"

start = Time.now
io_threads = 4.times.map { Thread.new { io_bound_work } }
io_threads.each(&:join)
io_threaded = Time.now - start
puts "four concurrent sleep-threads: #{io_threaded.round(3)}s"
puts "I/O speedup: #{(io_sequential / io_threaded).round(2)}x (near 4x -- the GVL IS released during blocking I/O)"

# --- Fibers: cooperative concurrency, explicit yield/resume, no OS threads ---
fiber = Fiber.new do
  puts "fiber: step 1"
  Fiber.yield "paused after step 1"
  puts "fiber: step 2"
  Fiber.yield "paused after step 2"
  "fiber finished"
end

puts fiber.resume    # runs until the first Fiber.yield
puts fiber.resume    # resumes from there, runs until the second Fiber.yield
puts fiber.resume    # resumes and runs to completion
begin
  fiber.resume        # resuming a dead fiber raises FiberError
rescue FiberError => e
  puts "caught: #{e.class}: #{e.message}"
end
