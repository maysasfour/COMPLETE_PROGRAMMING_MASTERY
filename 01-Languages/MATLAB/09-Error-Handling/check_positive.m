function check_positive(n)
    if n <= 0
        error('MyApp:invalidInput', 'Value must be positive, got %d', n);
    end
    fprintf('%d is valid\n', n);
end
