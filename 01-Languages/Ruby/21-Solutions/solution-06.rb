# Solution 6 -- Custom Exception Hierarchy with retry
class NetworkError < StandardError; end
class TimeoutError < NetworkError; end
class ConnectionRefusedError < NetworkError; end

def fetch_data(attempt_sequence, attempt_index)
  outcome = attempt_sequence[attempt_index]
  case outcome
  when :timeout then raise TimeoutError, "attempt #{attempt_index + 1} timed out"
  when :refused then raise ConnectionRefusedError, "attempt #{attempt_index + 1} was refused"
  when :ok      then "data!"
  else raise "unknown simulated outcome #{outcome.inspect}"
  end
end

def run_with_sequence(sequence)
  index = 0
  begin
    result = fetch_data(sequence, index)
    puts "succeeded on attempt #{index + 1}: #{result}"
  rescue NetworkError => e
    puts "attempt #{index + 1} failed with #{e.class}: #{e.message}"
    index += 1
    retry if index < sequence.length
  end
end

run_with_sequence([:timeout, :refused, :ok])
