# Lesson 17 -- API Integration (Net::HTTP, standard library, no gem needed)
require "net/http"
require "json"
require "uri"

BASE = "https://jsonplaceholder.typicode.com"

# GET
uri = URI("#{BASE}/todos/1")
response = Net::HTTP.get_response(uri)
puts "GET #{uri} -> #{response.code}"
todo = JSON.parse(response.body)
puts todo.inspect

# Net::HTTP does NOT raise on a 404 -- it just returns a Net::HTTPNotFound
# response object; the caller must check .code/.is_a? explicitly, the same
# "doesn't throw on 404" trap this repository has verified in several other
# languages' HTTP clients (fetch in JS, curl in PHP).
missing_uri = URI("#{BASE}/todos/999999")
missing_response = Net::HTTP.get_response(missing_uri)
puts "GET #{missing_uri} -> #{missing_response.code} (#{missing_response.class})"
puts "is_a?(Net::HTTPSuccess) = #{missing_response.is_a?(Net::HTTPSuccess)}"

# POST with a JSON body
post_uri = URI("#{BASE}/posts")
http = Net::HTTP.new(post_uri.host, post_uri.port)
http.use_ssl = (post_uri.scheme == "https")
request = Net::HTTP::Post.new(post_uri.path, { "Content-Type" => "application/json" })
request.body = JSON.generate({ title: "Ruby Course", body: "posted via Net::HTTP", userId: 1 })
post_response = http.request(request)
puts "POST #{post_uri} -> #{post_response.code}"
created = JSON.parse(post_response.body)
puts created.inspect

# A tiny helper wrapping the "check success before parsing" pattern properly.
def safe_get_json(url)
  uri = URI(url)
  response = Net::HTTP.get_response(uri)
  raise "HTTP #{response.code} for #{url}" unless response.is_a?(Net::HTTPSuccess)
  JSON.parse(response.body)
end

result = safe_get_json("#{BASE}/users/1")
puts "safe_get_json user: #{result['name']} <#{result['email']}>"

begin
  safe_get_json("#{BASE}/users/999999")
rescue RuntimeError => e
  puts "caught: #{e.message}"
end
