function updated = update_struct(original, updates, exclude_keys)
    % Update the original dictionary with values from the updates dictionary,
    % excluding keys specified in exclude_keys.
    %
    % :param original: The original struct to update.
    % :param updates: The struct with update values.
    % :param exclude_keys: A cell array of keys to exclude from updating.
    
    fields_updates = fieldnames(updates);
    for i = 1:numel(fields_updates)
        key = fields_updates{i};
        if ~ismember(key, exclude_keys)
            original.(key) = updates.(key);
        end
    end
    updated = original;
end
