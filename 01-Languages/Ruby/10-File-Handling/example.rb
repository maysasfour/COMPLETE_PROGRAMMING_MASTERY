# Lesson 10 -- File Handling (File/IO + built-in JSON)
require "json"
require "fileutils"

dir = File.join(__dir__, "tmp_data")
FileUtils.mkdir_p(dir)
path = File.join(dir, "notes.txt")

# Writing and reading a plain text file
File.write(path, "line one\nline two\nline three\n")
puts File.read(path)

File.open(path, "a") { |f| f.puts "appended line" }
File.foreach(path) { |line| print "> #{line}" }

puts "exists? #{File.exist?(path)}"
puts "size: #{File.size(path)} bytes"

# JSON is genuinely built into Ruby's standard library -- `require "json"`
# needs no gem install at all, a positive contrast worth documenting the
# same way this repository calls out other languages' JSON gaps (or lack
# thereof).
data = { name: "Ada", langs: ["Ruby", "Python"], active: true, meta: { age: 36 } }
json_path = File.join(dir, "data.json")
File.write(json_path, JSON.pretty_generate(data))
puts File.read(json_path)

parsed = JSON.parse(File.read(json_path))
puts parsed.class                 # Hash -- note STRING keys by default!
puts parsed["name"]
puts parsed.inspect

parsed_symbols = JSON.parse(File.read(json_path), symbolize_names: true)
puts parsed_symbols[:name]        # symbolize_names: true gives symbol keys back

# Clean up the temp files/directory this example created.
FileUtils.rm_rf(dir)
puts "cleaned up: #{!File.exist?(dir)}"
