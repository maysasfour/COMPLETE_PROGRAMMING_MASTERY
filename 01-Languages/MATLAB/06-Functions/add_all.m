function total = add_all(varargin)
    % varargin collects any number of trailing arguments into a cell array
    total = 0;
    for i = 1:numel(varargin)
        total = total + varargin{i};
    end
end
