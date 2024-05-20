function valid = is_valid_struct(variable, allowed_keys)
    % Check if the variable is a struct and if all its fields are in the allowed keys.
    %
    % :param variable: The variable to check.
    % :param allowed_keys: A cell array of allowed keys.
    % :return: True if variable is a struct and all fields are in allowed_keys, False otherwise.
    
    valid = false;
    if isstruct(variable)
        keys = fieldnames(variable);
        if all(ismember(keys, allowed_keys))
            valid = true;
        end
    end
end
