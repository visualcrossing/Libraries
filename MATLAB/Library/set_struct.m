function result = set_struct(original, struct_to_set)
    % Set the original dictionary with values from the struct to set.
    %
    % :param original: The original struct to update.
    % :param struct_to_set: The struct with set values.
    
    fields_updates = fieldnames(struct_to_set);
    fields_original = fieldnames(original);
    for i = 1:numel(fields_original)
        key = fields_original{i};
        if ismember(key, fields_updates)
            original.(key) = struct_to_set.(key);
        else
            original.(key) = nan;
        end
    end
    result = original;
end