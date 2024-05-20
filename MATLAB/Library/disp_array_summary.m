function disp_array_summary(array, num_elements)
    % Function to display a summary of a long array
    % Parameters:
    %   array: The input array to display
    %   num_elements: Number of elements to display at the start and end
    
    n = length(array);

    if nargin < 2
        num_elements = 3;
    end
    
    if n <= 2 * num_elements
        % If the array is short, display all elements
        fprintf('%s (Length: %d)\n', mat2str(array), n);
    else
        % Display the first few elements
        start_elements = array(1:num_elements);
        
        % Display the last few elements
        end_elements = array(end-num_elements+1:end);
        
        % Convert elements to strings without brackets
        start_str = strjoin(string(start_elements), ', ');
        end_str = strjoin(string(end_elements), ', ');
        
        % Display the summary
        fprintf('%s ... %s (Length: %d)\n', start_str, end_str, n);
    end
end
 