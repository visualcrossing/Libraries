function dispCellArrayOfStructs(cellArray)
    % Function to display a cell array of structs in a formatted way
    % Parameters:
    %   cellArray (cell): Cell array containing structs
    
    % Check if input is a cell array
    if ~iscell(cellArray)
        error('Input must be a cell array.');
    end

    % Iterate over each element in the cell array
    for i = 1:length(cellArray)
        % Check if the element is a struct
        if ~isstruct(cellArray{i})
            error('Each element of the cell array must be a struct.');
        end

        % Display the struct index
%         fprintf('Struct %d:\n', i)

        % Get the field names of the struct
        fields = fieldnames(cellArray{i});
        
        % Iterate over each field in the struct
        for j = 1:length(fields)
            % Get the field name and value
            fieldName = fields{j};
            fieldValue = cellArray{i}.(fieldName);
            
            % Display the field name and value
            if ischar(fieldValue)
                fprintf('  %s: %s\n', fieldName, fieldValue);
            elseif isnumeric(fieldValue) || islogical(fieldValue)
                fprintf('  %s: %g\n', fieldName, fieldValue);
            elseif iscell(fieldValue)
                fprintf('  %s: {cell array}\n', fieldName);
            elseif isstruct(fieldValue)
                fprintf('  %s: [struct]\n', fieldName);
            else
                fprintf('  %s: [unknown type]\n', fieldName);
            end
        end

        % Add a separator line for better readability
        fprintf('   ------------------------\n');
    end
end
