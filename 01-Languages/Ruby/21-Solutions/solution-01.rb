# Solution 1 -- Symbol-Keyed Config Validator
def validate_config(config)
  errors = []

  host = config[:host]
  errors << "host must be a non-empty String" unless host.is_a?(String) && !host.empty?

  port = config[:port]
  errors << "port must be an Integer between 1 and 65535" unless port.is_a?(Integer) && port.between?(1, 65535)

  timeout = config.fetch(:timeout, nil)
  unless timeout.nil? || (timeout.is_a?(Numeric) && timeout.positive?)
    errors << "timeout must be nil or a positive Numeric"
  end

  errors
end

valid = { host: "localhost", port: 8080, timeout: 30 }
bad_port = { host: "localhost", port: 99999, timeout: nil }
missing_host = { port: 8080 }

[valid, bad_port, missing_host].each do |config|
  errs = validate_config(config)
  puts errs.empty? ? "#{config.inspect} -> VALID" : "#{config.inspect} -> #{errs.join('; ')}"
end
