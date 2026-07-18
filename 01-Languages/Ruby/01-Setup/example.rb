# Lesson 01 -- Setup
# Ruby has NO build step: `ruby example.rb` parses and executes this file
# directly, top to bottom, every single run -- there is no separate compile
# phase and no intermediate artifact left on disk (contrast with C#/Java/Rust
# elsewhere in this repository, which all produce a build output first).

puts "RUBY_VERSION:    #{RUBY_VERSION}"
puts "RUBY_PLATFORM:   #{RUBY_PLATFORM}"
puts "RUBY_ENGINE:     #{RUBY_ENGINE}"      # "ruby" = the reference MRI/CRuby implementation
puts "__FILE__:        #{__FILE__}"

# `gem` is Ruby's package manager (RubyGems, bundled with every Ruby install).
# `Gem::VERSION` reports the RubyGems library version linked into this interpreter.
require "rubygems"
puts "RubyGems ver:    #{Gem::VERSION}"

# irb (Interactive Ruby) is Ruby's REPL, launched with `irb` from a shell.
# It is not exercised here since this file must run non-interactively with
# `ruby`, but every expression below is exactly what you'd type at an irb
# prompt one line at a time.
puts "2 + 2 = #{2 + 2}"
