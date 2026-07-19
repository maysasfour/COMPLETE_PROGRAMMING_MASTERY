function r = factorial_r(n)
    % Plain recursion - each .m function file gets its own call stack frame
    if n <= 1
        r = 1;
    else
        r = n * factorial_r(n - 1);
    end
end
