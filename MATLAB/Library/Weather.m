classdef Weather<handle
    % Weather Class to interact with the Visual Crossing Weather API
    % A class to fetch and manipulate weather data using the Visual Crossing Weather API.
    %
    % Attributes:
    %   base_url (char): Base URL of the API.
    %   api_key (char): API key for accessing the API.
    %   weather_data (struct): Internal storage for weather data.
    
    properties
        base_url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/";
        api_key
    end
    
    properties
        weather_data
    end


    methods (Static)
        function idx = get_idx_from_datetimeArg(src, datetimeArg)
            % Filters an item by its datetime value from a list of structs, each containing a 'datetime' field.
            %
            % Parameters:
            %   src (struct array): The source array of structs, each expected to contain a 'datetime' field.
            %   datetimeVal (char|int): The datetime value used for filtering, which can be a date string or an index.
            %
            % Returns:
            %   struct: The filtered struct item.

            idx = 0;
            if ischar(datetimeArg)
                for i = 1:numel(src)
                    if strcmp(src(i).datetime, datetimeArg)
                        idx = i;
                        return;
                    end
                end
            elseif isnumeric(datetimeArg) && isscalar(datetimeArg)
                idx = datetimeArg;
            else
                error('Invalid input datetime value for get_idx_from_datetimeArg with str or int: %s', datetimeArg);
            end
        end
        
        function src = set_item_by_datetimeIdx(src, datetimeIdx, data)
            % Sets an item's data by its datetime value in a list of structs based on the given datetimeVal.
            %
            % Parameters:
            %   src (struct array): The source array of structs, each expected to contain a 'datetime' field.
            %   datetimeVal (char|int): The datetime value used for updating, which can be a date string or an index.
            %   data (struct): The new data struct to replace the old struct.

            if ~isstruct(data)
                error('Invalid input data value for set_item_by_datetimeIdx with struct: %s', data);
            end
            if isnumeric(datetimeIdx) && isscalar(datetimeIdx)
                data.datetime = src(datetimeIdx).datetime;  % Ensure datetime is not changed
                src(datetimeIdx) = set_struct(src(datetimeIdx), data);
            else
                error('Invalid input datetime index for set_item_by_datetimeIdx with int: %s', datetimeIdx);
            end
        end
        
        function src = update_item_by_datetimeIdx(src, datetimeIdx, data)
            % Updates an item's data by its datetime value in a list of structs based on the given datetimeVal.
            %
            % Parameters:
            %   src (struct array): The source array of structs, each expected to contain a 'datetime' field.
            %   datetimeVal (char|int): The datetime value used for updating, which can be a date string or an index.
            %   data (struct): The new data struct to update the old struct.

            if ~isstruct(data)
                error('Invalid input data value for update_item_by_datetimeIdx with struct: %s', data);
            end

            if isnumeric(datetimeIdx) && isscalar(datetimeIdx)                
                data.datetime = src(datetimeIdx).datetime;  % Ensure datetime is not changed
                src(datetimeIdx) = update_struct(src(datetimeIdx), data);
            else
                error('Invalid input datetime value for update_item_by_datetimeIdx with str or int: %s', datetimeIdx);
            end
        end
    end
    

    methods
        function obj = Weather(varargin)
            % Initialize the Weather object with base URL and API key.
            %
            % Parameters:
            %   base_url (char): Base URL of the weather API.
            %   api_key (char): API key for the weather API.
            
            if nargin == 1
                base_url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline";
                api_key = varargin{1};
            end
            if nargin == 2
                base_url = varargin{1};
                api_key = varargin{2};
            end
            
            obj.base_url = base_url;
            obj.api_key = api_key;
            obj.weather_data = struct();
        end
        
        function weather_data = fetch_weather_data(obj, location, from_date, to_date, unit_group, include, elements)
            % Fetch weather data for a specified location and date range.
            %
            % Parameters:
            %   location (char): Location for which weather data is requested.
            %   from_date (char): Start date of the weather data period (in 'yyyy-MM-dd' format).
            %   to_date (char): End date of the weather data period (in 'yyyy-MM-dd' format).
            %   unit_group (char): Unit system for the weather data ('us', 'metric', 'uk' or 'base').
            %   include (char): Data types to include (e.g., 'days', 'hours').
            %   elements (char): Specific weather elements to retrieve.
            %
            % Returns:
            %   struct: The weather data as a struct.;

            if nargin < 3
                from_date = '';
            end
            if nargin < 4
                to_date = '';
            end
            if nargin < 5
                unit_group = 'us';
            end
            if nargin < 6
                include = 'days';
            end
            if nargin < 7
                elements = '';
            end
            
            params = struct('unitGroup', unit_group, 'include', include, 'key', obj.api_key, 'elements', elements);
            url = sprintf('%s/%s/%s/%s', obj.base_url, location, from_date, to_date);

            paramNames = fieldnames(params);
            paramValues = struct2cell(params);
            paramPairs = [paramNames, paramValues]';
            
            options = weboptions('ContentType', 'json', 'Timeout', 30);
            response = webread(url, paramPairs{:}, options);
            
            obj.weather_data = response;
            weather_data = obj.weather_data;
        end
        
        function weather_data = get_weather_data(obj, elements)
            % Get the stored weather data.
            %
            % Parameters:
            %   elements (cell): List of elements to include in the returned data.
            %
            % Returns:
            %   struct: The weather data as a struct, filtered by elements if specified.
            
            if nargin < 2
                elements = {};
            end
            
            try
                if ~isempty(elements)
                    weather_data = extract_substruct_by_keys(obj.weather_data, elements);
                else
                    weather_data = obj.weather_data;
                end
            catch
                weather_data = struct();
            end
        end
        
        function obj = set_weather_data(obj, data)
            % Set the internal weather data.
            %
            % Parameters:
            %   data (struct): Weather data to store.
            obj.weather_data = data;
        end
        
        function set_weather_daily_data(obj, daily_data)
            % Set the daily weather data.
            %
            % Parameters:
            %   daily_data (cell): Cell array of daily weather data structs.
            obj.weather_data.days = daily_data;
        end
        
        function daily_data = get_weather_daily_data(obj, elements)
            % Get daily weather data, optionally filtered by elements.
            %
            % Parameters:
            %   elements (cell): List of elements to include in the returned data.
            %
            % Returns:
            %   cell: List of daily data structs, filtered by elements if specified.
            
            if nargin < 2
                elements = {};
            end
            
            try
                days = obj.weather_data.days;
                if ~isempty(elements)
                    daily_data = cell(numel(days),1);
                    for i = 1:numel(days)
                        daily_data{i} = extract_substruct_by_keys(days(i), elements);
                    end
                else
                    daily_data = days;
                end
            catch
                daily_data = {};
            end
        end
        
        function hourly_data = get_weather_hourly_data(obj, elements)
            % Get hourly weather data for all days, optionally filtered by elements.
            %
            % Parameters:
            %   elements (cell): List of elements to include in the returned data.
            %
            % Returns:
            %   cell: List of hourly data structs, filtered by elements if specified.
            
            if nargin < 2
                elements = {};
            end
            
            hourly_data = {};
            try
                days = obj.weather_data.days;
                all_hours = [];
                for i = 1:numel(days)
                    if isfield(days(i), 'hours')
                        all_hours = [all_hours, days(i).hours];
                    end
                end
                
                if ~isempty(elements)
                    for i = 1:numel(all_hours)
                        hourly_data{end+1} = extract_substruct_by_keys(all_hours(i), elements);
                    end
                else
                    hourly_data = all_hours;
                end
            catch
                hourly_data = {};
            end
        end
        
        function query_cost = get_queryCost(obj)
            % Retrieves the cost of the query from the weather data.
            %
            % Returns:
            %   double: The cost of the query if available, otherwise empty.
            if isfield(obj.weather_data, 'queryCost')
                query_cost = obj.weather_data.queryCost;
            else
                query_cost = [];
            end
        end
        
        function set_queryCost(obj, value)
            % Sets the cost of the query in the weather data.
            %
            % Parameters:
            %   value (double): The new cost to be set for the query.
            obj.weather_data.queryCost = value;
        end
        
        function latitude = get_latitude(obj)
            % Retrieves the latitude from the weather data.
            %
            % Returns:
            %   double: The latitude if available, otherwise empty.
            if isfield(obj.weather_data, 'latitude')
                latitude = obj.weather_data.latitude;
            else
                latitude = [];
            end
        end
        
        function set_latitude(obj, value)
            % Sets the latitude in the weather data.
            %
            % Parameters:
            %   value (double): The new latitude to be set.
            obj.weather_data.latitude = value;
        end
        
        function longitude = get_longitude(obj)
            % Retrieves the longitude from the weather data.
            %
            % Returns:
            %   double: The longitude if available, otherwise empty.
            if isfield(obj.weather_data, 'longitude')
                longitude = obj.weather_data.longitude;
            else
                longitude = [];
            end
        end
        
        function set_longitude(obj, value)
            % Sets the longitude in the weather data.
            %
            % Parameters:
            %   value (double): The new longitude to be set.
            obj.weather_data.longitude = value;
        end
        
        function resolved_address = get_resolvedAddress(obj)
            % Retrieves the resolved address from the weather data.
            %
            % Returns:
            %   char: The resolved address if available, otherwise empty.
            if isfield(obj.weather_data, 'resolvedAddress')
                resolved_address = obj.weather_data.resolvedAddress;
            else
                resolved_address = '';
            end
        end
        
        function set_resolvedAddress(obj, value)
            % Sets the resolved address in the weather data.
            %
            % Parameters:
            %   value (char): The new resolved address to be set.
            obj.weather_data.resolvedAddress = value;
        end
        
        function address = get_address(obj)
            % Retrieves the address from the weather data.
            %
            % Returns:
            %   char: The address if available, otherwise empty.
            if isfield(obj.weather_data, 'address')
                address = obj.weather_data.address;
            else
                address = '';
            end
        end
        
        function set_address(obj, value)
            % Sets the address in the weather data.
            %
            % Parameters:
            %   value (char): The new address to be set.
            obj.weather_data.address = value;
        end
        
        function timezone = get_timezone(obj)
            % Retrieves the timezone from the weather data.
            %
            % Returns:
            %   char: The timezone if available, otherwise empty.
            if isfield(obj.weather_data, 'timezone')
                timezone = obj.weather_data.timezone;
            else
                timezone = '';
            end
        end
        
        function set_timezone(obj, value)
            % Sets the timezone in the weather data.
            %
            % Parameters:
            %   value (char): The new timezone to be set.
            obj.weather_data.timezone = value;
        end
        
        function tzoffset = get_tzoffset(obj)
            % Retrieves the timezone offset from the weather data.
            %
            % Returns:
            %   double: The timezone offset if available, otherwise empty.
            if isfield(obj.weather_data, 'tzoffset')
                tzoffset = obj.weather_data.tzoffset;
            else
                tzoffset = [];
            end
        end
        
        function set_tzoffset(obj, value)
            % Sets the timezone offset in the weather data.
            %
            % Parameters:
            %   value (double): The new timezone offset to be set.
            obj.weather_data.tzoffset = value;
        end
        
        function stations = get_stations(obj)
            % Retrieves the list of weather stations from the weather data.
            %
            % Returns:
            %   cell: The list of weather stations if available, otherwise an empty cell.
            if isfield(obj.weather_data, 'stations')
                stations = obj.weather_data.stations;
            else
                stations = {};
            end
        end
        
        function set_stations(obj, value)
            % Sets the list of weather stations in the weather data.
            %
            % Parameters:
            %   value (cell): The new list of weather stations to be set.
            obj.weather_data.stations = value;
        end
        
        function daily_datetimes = get_daily_datetimes(obj)
            % Retrieves a list of datetime objects representing each day's date from the weather data.
            %
            % Returns:
            %   cell: A list of datetime objects parsed from the 'datetime' key of each day in the weather data.
            
            daily_datetimes = [];
            try
                days = obj.weather_data.days;
                for i = 1:numel(days)
                    daily_datetimes = [daily_datetimes, datetime(days(i).datetime, 'InputFormat', 'yyyy-MM-dd')];
                end
            catch
                daily_datetimes = [];
            end
        end
        
        function hourly_datetimes = get_hourly_datetimes(obj)
            % Retrieves a list of datetime objects representing each hour's datetime from the weather data.
            %
            % The method combines the 'datetime' from each day with the 'datetime' from each hour within that day.
            %
            % Returns:
            %   cell: A list of datetime objects parsed from the 'datetime' keys of each day and hour in the weather data.
            
            hourly_datetimes = [];
            try
                days = obj.weather_data.days;
                for i = 1:numel(days)
                    day_datetime = datetime(days(i).datetime, 'InputFormat', 'yyyy-MM-dd');
                    hours = days(i).hours;
                    for j = 1:numel(hours)
                        hour_datetime = datetime(hours(j).datetime, 'InputFormat', 'HH:mm:ss');
                        combined_datetime = datetime([day_datetime, hour_datetime], 'Format', 'yyyy-MM-dd HH:mm:ss');
                        hourly_datetimes = [hourly_datetimes, combined_datetime];
                    end
                end
            catch
                hourly_datetimes = [];
            end
        end
   
        function day_data = get_data_on_day(obj, day_info, elements)
            % Retrieves weather data for a specific day based on a date string or index.
            %
            % Parameters:
            %   day_info (char|int): The identifier for the day, which can be a date string (YYYY-MM-DD) or an index of the day list.
            %   elements (cell): Specific weather elements to retrieve.
            %
            % Returns:
            %   struct: The weather data struct for the specified day.
            
            try
                if ischar(day_info)
                    day_data = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            day_data = obj.weather_data.days(i);
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    day_data = obj.weather_data.days{day_info};
                else
                    error('Invalid input value for get_data_on_day: %s', day_info);
                end
                
                if ~isempty(elements)
                    day_data = extract_substruct_by_keys(day_data, elements);
                end
            catch e
                disp(['Error accessing data on this day: ', e.message]);
                day_data = [];
            end
        end
        
        function set_data_on_day(obj, day_info, data)
            % Updates weather data for a specific day based on a date string or index.
            %
            % Parameters:
            %   day_info (char|int): The identifier for the day, which can be a date string (YYYY-MM-DD) or an index of the day list.
            %   data (struct): The new weather data struct to replace the existing day's data.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i) = data;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info} = data;
                else
                    error('Invalid input day value for set_data_on_day: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function temp = get_temp_on_day(obj, day_info)
            % Retrieves the temperature for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The temperature for the specified day.
            
            try
                if ischar(day_info)
                    temp = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            temp = obj.weather_data.days(i).temp;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    temp = obj.weather_data.days{day_info}.temp;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing temperature data: ', e.message]);
                temp = [];
            end
        end
        
        function set_temp_on_day(obj, day_info, value)
            % Sets the temperature for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new temperature value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).temp = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.temp = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function tempmax = get_tempmax_on_day(obj, day_info)
            % Retrieves the maximum temperature for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The maximum temperature for the specified day.
            
            try
                if ischar(day_info)
                    tempmax = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            tempmax = obj.weather_data.days(i).tempmax;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    tempmax = obj.weather_data.days{day_info}.tempmax;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing maximum temperature data: ', e.message]);
                tempmax = [];
            end
        end
        
        function set_tempmax_on_day(obj, day_info, value)
            % Sets the maximum temperature for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new maximum temperature value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).tempmax = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.tempmax = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function tempmin = get_tempmin_on_day(obj, day_info)
            % Retrieves the minimum temperature for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The minimum temperature for the specified day.
            
            try
                if ischar(day_info)
                    tempmin = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            tempmin = obj.weather_data.days(i).tempmin;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    tempmin = obj.weather_data.days{day_info}.tempmin;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing minimum temperature data: ', e.message]);
                tempmin = [];
            end
        end
        
        function set_tempmin_on_day(obj, day_info, value)
            % Sets the minimum temperature for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new minimum temperature value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).tempmin = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.tempmin = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function feelslike = get_feelslike_on_day(obj, day_info)
            % Retrieves the 'feels like' temperature for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The 'feels like' temperature for the specified day.
            
            try
                if ischar(day_info)
                    feelslike = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            feelslike = obj.weather_data.days(i).feelslike;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    feelslike = obj.weather_data.days{day_info}.feelslike;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing "feels like" temperature data: ', e.message]);
                feelslike = [];
            end
        end
        
        function set_feelslike_on_day(obj, day_info, value)
            % Sets the 'feels like' temperature for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new 'feels like' temperature value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).feelslike = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.feelslike = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function feelslikemax = get_feelslikemax_on_day(obj, day_info)
            % Retrieves the maximum 'feels like' temperature for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The maximum 'feels like' temperature for the specified day.
            
            try
                if ischar(day_info)
                    feelslikemax = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            feelslikemax = obj.weather_data.days(i).feelslikemax;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    feelslikemax = obj.weather_data.days{day_info}.feelslikemax;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing "feels like max" temperature data: ', e.message]);
                feelslikemax = [];
            end
        end
        
        function set_feelslikemax_on_day(obj, day_info, value)
            % Sets the maximum 'feels like' temperature for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new maximum 'feels like' temperature value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).feelslikemax = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.feelslikemax = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function feelslikemin = get_feelslikemin_on_day(obj, day_info)
            % Retrieves the minimum 'feels like' temperature for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The minimum 'feels like' temperature for the specified day.
            
            try
                if ischar(day_info)
                    feelslikemin = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            feelslikemin = obj.weather_data.days(i).feelslikemin;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    feelslikemin = obj.weather_data.days{day_info}.feelslikemin;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing "feels like min" temperature data: ', e.message]);
                feelslikemin = [];
            end
        end
        
        function set_feelslikemin_on_day(obj, day_info, value)
            % Sets the minimum 'feels like' temperature for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new minimum 'feels like' temperature value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).feelslikemin = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.feelslikemin = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function dew = get_dew_on_day(obj, day_info)
            % Retrieves the dew point for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The dew point for the specified day.
            
            try
                if ischar(day_info)
                    dew = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            dew = obj.weather_data.days(i).dew;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    dew = obj.weather_data.days{day_info}.dew;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing dew point data: ', e.message]);
                dew = [];
            end
        end
        
        function set_dew_on_day(obj, day_info, value)
            % Sets the dew point for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new dew point value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).dew = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.dew = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function humidity = get_humidity_on_day(obj, day_info)
            % Retrieves the humidity percentage for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The humidity percentage for the specified day.
            
            try
                if ischar(day_info)
                    humidity = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            humidity = obj.weather_data.days(i).humidity;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    humidity = obj.weather_data.days{day_info}.humidity;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing humidity data: ', e.message]);
                humidity = [];
            end
        end
        
        function set_humidity_on_day(obj, day_info, value)
            % Sets the humidity percentage for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new humidity percentage value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).humidity = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.humidity = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function precip = get_precip_on_day(obj, day_info)
            % Retrieves the precipitation amount for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The precipitation amount for the specified day.
            
            try
                if ischar(day_info)
                    precip = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            precip = obj.weather_data.days(i).precip;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    precip = obj.weather_data.days{day_info}.precip;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing precipitation data: ', e.message]);
                precip = [];
            end
        end
        
        function set_precip_on_day(obj, day_info, value)
            % Sets the precipitation amount for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new precipitation amount value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).precip = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.precip = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function precipprob = get_precipprob_on_day(obj, day_info)
            % Retrieves the probability of precipitation for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The probability of precipitation for the specified day.
            
            try
                if ischar(day_info)
                    precipprob = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            precipprob = obj.weather_data.days(i).precipprob;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    precipprob = obj.weather_data.days{day_info}.precipprob;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing precipitation probability data: ', e.message]);
                precipprob = [];
            end
        end
        
        function set_precipprob_on_day(obj, day_info, value)
            % Sets the probability of precipitation for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new probability of precipitation value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).precipprob = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.precipprob = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function precipcover = get_precipcover_on_day(obj, day_info)
            % Retrieves the precipitation coverage for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The precipitation coverage for the specified day.
            
            try
                if ischar(day_info)
                    precipcover = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            precipcover = obj.weather_data.days(i).precipcover;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    precipcover = obj.weather_data.days{day_info}.precipcover;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing precipitation coverage data: ', e.message]);
                precipcover = [];
            end
        end
        
        function set_precipcover_on_day(obj, day_info, value)
            % Sets the precipitation coverage for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new precipitation coverage value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).precipcover = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.precipcover = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function preciptype = get_preciptype_on_day(obj, day_info)
            % Retrieves the type of precipitation for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   char: The type of precipitation for the specified day.
            
            try
                if ischar(day_info)
                    preciptype = '';
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            preciptype = obj.weather_data.days(i).preciptype;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    preciptype = obj.weather_data.days{day_info}.preciptype;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing precipitation type data: ', e.message]);
                preciptype = '';
            end
        end
        
        function set_preciptype_on_day(obj, day_info, value)
            % Sets the type of precipitation for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (char): The new type of precipitation value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).preciptype = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.preciptype = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function snow = get_snow_on_day(obj, day_info)
            % Retrieves the snowfall amount for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The snowfall amount for the specified day.
            
            try
                if ischar(day_info)
                    snow = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            snow = obj.weather_data.days(i).snow;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    snow = obj.weather_data.days{day_info}.snow;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing snow data: ', e.message]);
                snow = [];
            end
        end
        
        function set_snow_on_day(obj, day_info, value)
            % Sets the snowfall amount for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new snowfall amount to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).snow = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.snow = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end


        function snowdepth = get_snowdepth_on_day(obj, day_info)
            % Retrieves the snow depth for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The snow depth for the specified day.
            
            try
                if ischar(day_info)
                    snowdepth = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            snowdepth = obj.weather_data.days(i).snowdepth;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    snowdepth = obj.weather_data.days{day_info}.snowdepth;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing snow depth data: ', e.message]);
                snowdepth = [];
            end
        end
        
        function set_snowdepth_on_day(obj, day_info, value)
            % Sets the snow depth for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new snow depth value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).snowdepth = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.snowdepth = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function windgust = get_windgust_on_day(obj, day_info)
            % Retrieves the wind gust value for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The wind gust value for the specified day.
            
            try
                if ischar(day_info)
                    windgust = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            windgust = obj.weather_data.days(i).windgust;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    windgust = obj.weather_data.days{day_info}.windgust;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing wind gust data: ', e.message]);
                windgust = [];
            end
        end
        
        function set_windgust_on_day(obj, day_info, value)
            % Sets the wind gust value for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new wind gust value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).windgust = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.windgust = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function windspeed = get_windspeed_on_day(obj, day_info)
            % Retrieves the wind speed for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The wind speed for the specified day.
            
            try
                if ischar(day_info)
                    windspeed = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            windspeed = obj.weather_data.days(i).windspeed;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    windspeed = obj.weather_data.days{day_info}.windspeed;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing wind speed data: ', e.message]);
                windspeed = [];
            end
        end
        
        function set_windspeed_on_day(obj, day_info, value)
            % Sets the wind speed for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new wind speed value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).windspeed = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.windspeed = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function winddir = get_winddir_on_day(obj, day_info)
            % Retrieves the wind direction for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The wind direction for the specified day.
            
            try
                if ischar(day_info)
                    winddir = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            winddir = obj.weather_data.days(i).winddir;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    winddir = obj.weather_data.days{day_info}.winddir;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing wind direction data: ', e.message]);
                winddir = [];
            end
        end
        
        function set_winddir_on_day(obj, day_info, value)
            % Sets the wind direction for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new wind direction value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).winddir = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.winddir = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function pressure = get_pressure_on_day(obj, day_info)
            % Retrieves the atmospheric pressure for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The atmospheric pressure for the specified day.
            
            try
                if ischar(day_info)
                    pressure = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            pressure = obj.weather_data.days(i).pressure;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    pressure = obj.weather_data.days{day_info}.pressure;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing pressure data: ', e.message]);
                pressure = [];
            end
        end
        
        function set_pressure_on_day(obj, day_info, value)
            % Sets the atmospheric pressure for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new pressure value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).pressure = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.pressure = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function cloudcover = get_cloudcover_on_day(obj, day_info)
            % Retrieves the cloud cover percentage for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The cloud cover percentage for the specified day.
            
            try
                if ischar(day_info)
                    cloudcover = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            cloudcover = obj.weather_data.days(i).cloudcover;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    cloudcover = obj.weather_data.days{day_info}.cloudcover;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing cloud cover data: ', e.message]);
                cloudcover = [];
            end
        end
        
        function set_cloudcover_on_day(obj, day_info, value)
            % Sets the cloud cover percentage for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new cloud cover percentage value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).cloudcover = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.cloudcover = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function visibility = get_visibility_on_day(obj, day_info)
            % Retrieves the visibility distance for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The visibility distance for the specified day.
            
            try
                if ischar(day_info)
                    visibility = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            visibility = obj.weather_data.days(i).visibility;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    visibility = obj.weather_data.days{day_info}.visibility;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing visibility data: ', e.message]);
                visibility = [];
            end
        end
        
        function set_visibility_on_day(obj, day_info, value)
            % Sets the visibility distance for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new visibility distance to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).visibility = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.visibility = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function solarradiation = get_solarradiation_on_day(obj, day_info)
            % Retrieves the solar radiation level for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The solar radiation level for the specified day.
            
            try
                if ischar(day_info)
                    solarradiation = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            solarradiation = obj.weather_data.days(i).solarradiation;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    solarradiation = obj.weather_data.days{day_info}.solarradiation;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing solar radiation data: ', e.message]);
                solarradiation = [];
            end
        end
        
        function set_solarradiation_on_day(obj, day_info, value)
            % Sets the solar radiation level for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new solar radiation level to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).solarradiation = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.solarradiation = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end

        
        function solarenergy = get_solarenergy_on_day(obj, day_info)
            % Retrieves the solar energy generated on a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The solar energy generated on the specified day.
            
            try
                if ischar(day_info)
                    solarenergy = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            solarenergy = obj.weather_data.days(i).solarenergy;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    solarenergy = obj.weather_data.days{day_info}.solarenergy;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing solar energy data: ', e.message]);
                solarenergy = [];
            end
        end
        
        function set_solarenergy_on_day(obj, day_info, value)
            % Sets the solar energy level for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new solar energy level to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).solarenergy = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.solarenergy = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function uvindex = get_uvindex_on_day(obj, day_info)
            % Retrieves the UV index for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The UV index for the specified day.
            
            try
                if ischar(day_info)
                    uvindex = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            uvindex = obj.weather_data.days(i).uvindex;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    uvindex = obj.weather_data.days{day_info}.uvindex;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing UV index data: ', e.message]);
                uvindex = [];
            end
        end
        
        function set_uvindex_on_day(obj, day_info, value)
            % Sets the UV index for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new UV index value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).uvindex = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.uvindex = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function severerisk = get_severerisk_on_day(obj, day_info)
            % Retrieves the severe weather risk level for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The severe weather risk level for the specified day.
            
            try
                if ischar(day_info)
                    severerisk = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            severerisk = obj.weather_data.days(i).severerisk;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    severerisk = obj.weather_data.days{day_info}.severerisk;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing severe risk data: ', e.message]);
                severerisk = [];
            end
        end
        
        function set_severerisk_on_day(obj, day_info, value)
            % Sets the severe weather risk level for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new severe weather risk level to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).severerisk = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.severerisk = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function sunrise = get_sunrise_on_day(obj, day_info)
            % Retrieves the sunrise time for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   char: The sunrise time for the specified day.
            
            try
                if ischar(day_info)
                    sunrise = '';
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            sunrise = obj.weather_data.days(i).sunrise;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    sunrise = obj.weather_data.days{day_info}.sunrise;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing sunrise data: ', e.message]);
                sunrise = '';
            end
        end
        
        function set_sunrise_on_day(obj, day_info, value)
            % Sets the sunrise time for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (char): The new sunrise time value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).sunrise = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.sunrise = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function sunriseEpoch = get_sunriseEpoch_on_day(obj, day_info)
            % Retrieves the Unix timestamp for the sunrise time for a specific day.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The sunrise Unix timestamp for the specified day.
            
            try
                if ischar(day_info)
                    sunriseEpoch = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            sunriseEpoch = obj.weather_data.days(i).sunriseEpoch;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    sunriseEpoch = obj.weather_data.days{day_info}.sunriseEpoch;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing sunrise epoch data: ', e.message]);
                sunriseEpoch = [];
            end
        end
        
        function set_sunriseEpoch_on_day(obj, day_info, value)
            % Sets the Unix timestamp for the sunrise time for a specific day.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new sunrise Unix timestamp value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).sunriseEpoch = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.sunriseEpoch = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function sunset = get_sunset_on_day(obj, day_info)
            % Retrieves the sunset time for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   char: The sunset time for the specified day.
            
            try
                if ischar(day_info)
                    sunset = '';
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            sunset = obj.weather_data.days(i).sunset;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    sunset = obj.weather_data.days{day_info}.sunset;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing sunset data: ', e.message]);
                sunset = '';
            end
        end
        
        function set_sunset_on_day(obj, day_info, value)
            % Sets the sunset time for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (char): The new sunset time value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).sunset = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.sunset = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function sunsetEpoch = get_sunsetEpoch_on_day(obj, day_info)
            % Retrieves the Unix timestamp for the sunset time for a specific day.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The sunset Unix timestamp for the specified day.
            
            try
                if ischar(day_info)
                    sunsetEpoch = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            sunsetEpoch = obj.weather_data.days(i).sunsetEpoch;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    sunsetEpoch = obj.weather_data.days{day_info}.sunsetEpoch;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing sunset epoch data: ', e.message]);
                sunsetEpoch = [];
            end
        end
        
        function set_sunsetEpoch_on_day(obj, day_info, value)
            % Sets the Unix timestamp for the sunset time for a specific day.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new sunset Unix timestamp value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).sunsetEpoch = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.sunsetEpoch = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function moonphase = get_moonphase_on_day(obj, day_info)
            % Retrieves the moon phase for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   double: The moon phase for the specified day.
            
            try
                if ischar(day_info)
                    moonphase = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            moonphase = obj.weather_data.days(i).moonphase;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    moonphase = obj.weather_data.days{day_info}.moonphase;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing moon phase data: ', e.message]);
                moonphase = [];
            end
        end
        
        function set_moonphase_on_day(obj, day_info, value)
            % Sets the moon phase for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (double): The new moon phase value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).moonphase = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.moonphase = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function conditions = get_conditions_on_day(obj, day_info)
            % Retrieves the weather conditions for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   char: The weather conditions for the specified day.
            
            try
                if ischar(day_info)
                    conditions = '';
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            conditions = obj.weather_data.days(i).conditions;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    conditions = obj.weather_data.days{day_info}.conditions;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing conditions data: ', e.message]);
                conditions = '';
            end
        end
        
        function set_conditions_on_day(obj, day_info, value)
            % Sets the weather conditions for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (char): The new conditions value to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).conditions = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.conditions = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function description = get_description_on_day(obj, day_info)
            % Retrieves the weather description for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   char: The weather description for the specified day.
            
            try
                if ischar(day_info)
                    description = '';
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            description = obj.weather_data.days(i).description;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    description = obj.weather_data.days{day_info}.description;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing description data: ', e.message]);
                description = '';
            end
        end
        
        function set_description_on_day(obj, day_info, value)
            % Sets the weather description for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (char): The new description to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).description = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.description = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function icon = get_icon_on_day(obj, day_info)
            % Retrieves the weather icon for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   char: The weather icon for the specified day.
            
            try
                if ischar(day_info)
                    icon = '';
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            icon = obj.weather_data.days(i).icon;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    icon = obj.weather_data.days{day_info}.icon;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing icon data: ', e.message]);
                icon = '';
            end
        end
        
        function set_icon_on_day(obj, day_info, value)
            % Sets the weather icon for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (char): The new icon to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).icon = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.icon = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function stations = get_stations_on_day(obj, day_info)
            % Retrieves the weather stations data for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %
            % Returns:
            %   cell: The list of weather stations active on the specified day.
            
            try
                if ischar(day_info)
                    stations = {};
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            stations = obj.weather_data.days(i).stations;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    stations = obj.weather_data.days{day_info}.stations;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                disp(['Error accessing stations data: ', e.message]);
                stations = {};
            end
        end
        
        function set_stations_on_day(obj, day_info, value)
            % Sets the weather stations data for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   value (cell): The new list of weather stations to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).stations = value;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.stations = value;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end
        
        function hourlyData = get_hourlyData_on_day(obj, day_info, elements)
            % Retrieves hourly weather data for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   elements (cell): Optional list of keys to filter the hourly data.
            %
            % Returns:
            %   cell: A list of hourly data dictionaries for the specified day.
            
            if nargin < 3
                elements = {};
            end
            
            try
                if ischar(day_info)
                    hourly_data = [];
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            hourly_data = obj.weather_data.days(i).hours;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    hourly_data = obj.weather_data.days{day_info}.hours;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
                
                if ~isempty(elements)
                    hourlyData = cell(size(hourly_data));
                    for i = 1:numel(hourly_data)
                        hourlyData{i} = extract_substruct_by_keys(hourly_data{i}, elements);
                    end
                else
                    hourlyData = hourly_data;
                end
            catch e
                disp(['Error accessing hourly data: ', e.message]);
                hourlyData = [];
            end
        end
        
        function set_hourlyData_on_day(obj, day_info, data)
            % Sets the hourly weather data for a specific day identified by date or index.
            %
            % Parameters:
            %   day_info (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            %   data (cell): The new list of hourly weather data dictionaries to set.
            
            try
                if ischar(day_info)
                    for i = 1:numel(obj.weather_data.days)
                        if strcmp(obj.weather_data.days(i).datetime, day_info)
                            obj.weather_data.days(i).hours = data;
                            break;
                        end
                    end
                elseif isnumeric(day_info) && isscalar(day_info)
                    obj.weather_data.days{day_info}.hours = data;
                else
                    error('Invalid input value for day_info: %s', day_info);
                end
            catch e
                rethrow(e);
            end
        end

        function data = get_data_at_datetime(obj, day_info, time_info, elements)
            % Retrieves weather data for a specific date and time from the weather data collection.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   elements (cell): Specific weather elements to retrieve.
            %
            % Returns:
            %   struct: The specific hourly data dictionary corresponding to the given day and time.
            
            if nargin < 4
                elements = {};
            end

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                data = obj.weather_data.days(day_idx).hours(time_idx);
                if ~isempty(elements)
                    data = extract_substruct_by_keys(data, elements);
                end
            catch ME
                rethrow(ME);
            end
        end

        function set_data_at_datetime(obj, day_info, time_info, data)
            % Sets weather data for a specific date and time in the weather data collection.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   data (struct): The data struct to be set for the specific hourly time slot.
            
            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours = Weather.set_item_by_datetimeIdx(obj.weather_data.days(day_idx).hours, time_idx, data);
            catch ME
                rethrow(ME);
            end
        end
        
        function update_data_at_datetime(obj, day_info, time_info, data)
            % Updates weather data for a specific date and time in the weather data collection.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   data (struct): The data struct to be updated for the specific hourly time slot.
            
            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                obj.weather_data.days(day_idx).hours = Weather.update_item_by_datetimeIdx(obj.weather_data.days(day_idx).hours, time_info, data);
            catch ME
                rethrow(ME);
            end
        end
        
        function datetimeEpoch = get_datetimeEpoch_at_datetime(obj, day_info, time_info)
            % Retrieves the epoch time for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   int: The epoch time corresponding to the specific day and time.
            
            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                datetimeEpoch = obj.weather_data.days(day_idx).hours(time_idx).datetimeEpoch;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end
        
        function set_datetimeEpoch_at_datetime(obj, day_info, time_info, value)
            % Sets the epoch time for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (int): The epoch time value to be set.
            
            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).datetimeEpoch = value;
            catch ME
                rethrow(ME);
            end
        end
        
        function temp = get_temp_at_datetime(obj, day_info, time_info)
            % Retrieves the temperature for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   float: The temperature at the specified datetime.
            
            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                temp = obj.weather_data.days(day_idx).hours(time_idx).temp;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end
        
        function set_temp_at_datetime(obj, day_info, time_info, value)
            % Sets the temperature for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (float): The temperature value to be set.
            
            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).temp = value;
            catch ME
                rethrow(ME);
            end
        end

        function feelslike = get_feelslike_at_datetime(obj, day_info, time_info)
            % Retrieves the 'feels like' temperature for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   float: The 'feels like' temperature at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                feelslike = obj.weather_data.days(day_idx).hours(time_idx).feelslike;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_feelslike_at_datetime(obj, day_info, time_info, value)
            % Sets the 'feels like' temperature for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (float): The 'feels like' temperature value to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).feelslike = value;
            catch ME
                rethrow(ME);
            end
        end

        function humidity = get_humidity_at_datetime(obj, day_info, time_info)
            % Retrieves the humidity for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   float: The humidity percentage at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                humidity = obj.weather_data.days(day_idx).hours(time_idx).humidity;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_humidity_at_datetime(obj, day_info, time_info, value)
            % Sets the humidity for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (float): The humidity percentage to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).humidity = value;
            catch ME
                rethrow(ME);
            end
        end

        function dew = get_dew_at_datetime(obj, day_info, time_info)
            % Retrieves the dew point temperature for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   float: The dew point temperature at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                dew = obj.weather_data.days(day_idx).hours(time_idx).dew;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_dew_at_datetime(obj, day_info, time_info, value)
            % Sets the dew point temperature for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (float): The dew point temperature to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).dew = value;
            catch ME
                rethrow(ME);
            end
        end

        function precip = get_precip_at_datetime(obj, day_info, time_info)
            % Retrieves the precipitation amount for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   float: The precipitation amount at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                precip = obj.weather_data.days(day_idx).hours(time_idx).precip;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_precip_at_datetime(obj, day_info, time_info, value)
            % Sets the precipitation amount for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (float): The precipitation amount to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).precip = value;
            catch ME
                rethrow(ME);
            end
        end

        function precipprob = get_precipprob_at_datetime(obj, day_info, time_info)
            % Retrieves the probability of precipitation for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   float: The probability of precipitation at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                precipprob = obj.weather_data.days(day_idx).hours(time_idx).precipprob;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_precipprob_at_datetime(obj, day_info, time_info, value)
            % Sets the probability of precipitation for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (float): The probability of precipitation to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).precipprob = value;
            catch ME
                rethrow(ME);
            end
        end

        function snow = get_snow_at_datetime(obj, day_info, time_info)
            % Retrieves the snow amount for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   float: The snow amount at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                snow = obj.weather_data.days(day_idx).hours(time_idx).snow;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_snow_at_datetime(obj, day_info, time_info, value)
            % Sets the snow amount for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (float): The snow amount to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).snow = value;
            catch ME
                rethrow(ME);
            end
        end

        function snowdepth = get_snowdepth_at_datetime(obj, day_info, time_info)
            % Retrieves the snow depth for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   float: The snow depth at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                snowdepth = obj.weather_data.days(day_idx).hours(time_idx).snowdepth;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_snowdepth_at_datetime(obj, day_info, time_info, value)
            % Sets the snow depth for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (float): The snow depth to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).snowdepth = value;
            catch ME
                rethrow(ME);
            end
        end

        function preciptype = get_preciptype_at_datetime(obj, day_info, time_info)
            % Retrieves the type of precipitation for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   str: The type of precipitation at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                preciptype = obj.weather_data.days(day_idx).hours(time_idx).preciptype;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_preciptype_at_datetime(obj, day_info, time_info, value)
            % Sets the type of precipitation for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (str): The type of precipitation to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).preciptype = value;
            catch ME
                rethrow(ME);
            end
        end

        function windgust = get_windgust_at_datetime(obj, day_info, time_info)
            % Retrieves the wind gust speed for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   float: The wind gust speed at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                windgust = obj.weather_data.days(day_idx).hours(time_idx).windgust;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_windgust_at_datetime(obj, day_info, time_info, value)
            % Sets the wind gust speed for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (float): The wind gust speed to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).windgust = value;
            catch ME
                rethrow(ME);
            end
        end

        function windspeed = get_windspeed_at_datetime(obj, day_info, time_info)
            % Retrieves the wind speed for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   float: The wind speed at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                windspeed = obj.weather_data.days(day_idx).hours(time_idx).windspeed;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_windspeed_at_datetime(obj, day_info, time_info, value)
            % Sets the wind speed for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (float): The wind speed to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).windspeed = value;
            catch ME
                rethrow(ME);
            end
        end

        function winddir = get_winddir_at_datetime(obj, day_info, time_info)
            % Retrieves the wind direction for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   float: The wind direction at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                winddir = obj.weather_data.days(day_idx).hours(time_idx).winddir;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_winddir_at_datetime(obj, day_info, time_info, value)
            % Sets the wind direction for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (float): The wind direction to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).winddir = value;
            catch ME
                rethrow(ME);
            end
        end

        function pressure = get_pressure_at_datetime(obj, day_info, time_info)
            % Retrieves the atmospheric pressure for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   float: The atmospheric pressure at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                pressure = obj.weather_data.days(day_idx).hours(time_idx).pressure;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_pressure_at_datetime(obj, day_info, time_info, value)
            % Sets the atmospheric pressure for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (float): The atmospheric pressure to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).pressure = value;
            catch ME
                rethrow(ME);
            end
        end

        function visibility = get_visibility_at_datetime(obj, day_info, time_info)
            % Retrieves the visibility for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   float: The visibility at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                visibility = obj.weather_data.days(day_idx).hours(time_idx).visibility;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_visibility_at_datetime(obj, day_info, time_info, value)
            % Sets the visibility for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (float): The visibility to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).visibility = value;
            catch ME
                rethrow(ME);
            end
        end

        function cloudcover = get_cloudcover_at_datetime(obj, day_info, time_info)
            % Retrieves the cloud cover for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   float: The cloud cover at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                cloudcover = obj.weather_data.days(day_idx).hours(time_idx).cloudcover;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_cloudcover_at_datetime(obj, day_info, time_info, value)
            % Sets the cloud cover for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (float): The cloud cover to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).cloudcover = value;
            catch ME
                rethrow(ME);
            end
        end

        function solarradiation = get_solarradiation_at_datetime(obj, day_info, time_info)
            % Retrieves the solar radiation for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   float: The solar radiation at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                solarradiation = obj.weather_data.days(day_idx).hours(time_idx).solarradiation;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_solarradiation_at_datetime(obj, day_info, time_info, value)
            % Sets the solar radiation for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (float): The solar radiation to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).solarradiation = value;
            catch ME
                rethrow(ME);
            end
        end

        function solarenergy = get_solarenergy_at_datetime(obj, day_info, time_info)
            % Retrieves the solar energy for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   float: The solar energy at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                solarenergy = obj.weather_data.days(day_idx).hours(time_idx).solarenergy;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_solarenergy_at_datetime(obj, day_info, time_info, value)
            % Sets the solar energy for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (float): The solar energy to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).solarenergy = value;
            catch ME
                rethrow(ME);
            end
        end

        function uvindex = get_uvindex_at_datetime(obj, day_info, time_info)
            % Retrieves the UV index for a specific datetime within the weather data.
            % UV index: A value between 0 and 10 indicating the level of ultra violet (UV) exposure for that hour or day
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   float: The UV index at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                uvindex = obj.weather_data.days(day_idx).hours(time_idx).uvindex;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_uvindex_at_datetime(obj, day_info, time_info, value)
            % Sets the UV index for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (float): The UV index to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).uvindex = value;
            catch ME
                rethrow(ME);
            end
        end

        function severerisk = get_severerisk_at_datetime(obj, day_info, time_info)
            % Retrieves the severe risk for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   float: The severe risk at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                severerisk = obj.weather_data.days(day_idx).hours(time_idx).severerisk;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_severerisk_at_datetime(obj, day_info, time_info, value)
            % Sets the severe risk for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (float): The severe risk to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).severerisk = value;
            catch ME
                rethrow(ME);
            end
        end

        function conditions = get_conditions_at_datetime(obj, day_info, time_info)
            % Retrieves the conditions for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   string: The conditions at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                conditions = obj.weather_data.days(day_idx).hours(time_idx).conditions;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_conditions_at_datetime(obj, day_info, time_info, value)
            % Sets the conditions for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (string): The conditions to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).conditions = value;
            catch ME
                rethrow(ME);
            end
        end

        function icon = get_icon_at_datetime(obj, day_info, time_info)
            % Retrieves the weather icon for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   string: The weather icon at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                icon = obj.weather_data.days(day_idx).hours(time_idx).icon;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_icon_at_datetime(obj, day_info, time_info, value)
            % Sets the weather icon for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (string): The weather icon to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).icon = value;
            catch ME
                rethrow(ME);
            end
        end

        function stations = get_stations_at_datetime(obj, day_info, time_info)
            % Retrieves the weather stations that were used for creating the observation for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   cell array of strings: The weather stations that were used for creating the observation at the specified datetime.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                stations = obj.weather_data.days(day_idx).hours(time_idx).stations;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_stations_at_datetime(obj, day_info, time_info, value)
            % Sets the weather stations that were used for creating the observation for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (cell array of strings): The weather stations to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).stations = value;
            catch ME
                rethrow(ME);
            end
        end

        function source = get_source_at_datetime(obj, day_info, time_info)
            % Retrieves the type of weather data used for this weather object for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %
            % Returns:
            %   string: The type of weather data used for this weather object at the specified datetime.
            %   (Values include historical observation (“obs”), forecast (“fcst”), historical forecast (“histfcst”) or statistical forecast (“stats”).
            %   If multiple types are used in the same day, “comb” is used. Today a combination of historical observations and forecast data.)

            try
               day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                source = obj.weather_data.days(day_idx).hours(time_idx).source;
            catch ME
                disp(['An exception occurred: ', ME.identifier, ' -> ', ME.message]);
            end
        end

        function set_source_at_datetime(obj, day_info, time_info, value)
            % Sets the type of weather data used for this weather object for a specific datetime within the weather data.
            %
            % Parameters:
            %   day_info (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
            %   time_info (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
            %   value (string): The type of weather data to be set.

            try
                day_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days, day_info);
                time_idx = Weather.get_idx_from_datetimeArg(obj.weather_data.days(day_idx).hours, time_info);
                obj.weather_data.days(day_idx).hours(time_idx).source = value;
            catch ME
                rethrow(ME);
            end
        end

        function clear_weather_data(obj)
            % Clears all weather data stored in the object.
            obj.weather_data = struct();
        end
    end
end
