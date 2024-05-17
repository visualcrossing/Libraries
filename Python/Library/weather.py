import requests
from datetime import datetime

from .utils import extract_subdict_by_keys
from .constants import *

# Class to interact with the Visual Crossing Weather API
class Weather:
    """
    A class to fetch and manipulate weather data using the Visual Crossing Weather API.

    Attributes:
        base_url (str): Base URL of the API.
        api_key (str): API key for accessing the API.
        __weather_data (dict): Internal storage for weather data.
    """
    
    def __init__(self, base_url=BASE_URL, api_key=''):
        """
        Initialize the Weather object with base URL and API key.

        Parameters:
            base_url (str): Base URL of the weather API.
            api_key (str): API key for the weather API.
        """
        self.base_url = base_url
        self.api_key = api_key
        self.__weather_data = {}

    def fetch_weather_data(self, location, from_date='', to_date='', unit_group='us', include='days', elements=''):
        """
        Fetch weather data for a specified location and date range.

        If the unit_group is not specified, it will fetch the data based on US system.
        If only location paramter is given, it will fetch the next 15 days forecasting weather data

        Parameters:
            location (str): Location for which weather data is requested.
            from_date (str): Start date of the weather data period (in `yyyy-MM-dd` format).
            to_date (str): End date of the weather data period (in `yyyy-MM-dd` format).
            unit_group (str): Unit system for the weather data ('us', 'metric', 'uk' or 'base').
            include (str): Data types to include (e.g., 'days', 'hours').
            elements (str): Specific weather elements to retrieve.

        Returns:
            dict: The weather data as a dictionary.
        """
        params = {
            'unitGroup': unit_group,
            'include': include,
            'key': self.api_key,
            'elements': elements
        }
        response = requests.get(f"{self.base_url}/{location}/{from_date}/{to_date}", params=params)
        response.raise_for_status()  # Will raise an exception for HTTP error codes
        self.__weather_data = response.json()
        return self.__weather_data

    def get_weather_data(self, elements=[]):
        """
        Get the stored weather data.

        Parameters:
            elements (list): List of elements to include in the returned data.

        Returns:
            dict: The weather data as a dictionary, filtered by elements if specified.
        """
        try:
            if elements:
                return extract_subdict_by_keys(self.__weather_data, elements)
            else:
                return self.__weather_data
        except Exception as e:
            return None

    def set_weather_data(self, data):
        """
        Set the internal weather data.

        Parameters:
            data (dict): Weather data to store.
        """
        self.__weather_data = data

    def get_weather_daily_data(self, elements=[]):
        """
        Get daily weather data, optionally filtered by elements.

        Parameters:
            elements (list): List of elements to include in the returned data.

        Returns:
            list: List of daily data dictionaries, filtered by elements if specified.
        """
        try:
            if elements:
                return [extract_subdict_by_keys(day, elements) for day in self.__weather_data.get('days', [])]
            else:
                return self.__weather_data.get('days', [])
        except Exception as e:
            return None

    def set_weather_daily_data(self, daily_data):
        """
        Set the daily weather data.

        Parameters:
            daily_data (list): List of daily weather data dictionaries.
        """
        self.__weather_data['days'] = daily_data

    def get_weather_hourly_data(self, elements=[]):
        """
        Get hourly weather data for all days, optionally filtered by elements.

        Parameters:
            elements (list): List of elements to include in the returned data.

        Returns:
            list: List of hourly data dictionaries, filtered by elements if specified.
        """
        try:
            hourly_data = [item for day in self.__weather_data.get('days', []) for item in day.get('hours', [])]   
            if elements:
                return [extract_subdict_by_keys(hour_dt, elements) for hour_dt in hourly_data]
            else:
                return hourly_data
        except:
            return None
    

    def get_queryCost(self):
        """
        Retrieves the cost of the query from the weather data.

        Returns:
        float: The cost of the query if available, otherwise None.
        """
        return self.__weather_data.get('queryCost', None)
    
    def set_queryCost(self, value):
        """
        Sets the cost of the query in the weather data.

        Parameters:
        value (float): The new cost to be set for the query.
        """
        self.__weather_data['queryCost'] = value
    
    def get_latitude(self):
        """
        Retrieves the latitude from the weather data.

        Returns:
        float: The latitude if available, otherwise None.
        """
        return self.__weather_data.get('latitude', None)
    
    def set_latitude(self, value):
        """
        Sets the latitude in the weather data.

        Parameters:
        value (float): The new latitude to be set.
        """
        self.__weather_data['latitude'] = value
    
    def get_longitude(self):
        """
        Retrieves the longitude from the weather data.

        Returns:
        float: The longitude if available, otherwise None.
        """
        return self.__weather_data.get('longitude', None)
    
    def set_longitude(self, value):
        """
        Sets the longitude in the weather data.

        Parameters:
        value (float): The new longitude to be set.
        """
        self.__weather_data['longitude'] = value
    
    def get_resolvedAddress(self):
        """
        Retrieves the resolved address from the weather data.

        Returns:
        str: The resolved address if available, otherwise None.
        """
        return self.__weather_data.get('resolvedAddress', None)
        
    def set_address(self, value):
        """
        Sets the resolved address in the weather data.

        Parameters:
        value (str): The new resolved address to be set.
        """
        self.__weather_data['resolvedAddress'] = value
    
    def get_address(self):
        """
        Retrieves the address from the weather data.

        Returns:
        str: The address if available, otherwise None.
        """
        return self.__weather_data.get('address', None)
        
    def set_address(self, value):
        """
        Sets the address in the weather data.

        Parameters:
        value (str): The new address to be set.
        """
        self.__weather_data['address'] = value
    
    def get_timezone(self):
        """
        Retrieves the timezone from the weather data.

        Returns:
        str: The timezone if available, otherwise None.
        """
        return self.__weather_data.get('timezone', None)
    
    def set_timezone(self, value):
        """
        Sets the timezone in the weather data.

        Parameters:
        value (str): The new timezone to be set.
        """
        self.__weather_data['timezone'] = value
    
    def get_tzoffset(self):
        """
        Retrieves the timezone offset from the weather data.

        Returns:
        float: The timezone offset if available, otherwise None.
        """
        return self.__weather_data.get('tzoffset', None)
    
    def set_tzoffset(self, value):
        """
        Sets the timezone offset in the weather data.

        Parameters:
        value (float): The new timezone offset to be set.
        """
        self.__weather_data['tzoffset'] = value
    
    def get_stations(self):
        """
        Retrieves the list of weather stations from the weather data.

        Returns:
        list: The list of weather stations if available, otherwise an empty list.
        """
        return self.__weather_data.get('stations', [])
    
    def set_stations(self, value):
        """
        Sets the list of weather stations in the weather data.

        Parameters:
        value (list): The new list of weather stations to be set.
        """
        self.__weather_data['stations'] = value


    def get_daily_datetimes(self):
        """
        Retrieves a list of datetime objects representing each day's date from the weather data.

        Returns:
        list of datetime: A list of datetime objects parsed from the 'datetime' key of each day in the weather data.
        """
        return [datetime.strptime(day['datetime'], '%Y-%m-%d') for day in self.__weather_data.get('days', [])]
    
    def get_hourly_datetimes(self):
        """
        Retrieves a list of datetime objects representing each hour's datetime from the weather data.

        The method combines the 'datetime' from each day with the 'datetime' from each hour within that day.

        Returns:
        list of datetime: A list of datetime objects parsed from the 'datetime' keys of each day and hour in the weather data.
        """
        return [
            datetime.strptime(f"{day['datetime']} {hour['datetime']}", '%Y-%m-%d %H:%M:%S')
            for day in self.__weather_data.get('days', [])
            for hour in day.get('hours', [])
        ]



    def get_data_on_day(self, day_info, elements=[]):
        """
        Retrieves weather data for a specific day based on a date string or index.

        Parameters:
        day_info (str|int): The identifier for the day, which can be a date string (YYYY-MM-DD) or an index of the day list.
        elements (str): Specific weather elements to retrieve.        

        Returns:
        dict: The weather data dictionary for the specified day.

        Raises:
        ValueError: If the input day_info is neither a string nor an integer.
        IndexError: If the integer index is out of the range of the days list.
        """
        try:
            if isinstance(day_info, str):
                day_data = next(day for day in self.__weather_data.get('days', []) if day['datetime'] == day_info)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info]
            else:
                day_data = ValueError(f"Invalid input value for get_data_on_day() with str or int: {day_info}")
            
            if elements:
                return extract_subdict_by_keys(day_data, elements)
            else:
                return day_data
        except Exception as e:
            print(f"Error accessing data on this day: {str(e)}")

    def set_data_on_day(self, day_info, data):
        """
        Updates weather data for a specific day based on a date string or index.

        Parameters:
        day_info (str|int): The identifier for the day, which can be a date string (YYYY-MM-DD) or an index of the day list.
        data (dict): The new weather data dictionary to replace the existing day's data.

        Raises:
        ValueError: If the input day_info is neither a string nor an integer, or if data is not a dictionary.
        IndexError: If the integer index is out of the range of the days list.
        """
        try:
            if isinstance(day_info, str):
                for i, day in enumerate(self.__weather_data.get('days', [])):
                    if day['datetime'] == day_info:
                        self.__weather_data['days'][i] = data
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info] = data
            else:
                raise ValueError(f"Invalid input day value for set_data_on_day() with str or int: {day_info}")
        except Exception as e:
            raise e

    
    def get_temp_on_day(self, day_info):
        """
        Retrieves the temperature for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
        
        Returns:
            float: The temperature for the specified day.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['temp'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('temp')
            else:
                raise ValueError(f"Invalid input value for day_info: {day_info}. Expected a date string or day index.")
        except Exception as e:
            print(f"Error accessing temperature data: {str(e)}")

    def set_temp_on_day(self, day_info, value):
        """
        Sets the temperature for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new temperature value to set.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                day = next((day for day in self.__weather_data['days'] if day['datetime'] == day_info), None)
                if day:
                    day['temp'] = value
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['temp'] = value
            else:
                raise ValueError(f"Invalid input value for day_info: {day_info}. Expected a date string or day index.")
        except Exception as e:
            raise Exception(f"Error setting temperature data: {str(e)}")
    

    def get_tempmax_on_day(self, day_info):
        """
        Retrieves the maximum temperature for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
        
        Returns:
            float: The maximum temperature for the specified day, or None if not found.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['tempmax'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('tempmax')
            else:
                raise ValueError(f"Invalid input value for get_tempmax_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing maximum temperature data: {str(e)}")

    def set_tempmax_on_day(self, day_info, value):
        """
        Sets the maximum temperature for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new maximum temperature value to set.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['tempmax'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['tempmax'] = value
            else:
                raise ValueError(f"Invalid input day value for set_tempmax_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting maximum temperature data: {str(e)}")


    def get_tempmin_on_day(self, day_info):
        """
        Retrieves the minimum temperature for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
        
        Returns:
            float: The minimum temperature for the specified day, or None if not found.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['tempmin'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('tempmin')
            else:
                raise ValueError(f"Invalid input value for get_tempmin_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing minimum temperature data: {str(e)}")

    def set_tempmin_on_day(self, day_info, value):
        """
        Sets the minimum temperature for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new minimum temperature value to set.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['tempmin'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['tempmin'] = value
            else:
                raise ValueError(f"Invalid input day value for set_tempmin_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting minimum temperature data: {str(e)}")
    

    def get_feelslike_on_day(self, day_info):
        """
        Retrieves the 'feels like' temperature for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
        
        Returns:
            float: The 'feels like' temperature for the specified day, or None if not found.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['feelslike'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('feelslike')
            else:
                raise ValueError(f"Invalid input value for get_feelslike_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing 'feels like' temperature data: {str(e)}")

    def set_feelslike_on_day(self, day_info, value):
        """
        Sets the 'feels like' temperature for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new 'feels like' temperature value to set.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['feelslike'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['feelslike'] = value
            else:
                raise ValueError(f"Invalid input day value for set_feelslike_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting 'feels like' temperature data: {str(e)}")
    

    def get_feelslikemax_on_day(self, day_info):
        """
        Retrieves the maximum 'feels like' temperature for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
        
        Returns:
            float: The maximum 'feels like' temperature for the specified day, or None if not found.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['feelslikemax'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('feelslikemax')
            else:
                raise ValueError(f"Invalid input value for get_feelslikemax_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing 'feels like max' temperature data: {str(e)}")

    def set_feelslikemax_on_day(self, day_info, value):
        """
        Sets the maximum 'feels like' temperature for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new maximum 'feels like' temperature value to set.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['feelslikemax'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['feelslikemax'] = value
            else:
                raise ValueError(f"Invalid input day value for set_feelslikemax_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting 'feels like max' temperature data: {str(e)}")

    def get_feelslikemin_on_day(self, day_info):
        """
        Retrieves the minimum 'feels like' temperature for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
        
        Returns:
            float: The minimum 'feels like' temperature for the specified day, or None if not found.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['feelslikemin'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('feelslikemin')
            else:
                raise ValueError(f"Invalid input value for get_feelslikemin_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing 'feels like min' temperature data: {str(e)}")

    def set_feelslikemin_on_day(self, day_info, value):
        """
        Sets the minimum 'feels like' temperature for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new minimum temperature value to set.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['feelslikemin'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['feelslikemin'] = value
            else:
                raise ValueError(f"Invalid input day value for set_feelslikemin_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting 'feels like min' temperature data: {str(e)}")
    

    def get_dew_on_day(self, day_info):
        """
        Retrieves the dew point for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
        
        Returns:
            float: The dew point for the specified day, or None if not found.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['dew'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('dew')
            else:
                raise ValueError(f"Invalid input value for get_dew_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing dew point data: {str(e)}")

    def set_dew_on_day(self, day_info, value):
        """
        Sets the dew point for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new dew point value to set.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['dew'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['dew'] = value
            else:
                raise ValueError(f"Invalid input day value for set_dew_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting dew point data: {str(e)}")


    def get_humidity_on_day(self, day_info):
        """
        Retrieves the humidity percentage for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
        
        Returns:
            float: The humidity percentage for the specified day, or None if not found.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['humidity'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('humidity')
            else:
                raise ValueError(f"Invalid input value for get_humidity_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing humidity data: {str(e)}")

    def set_humidity_on_day(self, day_info, value):
        """
        Sets the humidity percentage for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new humidity percentage value to set.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['humidity'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['humidity'] = value
            else:
                raise ValueError(f"Invalid input day value for set_humidity_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting humidity data: {str(e)}")
    

    def get_precip_on_day(self, day_info):
        """
        Retrieves the precipitation amount for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
        
        Returns:
            float: The precipitation amount for the specified day, or None if not found.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['precip'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('precip')
            else:
                raise ValueError(f"Invalid input value for get_precip_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing precipitation data: {str(e)}")

    def set_precip_on_day(self, day_info, value):
        """
        Sets the precipitation amount for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new precipitation amount value to set.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['precip'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['precip'] = value
            else:
                raise ValueError(f"Invalid input day value for set_precip_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting precipitation data: {str(e)}")


    def get_precipprob_on_day(self, day_info):
        """
        Retrieves the probability of precipitation for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
        
        Returns:
            float: The probability of precipitation for the specified day, or None if not found.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['precipprob'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('precipprob')
            else:
                raise ValueError(f"Invalid input value for get_precipprob_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing precipitation probability data: {str(e)}")

    def set_precipprob_on_day(self, day_info, value):
        """
        Sets the probability of precipitation for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new probability of precipitation value to set.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['precipprob'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['precipprob'] = value
            else:
                raise ValueError(f"Invalid input day value for set_precipprob_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting precipitation probability data: {str(e)}")
    

    def get_precipcover_on_day(self, day_info):
        """
        Retrieves the precipitation coverage for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
        
        Returns:
            float: The precipitation coverage for the specified day, or None if not found.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['precipcover'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('precipcover')
            else:
                raise ValueError(f"Invalid input value for get_precipcover_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing precipitation coverage data: {str(e)}")

    def set_precipcover_on_day(self, day_info, value):
        """
        Sets the precipitation coverage for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new precipitation coverage value to set.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['precipcover'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['precipcover'] = value
            else:
                raise ValueError(f"Invalid input day value for set_precipcover_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting precipitation coverage data: {str(e)}")


    def get_preciptype_on_day(self, day_info):
        """
        Retrieves the type of precipitation for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
        
        Returns:
            str: The type of precipitation for the specified day, or None if not found.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['preciptype'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('preciptype')
            else:
                raise ValueError(f"Invalid input value for get_preciptype_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing precipitation type data: {str(e)}")

    def set_preciptype_on_day(self, day_info, value):
        """
        Sets the type of precipitation for a specific day identified by date or index.
        
        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (str): The new type of precipitation value to set.
        
        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['preciptype'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['preciptype'] = value
            else:
                raise ValueError(f"Invalid input day value for set_preciptype_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting precipitation type data: {str(e)}")


    def get_snow_on_day(self, day_info):
        """
        Retrieves the snowfall amount for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            float: The snowfall amount for the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['snow'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('snow')
            else:
                raise ValueError(f"Invalid input value for get_snow_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing snow data: {str(e)}")

    def set_snow_on_day(self, day_info, value):
        """
        Sets the snowfall amount for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new snowfall amount to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['snow'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['snow'] = value
            else:
                raise ValueError(f"Invalid input day value for set_snow_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting snow data: {str(e)}")


    def get_snowdepth_on_day(self, day_info):
        """
        Retrieves the snow depth for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            float: The snow depth for the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['snowdepth'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('snowdepth')
            else:
                raise ValueError(f"Invalid input value for get_snowdepth_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing snow depth data: {str(e)}")

    def set_snowdepth_on_day(self, day_info, value):
        """
        Sets the snow depth for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new snow depth to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['snowdepth'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['snowdepth'] = value
            else:
                raise ValueError(f"Invalid input day value for set_snowdepth_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting snow depth data: {str(e)}")
    

    def get_windgust_on_day(self, day_info):
        """
        Retrieves the wind gust value for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            float: The wind gust value for the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['windgust'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('windgust')
            else:
                raise ValueError(f"Invalid input value for get_windgust_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing wind gust data: {str(e)}")

    def set_windgust_on_day(self, day_info, value):
        """
        Sets the wind gust value for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new wind gust value to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['windgust'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['windgust'] = value
            else:
                raise ValueError(f"Invalid input day value for set_windgust_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting wind gust data: {str(e)}")

    def get_windspeed_on_day(self, day_info):
        """
        Retrieves the wind speed for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            float: The wind speed for the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['windspeed'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('windspeed')
            else:
                raise ValueError(f"Invalid input value for get_windspeed_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing wind speed data: {str(e)}")

    def set_windspeed_on_day(self, day_info, value):
        """
        Sets the wind speed for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new wind speed value to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['windspeed'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['windspeed'] = value
            else:
                raise ValueError(f"Invalid input day value for set_windspeed_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting wind speed data: {str(e)}")
    

    def get_winddir_on_day(self, day_info):
        """
        Retrieves the wind direction for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            float: The wind direction for the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['winddir'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('winddir')
            else:
                raise ValueError(f"Invalid input value for get_winddir_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing wind direction data: {str(e)}")

    def set_winddir_on_day(self, day_info, value):
        """
        Sets the wind direction for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new wind direction value to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['winddir'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['winddir'] = value
            else:
                raise ValueError(f"Invalid input day value for set_winddir_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting wind direction data: {str(e)}")

    def get_pressure_on_day(self, day_info):
        """
        Retrieves the atmospheric pressure for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            float: The atmospheric pressure for the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['pressure'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('pressure')
            else:
                raise ValueError(f"Invalid input value for get_pressure_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing pressure data: {str(e)}")

    def set_pressure_on_day(self, day_info, value):
        """
        Sets the atmospheric pressure for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new pressure value to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['pressure'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['pressure'] = value
            else:
                raise ValueError(f"Invalid input day value for set_pressure_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting pressure data: {str(e)}")
    

    def get_cloudcover_on_day(self, day_info):
        """
        Retrieves the cloud cover percentage for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            float: The cloud cover percentage for the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['cloudcover'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('cloudcover')
            else:
                raise ValueError(f"Invalid input value for get_cloudcover_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing cloud cover data: {str(e)}")

    def set_cloudcover_on_day(self, day_info, value):
        """
        Sets the cloud cover percentage for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new cloud cover percentage to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['cloudcover'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['cloudcover'] = value
            else:
                raise ValueError(f"Invalid input day value for set_cloudcover_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting cloud cover data: {str(e)}")

    def get_visibility_on_day(self, day_info):
        """
        Retrieves the visibility distance for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            float: The visibility distance for the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['visibility'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('visibility')
            else:
                raise ValueError(f"Invalid input value for get_visibility_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing visibility data: {str(e)}")

    def set_visibility_on_day(self, day_info, value):
        """
        Sets the visibility distance for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new visibility distance to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['visibility'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['visibility'] = value
            else:
                raise ValueError(f"Invalid input day value for set_visibility_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting visibility data: {str(e)}")
    

    def get_solarradiation_on_day(self, day_info):
        """
        Retrieves the solar radiation level for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            float: The solar radiation level for the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['solarradiation'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('solarradiation')
            else:
                raise ValueError(f"Invalid input value for get_solarradiation_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing solar radiation data: {str(e)}")

    def set_solarradiation_on_day(self, day_info, value):
        """
        Sets the solar radiation level for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new solar radiation level to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['solarradiation'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['solarradiation'] = value
            else:
                raise ValueError(f"Invalid input day value for set_solarradiation_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting solar radiation data: {str(e)}")

    def get_solarenergy_on_day(self, day_info):
        """
        Retrieves the solar energy generated on a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            float: The solar energy generated on the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['solarenergy'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('solarenergy')
            else:
                raise ValueError(f"Invalid input value for get_solarenergy_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing solar energy data: {str(e)}")

    def set_solarenergy_on_day(self, day_info, value):
        """
        Sets the solar energy level for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new solar energy level to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['solarenergy'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['solarenergy'] = value
            else:
                raise ValueError(f"Invalid input day value for set_solarenergy_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting solar energy data: {str(e)}")
    

    def get_uvindex_on_day(self, day_info):
        """
        Retrieves the UV index for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            float: The UV index for the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['uvindex'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('uvindex')
            else:
                raise ValueError(f"Invalid input value for get_uvindex_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing UV index data: {str(e)}")

    def set_uvindex_on_day(self, day_info, value):
        """
        Sets the UV index for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new UV index value to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['uvindex'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['uvindex'] = value
            else:
                raise ValueError(f"Invalid input day value for set_uvindex_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting UV index data: {str(e)}")
    

    def get_severerisk_on_day(self, day_info):
        """
        Retrieves the severe weather risk level for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            float|None: The severe weather risk level for the specified day, or None if not found.

        Raises:
            ValueError: If the input is neither a string nor an integer.
            Exception: For other internal issues, such as index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['severerisk'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('severerisk')
            else:
                raise ValueError(f"Invalid input value for get_severerisk_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing severe risk data: {str(e)}")

    def set_severerisk_on_day(self, day_info, value):
        """
        Sets the severe weather risk level for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new severe weather risk level to set.

        Raises:
            ValueError: If the input is neither a string nor an integer.
            Exception: For other internal issues, such as index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['severerisk'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['severerisk'] = value
            else:
                raise ValueError(f"Invalid input day value for set_severerisk_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting severe risk data: {str(e)}")
    

    def get_sunrise_on_day(self, day_info):
        """
        Retrieves the sunrise time for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            str: The sunrise time for the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['sunrise'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('sunrise')
            else:
                raise ValueError(f"Invalid input value for get_sunrise_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing sunrise data: {str(e)}")

    def set_sunrise_on_day(self, day_info, value):
        """
        Sets the sunrise time for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (str): The new sunrise time value to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['sunrise'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['sunrise'] = value
            else:
                raise ValueError(f"Invalid input day value for set_sunrise_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting sunrise data: {str(e)}")

    def get_sunriseEpoch_on_day(self, day_info):
        """
        Retrieves the Unix timestamp for the sunrise time for a specific day.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            int: The sunrise Unix timestamp for the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['sunriseEpoch'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('sunriseEpoch')
            else:
                raise ValueError(f"Invalid input value for get_sunriseEpoch_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing sunrise epoch data: {str(e)}")

    def set_sunriseEpoch_on_day(self, day_info, value):
        """
        Sets the Unix timestamp for the sunrise time for a specific day.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (int): The new sunrise Unix timestamp value to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['sunriseEpoch'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['sunriseEpoch'] = value
            else:
                raise ValueError(f"Invalid input day value for set_sunriseEpoch_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting sunrise epoch data: {str(e)}")
    

    def get_sunset_on_day(self, day_info):
        """
        Retrieves the sunset time for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            str: The sunset time for the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['sunset'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('sunset')
            else:
                raise ValueError(f"Invalid input value for get_sunset_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing sunset data: {str(e)}")

    def set_sunset_on_day(self, day_info, value):
        """
        Sets the sunset time for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (str): The new sunset time value to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['sunset'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['sunset'] = value
            else:
                raise ValueError(f"Invalid input day value for set_sunset_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting sunset data: {str(e)}")

    def get_sunsetEpoch_on_day(self, day_info):
        """
        Retrieves the Unix timestamp for the sunset time for a specific day.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            int: The sunset Unix timestamp for the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['sunsetEpoch'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('sunsetEpoch')
            else:
                raise ValueError(f"Invalid input value for get_sunsetEpoch_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing sunset epoch data: {str(e)}")

    def set_sunsetEpoch_on_day(self, day_info, value):
        """
        Sets the Unix timestamp for the sunset time for a specific day.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (int): The new sunset Unix timestamp value to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['sunsetEpoch'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['sunsetEpoch'] = value
            else:
                raise ValueError(f"Invalid input day value for set_sunsetEpoch_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting sunset epoch data: {str(e)}")
    

    def get_moonphase_on_day(self, day_info):
        """
        Retrieves the moon phase for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            float: The moon phase for the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['moonphase'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('moonphase')
            else:
                raise ValueError(f"Invalid input value for get_moonphase_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing moon phase data: {str(e)}")

    def set_moonphase_on_day(self, day_info, value):
        """
        Sets the moon phase for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (float): The new moon phase value to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['moonphase'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['moonphase'] = value
            else:
                raise ValueError(f"Invalid input day value for set_moonphase_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting moon phase data: {str(e)}")

    def get_conditions_on_day(self, day_info):
        """
        Retrieves the weather conditions for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            str: The weather conditions for the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['conditions'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('conditions')
            else:
                raise ValueError(f"Invalid input value for get_conditions_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing conditions data: {str(e)}")

    def set_conditions_on_day(self, day_info, value):
        """
        Sets the weather conditions for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (str): The new conditions value to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['conditions'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['conditions'] = value
            else:
                raise ValueError(f"Invalid input day value for set_conditions_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting conditions data: {str(e)}")
    

    def get_description_on_day(self, day_info):
        """
        Retrieves the weather description for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            str: The weather description for the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['description'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('description')
            else:
                raise ValueError(f"Invalid input value for get_description_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing description data: {str(e)}")

    def set_description_on_day(self, day_info, value):
        """
        Sets the weather description for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (str): The new description to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['description'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['description'] = value
            else:
                raise ValueError(f"Invalid input day value for set_description_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting description data: {str(e)}")    


    def get_icon_on_day(self, day_info):
        """
        Retrieves the weather icon for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            str: The weather icon for the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['icon'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('icon')
            else:
                raise ValueError(f"Invalid input value for get_icon_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing icon data: {str(e)}")

    def set_icon_on_day(self, day_info, value):
        """
        Sets the weather icon for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (str): The new icon to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['icon'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['icon'] = value
            else:
                raise ValueError(f"Invalid input day value for set_icon_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting icon data: {str(e)}")

    def get_stations_on_day(self, day_info):
        """
        Retrieves the weather stations data for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.

        Returns:
            list: The list of weather stations active on the specified day, or None if not found.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                return next((day['stations'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), None)
            elif isinstance(day_info, int):
                return self.__weather_data['days'][day_info].get('stations')
            else:
                raise ValueError(f"Invalid input value for get_stations_on_day with str or int: {day_info}")
        except Exception as e:
            print(f"Error accessing stations data: {str(e)}")

    def set_stations_on_day(self, day_info, value):
        """
        Sets the weather stations data for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            value (list): The new list of weather stations to set.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['stations'] = value
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['stations'] = value
            else:
                raise ValueError(f"Invalid input day value for set_stations_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting stations data: {str(e)}")


    def get_hourlyData_on_day(self, day_info, elements=[]):
        """
        Retrieves hourly weather data for a specific day identified by date or index. Optionally filters the data
        to include only specified elements.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            elements (list): Optional list of keys to filter the hourly data.

        Returns:
            list: A list of hourly data dictionaries for the specified day. If elements are specified,
                  returns a list of dictionaries containing only the specified keys.

        Raises:
            ValueError: If the input is not a string or integer.
            Exception: For other internal issues, including index errors or missing data.
        """
        try:
            if isinstance(day_info, str):
                hourly_data = next((day['hours'] for day in self.__weather_data.get('days', []) if day['datetime'] == day_info), [])
            elif isinstance(day_info, int):
                hourly_data = self.__weather_data['days'][day_info].get('hours', [])
            else:
                raise ValueError(f"Invalid input value for get_hourlyData_on_day with str or int: {day_info}")

            if elements:
                return [{key: hour.get(key, None) for key in elements} for hour in hourly_data]
            return hourly_data
        except Exception as e:
            raise Exception(f"Error retrieving hourly data: {str(e)}")

    def set_hourlyData_on_day(self, day_info, data):
        """
        Sets the hourly weather data for a specific day identified by date or index.

        Parameters:
            day_info (str|int): The day's date as a string ('YYYY-MM-DD') or index as an integer.
            data (list): The new list of hourly weather data dictionaries to set.

        Raises:
            ValueError: If the input is not a string or integer or if data is not a list.
            Exception: For other internal issues, including index errors.
        """
        try:
            if isinstance(day_info, str):
                for day in self.__weather_data.get('days', []):
                    if day['datetime'] == day_info:
                        day['hours'] = data
                        break
            elif isinstance(day_info, int):
                self.__weather_data['days'][day_info]['hours'] = data
            else:
                raise ValueError(f"Invalid input day value for set_hourlyData_on_day with str or int: {day_info}")
        except Exception as e:
            raise Exception(f"Error setting hourly data: {str(e)}")


    @staticmethod
    def filter_item_by_datetimeVal(src, datetimeVal):
        """
        Filters an item by its datetime value from a list of dictionaries, each containing a 'datetime' key.

        Parameters:
            src (list): The source list of dictionaries, each expected to contain a 'datetime' key.
            datetimeVal (str|int): The datetime value used for filtering, which can be a date string or an index.

        Returns:
            dict: The filtered dictionary item.

        Raises:
            ValueError: If the datetimeVal is neither a string nor an integer.
        """
        if isinstance(datetimeVal, str):
            for item in src:
                if item['datetime'] == datetimeVal:
                    return item
        elif isinstance(datetimeVal, int):
            return src[datetimeVal]
        else:
            raise ValueError(f"Invalid input datetime value for filter_item_by_datetimeVal with str or int: {datetimeVal}")

    @staticmethod
    def set_item_by_datetimeVal(src, datetimeVal, data):
        """
        Sets an item's data by its datetime value in a list of dictionaries based on the given datetimeVal.

        Parameters:
            src (list): The source list of dictionaries, each expected to contain a 'datetime' key.
            datetimeVal (str|int): The datetime value used for updating, which can be a date string or an index.
            data (dict): The new data dictionary to replace the old dictionary.

        Raises:
            ValueError: If the input data is not a dictionary or datetimeVal is neither a string nor an integer.
        """
        if not isinstance(data, dict):
            raise ValueError(f"Invalid input data value for set_item_by_datetimeVal with dict: {data}")

        if isinstance(datetimeVal, str):
            for item in src:
                if item[DATETIME] == datetimeVal:
                    data.update({DATETIME: datetimeVal}) # Ensure datetime is not changed
                    item.clear()
                    item.update(data)
                    break
        elif isinstance(datetimeVal, int):
            data[DATETIME] = src[datetimeVal][DATETIME]  # Ensure datetime is not changed
            src[datetimeVal] = data
        else:
            raise ValueError(f"Invalid input datetime value for set_item_by_datetimeVal with str or int: {datetimeVal}")
    
    @staticmethod
    def update_item_by_datetimeVal(src, datetimeVal, data):
        """
        Updates an item's data by its datetime value in a list of dictionaries based on the given datetimeVal.

        Parameters:
            src (list): The source list of dictionaries, each expected to contain a 'datetime' key.
            datetimeVal (str|int): The datetime value used for updating, which can be a date string or an index.
            data (dict): The new data dictionary to update the old dictionary.

        Raises:
            ValueError: If the input data is not a dictionary or datetimeVal is neither a string nor an integer.
        """
        if not isinstance(data, dict):
            raise ValueError(f"Invalid input data value for set_item_by_datetimeVal with dict: {data}")

        if isinstance(datetimeVal, str):
            for item in src:
                if item['datetime'] == datetimeVal:
                    item.update(data)
                    item['datetime'] = datetimeVal  # Ensure datetime is not changed
                    break
        elif isinstance(datetimeVal, int):
            data['datetime'] = src[datetimeVal]['datetime']  # Ensure datetime is not changed
            src[datetimeVal].update(data)
        else:
            raise ValueError(f"Invalid input datetime value for set_item_by_datetimeVal with str or int: {datetimeVal}")

    def get_data_at_datetime(self, day_info, time_info, elements = []):
        """
        Retrieves weather data for a specific date and time from the weather data collection.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index, pointing to a specific day in the data.
            time_info (str|int): A time identifier, which can be a time string (HH:MM:SS) or an index, pointing to a specific time slot in the day's data.
            elements (str): Specific weather elements to retrieve.

        Returns:
            dict: The specific hourly data dictionary corresponding to the given day and time.

        Raises:
            Exception: Propagates any exceptions that may occur during data retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            data = Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)
            if elements:
                return extract_subdict_by_keys(data, elements)
            else:
                return data
        except Exception as e:
            raise e

    def set_data_at_datetime(self, day_info, time_info, data):
        """
        Sets weather data for a specific date and time in the weather data collection.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index, pointing to a specific day in the data.
            time_info (str|int): A time identifier, which can be a time string (HH:MM:SS) or an index, pointing to a specific time slot in the day's data.
            data (dict): The data dictionary to be set for the specific hourly time slot.

        Raises:
            Exception: Propagates any exceptions that may occur during data setting.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.set_item_by_datetimeVal(day_item['hours'], time_info, data)
        except Exception as e:
            raise e
    
    def update_data_at_datetime(self, day_info, time_info, data):
        """
        Sets weather data for a specific date and time in the weather data collection.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index, pointing to a specific day in the data.
            time_info (str|int): A time identifier, which can be a time string (HH:MM:SS) or an index, pointing to a specific time slot in the day's data.
            data (dict): The data dictionary to be updated for the specific hourly time slot.

        Raises:
            Exception: Propagates any exceptions that may occur during data setting.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.update_item_by_datetimeVal(day_item['hours'], time_info, data)
        except Exception as e:
            raise e
    

    def get_datetimeEpoch_at_datetime(self, day_info, time_info):
        """
        Retrieves the epoch time for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            int: The epoch time corresponding to the specific day and time.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['datetimeEpoch']
        except Exception as e:
            print(f"An exception occurred: {type(e).__name__} -> {e}")
        
    def set_datetimeEpoch_at_datetime(self, day_info, time_info, value):
        """
        Sets the epoch time for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.
            value (int): The epoch time value to be set.

        Raises:
            Exception: Propagates any exceptions that may occur during the setting process.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['datetimeEpoch'] = value
        except Exception as e:
            raise e

    def get_temp_at_datetime(self, day_info, time_info):
        """
        Retrieves the temperature for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            float: The temperature at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['temp']
        except Exception as e:
            print(f"An exception occurred: {type(e).__name__} -> {e}")
        
    def set_temp_at_datetime(self, day_info, time_info, value):
        """
        Sets the temperature for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.
            value (float): The temperature value to be set.

        Raises:
            Exception: Propagates any exceptions that may occur during the setting process.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['temp'] = value
        except Exception as e:
            raise e
    

    def get_feelslike_at_datetime(self, day_info, time_info):
        """
        Retrieves the 'feels like' temperature for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            float: The 'feels like' temperature at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['feelslike']
        except Exception as e:
            print(f"An exception occurred: {type(e).__name__} -> {e}")
        
    def set_feelslike_at_datetime(self, day_info, time_info, value):
        """
        Sets the 'feels like' temperature for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.
            value (float): The 'feels like' temperature value to be set.

        Raises:
            Exception: Propagates any exceptions that may occur during the setting process.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['feelslike'] = value
        except Exception as e:
            raise e

    def get_humidity_at_datetime(self, day_info, time_info):
        """
        Retrieves the humidity for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            float: The humidity percentage at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['humidity']
        except Exception as e:
            print(f"An exception occurred: {type(e).__name__} -> {e}")
        
    def set_humidity_at_datetime(self, day_info, time_info, value):
        """
        Sets the humidity for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.
            value (float): The humidity percentage to be set.

        Raises:
            Exception: Propagates any exceptions that may occur during the setting process.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['humidity'] = value
        except Exception as e:
            raise e
    

    def get_dew_at_datetime(self, day_info, time_info):
        """
        Retrieves the dew point temperature for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            float: The dew point temperature at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['dew']
        except Exception as e:
            print(f"An exception occurred: {type(e).__name__} -> {e}")
        
    def set_dew_at_datetime(self, day_info, time_info, value):
        """
        Sets the dew point temperature for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.
            value (float): The dew point temperature to be set.

        Raises:
            Exception: Propagates any exceptions that may occur during the setting process.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['dew'] = value
        except Exception as e:
            raise e

    def get_precip_at_datetime(self, day_info, time_info):
        """
        Retrieves the precipitation amount for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            float: The precipitation amount at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['precip']
        except Exception as e:
            print(f"An exception occurred: {type(e).__name__} -> {e}")
        
    def set_precip_at_datetime(self, day_info, time_info, value):
        """
        Sets the precipitation amount for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.
            value (float): The precipitation amount to be set.

        Raises:
            Exception: Propagates any exceptions that may occur during the setting process.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['precip'] = value
        except Exception as e:
            raise e
    

    def get_precipprob_at_datetime(self, day_info, time_info):
        """
        Retrieves the probability of precipitation for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            float: The probability of precipitation at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['precipprob']
        except Exception as e:
            print(f"An exception occurred: {type(e).__name__} -> {e}")
        
    def set_precipprob_at_datetime(self, day_info, time_info, value):
        """
        Sets the probability of precipitation for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.
            value (float): The probability of precipitation to be set.

        Raises:
            Exception: Propagates any exceptions that may occur during the setting process.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['precipprob'] = value
        except Exception as e:
            raise e

    def get_snow_at_datetime(self, day_info, time_info):
        """
        Retrieves the snow amount for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            float: The snow amount at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['snow']
        except Exception as e:
            print(f"An exception occurred: {type(e).__name__} -> {e}")
        
    def set_snow_at_datetime(self, day_info, time_info, value):
        """
        Sets the snow amount for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.
            value (float): The snow amount to be set.

        Raises:
            Exception: Propagates any exceptions that may occur during the setting process.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['snow'] = value
        except Exception as e:
            raise e
    

    def get_snowdepth_at_datetime(self, day_info, time_info):
        """
        Retrieves the snow depth for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            float: The snow depth at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['snowdepth']
        except Exception as e:
            print(f"An exception occurred: {type(e).__name__} -> {e}")
        
    def set_snowdepth_at_datetime(self, day_info, time_info, value):
        """
        Sets the snow depth for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.
            value (float): The snow depth to be set.

        Raises:
            Exception: Propagates any exceptions that may occur during the setting process.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['snowdepth'] = value
        except Exception as e:
            raise e

    def get_preciptype_at_datetime(self, day_info, time_info):
        """
        Retrieves the type of precipitation for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            str: The type of precipitation at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['preciptype']
        except Exception as e:
            print(f"An exception occurred: {type(e).__name__} -> {e}")
        
    def set_preciptype_at_datetime(self, day_info, time_info, value):
        """
        Sets the type of precipitation for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.
            value (str): The type of precipitation to be set.

        Raises:
            Exception: Propagates any exceptions that may occur during the setting process.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['preciptype'] = value
        except Exception as e:
            raise e


    def get_windgust_at_datetime(self, day_info, time_info):
        """
        Retrieves the wind gust speed for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            float: The wind gust speed at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['windgust']
        except Exception as e:
            print(f"An exception occurred: {type(e).__name__} -> {e}")
        
    def set_windgust_at_datetime(self, day_info, time_info, value):
        """
        Sets the wind gust speed for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.
            value (float): The wind gust speed to be set.

        Raises:
            Exception: Propagates any exceptions that may occur during the setting process.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['windgust'] = value
        except Exception as e:
            raise e

    def get_windspeed_at_datetime(self, day_info, time_info):
        """
        Retrieves the wind speed for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            float: The wind speed at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['windspeed']
        except Exception as e:
            print(f"An exception occurred: {type(e).__name__} -> {e}")
        
    def set_windspeed_at_datetime(self, day_info, time_info, value):
        """
        Sets the wind speed for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.
            value (float): The wind speed to be set.

        Raises:
            Exception: Propagates any exceptions that may occur during the setting process.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['windspeed'] = value
        except Exception as e:
            raise e
    

    def get_winddir_at_datetime(self, day_info, time_info):
        """
        Retrieves the wind direction for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            float: The wind direction at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['winddir']
        except Exception as e:
            print(f"An exception occurred: {type(e).__name__} -> {e}")
        
    def set_winddir_at_datetime(self, day_info, time_info, value):
        """
        Sets the wind direction for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.
            value (float): The wind direction to be set.

        Raises:
            Exception: Propagates any exceptions that may occur during the setting process.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['winddir'] = value
        except Exception as e:
            raise e

    def get_pressure_at_datetime(self, day_info, time_info):
        """
        Retrieves the atmospheric pressure for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            float: The atmospheric pressure at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['pressure']
        except Exception as e:
            print(f"An exception occurred: {type(e).__name__} -> {e}")
        
    def set_pressure_at_datetime(self, day_info, time_info, value):
        """
        Sets the atmospheric pressure for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.
            value (float): The atmospheric pressure to be set.

        Raises:
            Exception: Propagates any exceptions that may occur during the setting process.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['pressure'] = value
        except Exception as e:
            raise e


    def get_visibility_at_datetime(self, day_info, time_info):
        """
        Retrieves the visibility for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            float: The visibility at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['visibility']
        except Exception as e:
            print(f"An exception occurred: {type(e).__name__} -> {e}")
        
    def set_visibility_at_datetime(self, day_info, time_info, value):
        """
        Sets the visibility for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.
            value (float): The visibility to be set.

        Raises:
            Exception: Propagates any exceptions that may occur during the setting process.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['visibility'] = value
        except Exception as e:
            raise e

    def get_cloudcover_at_datetime(self, day_info, time_info):
        """
        Retrieves the cloud cover for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            float: The cloud cover at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['cloudcover']
        except Exception as e:
            print(f"An exception occurred: {type(e).__name__} -> {e}")
        
    def set_cloudcover_at_datetime(self, day_info, time_info, value):
        """
        Sets the cloud cover for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.
            value (float): The cloud cover to be set.

        Raises:
            Exception: Propagates any exceptions that may occur during the setting process.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['cloudcover'] = value
        except Exception as e:
            raise e


    def get_solarradiation_at_datetime(self, day_info, time_info):
        """
        Retrieves the solar radiation for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            float: The solar radiation at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['solarradiation']
        except Exception as e:
            print(f"An exception occurred: {type(e).__name__} -> {e}")
        
    def set_solarradiation_at_datetime(self, day_info, time_info, value):
        """
        Sets the solar radiation for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.
            value (float): The solar radiation to be set.

        Raises:
            Exception: Propagates any exceptions that may occur during the setting process.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['solarradiation'] = value
        except Exception as e:
            raise e

    def get_solarenergy_at_datetime(self, day_info, time_info):
        """
        Retrieves the solar energy for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            float: The solar energy at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['solarenergy']
        except Exception as e:
            print(f"An exception occurred: {type(e).__name__} -> {e}")
        
    def set_solarenergy_at_datetime(self, day_info, time_info, value):
        """
        Sets the solar energy for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.
            value (float): The solar energy to be set.

        Raises:
            Exception: Propagates any exceptions that may occur during the setting process.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['solarenergy'] = value
        except Exception as e:
            raise e
    

    def get_uvindex_at_datetime(self, day_info, time_info):
        """
        Retrieves the UV index for a specific datetime within the weather data.
        * UV index: A value between 0 and 10 indicating the level of ultra violet (UV) exposure for that hour or day

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            float: The UV index at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['uvindex']
        except Exception as e:
            print(f"An exception occured: {type(e).__name__} -> {e}")
        
    def set_uvindex_at_datetime(self, day_info, time_info, value):
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['uvindex'] = value
        except Exception as e:
            raise e
    

    def get_severerisk_at_datetime(self, day_info, time_info):
        """
        Retrieves the severe risk for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            float: The severe risk at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['severerisk']
        except Exception as e:
            print(f"An exception occured: {type(e).__name__} -> {e}")
        
    def set_severerisk_at_datetime(self, day_info, time_info, value):
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['severerisk'] = value
        except Exception as e:
            raise e
    

    def get_conditions_at_datetime(self, day_info, time_info):
        """
        Retrieves the conditions for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            string: The conditions at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['conditions']
        except Exception as e:
            print(f"An exception occured: {type(e).__name__} -> {e}")
        
    def set_conditions_at_datetime(self, day_info, time_info, value):
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['conditions'] = value
        except Exception as e:
            raise e
    

    def get_icon_at_datetime(self, day_info, time_info):
        """
        Retrieves the weather icon for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            string: The weather icon at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['icon']
        except Exception as e:
            print(f"An exception occured: {type(e).__name__} -> {e}")
        
    def set_icon_at_datetime(self, day_info, time_info, value):
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['icon'] = value
        except Exception as e:
            raise e
    

    def get_stations_at_datetime(self, day_info, time_info):
        """
        Retrieves the weather stations that were used for creating the observation for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            list of strings: The weather stations that were used for creating the observation at the specified datetime.

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['stations']
        except Exception as e:
            print(f"An exception occured: {type(e).__name__} -> {e}")
        
    def set_stations_at_datetime(self, day_info, time_info, value):
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['stations'] = value
        except Exception as e:
            raise e
    

    def get_source_at_datetime(self, day_info, time_info):
        """
        Retrieves the type of weather data used for this weather object for a specific datetime within the weather data.

        Parameters:
            day_info (str|int): A day identifier, which can be a date string(YYYY-MM-DD) or an index.
            time_info (str|int): A time identifier, which can be a time string(HH:MM:SS) or an index.

        Returns:
            string: The type of weather data used for this weather object at the specified datetime.
            (Values include historical observation (“obs”), forecast (“fcst”), historical forecast (“histfcst”) or statistical forecast (“stats”).
            If multiple types are used in the same day, “comb” is used. Today a combination of historical observations and forecast data.)

        Raises:
            Exception: Logs any exceptions that may occur during the retrieval.
        """
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            return Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['source']
        except Exception as e:
            print(f"An exception occured: {type(e).__name__} -> {e}")
        
    def set_source_at_datetime(self, day_info, time_info, value):
        try:
            day_item = Weather.filter_item_by_datetimeVal(self.__weather_data['days'], day_info)
            Weather.filter_item_by_datetimeVal(day_item['hours'], time_info)['source'] = value
        except Exception as e:
            raise e

    def clear_weather_data(self):
        self.__weather_data.clear()
