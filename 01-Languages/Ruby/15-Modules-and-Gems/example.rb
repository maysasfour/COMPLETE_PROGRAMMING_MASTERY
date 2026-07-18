# Lesson 15 -- Modules and Gems (require/require_relative, RubyGems, Bundler)
require "json"          # `require`: loads a standard-library or installed gem by name
require_relative "helper"  # `require_relative`: loads a file relative to THIS file's own path,
                            # regardless of the current working directory the script is run from

puts Helper.shout("loaded via require_relative")
puts JSON.generate({ ok: true })   # `json` above, loaded via plain `require` (it's stdlib, no gem needed)

# `gem` itself: list what's actually installed in this environment (proves
# RubyGems is a real, working package manager here, not just described).
puts "Gem.loaded_specs includes 'json'? #{Gem.loaded_specs.key?('json')}"
puts "RubyGems version: #{Gem::VERSION}"

# A minimal Gemfile (Bundler's dependency manifest) -- shown as a real file
# alongside this example (see Gemfile in this same folder) rather than only
# described in prose. Bundler pins exact gem versions for reproducible
# installs across machines, the Ruby ecosystem's equivalent of npm's
# package.json/package-lock.json or PHP's composer.json/composer.lock.
puts File.read(File.join(__dir__, "Gemfile"))
