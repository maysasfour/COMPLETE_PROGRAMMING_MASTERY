# Solution 4 -- Retry-With-Backoff Using a Block
def with_retries(max_attempts:)
  attempt = 0
  begin
    attempt += 1
    yield(attempt)
  rescue StandardError => e
    if attempt < max_attempts
      sleep(0.1 * attempt)
      retry
    else
      raise e
    end
  end
end

failures = 0
result = with_retries(max_attempts: 3) do |attempt|
  failures += 1 if attempt < 3
  raise "simulated transient failure" if attempt < 3
  "succeeded on attempt #{attempt}"
end
puts result
puts "total simulated failures before success: #{failures}"
