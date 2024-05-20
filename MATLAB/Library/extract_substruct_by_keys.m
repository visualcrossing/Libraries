function substruct = extract_substruct_by_keys(original_struct, keys_list)
    % Extract a sub-struct from the original struct with fields specified in keys_list.
    %
    % :param original_struct: The original struct to extract from.
    % :param keys_list: A cell array of keys to include in the sub-struct.
    % :return: A sub-struct containing only the specified keys.
    
    substruct = struct();
    for i = 1:numel(keys_list)
        key = keys_list{i};
        if isfield(original_struct, key)
            substruct.(key) = original_struct.(key);
        end
    end
end
