function varargout = describe_call()
    % nargout tells a function how many outputs the caller actually requested
    fprintf('nargout = %d\n', nargout);
    for i = 1:nargout
        varargout{i} = i;
    end
end
