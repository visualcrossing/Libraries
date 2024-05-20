const { extractSubobjectByKeys, updateObject, isValidObject } = require('./utils');
const { BASE_URL } = require('./constants');

class Weather {
    /**
     * A class to fetch and manipulate weather data using the Visual Crossing Weather API.
     * 
     * @param {string} baseUrl - Base URL of the weather API.
     * @param {string} apiKey - API key for the weather API.
     */

    // Private field declaration
    #weatherData;

    constructor(apiKey = '', baseUrl = BASE_URL) {
        this.baseUrl = baseUrl;
        this.apiKey = apiKey;
        this.#weatherData = {};
    }


    /**
     * Filters an item by its datetime value from a list of dictionaries, each containing a 'datetime' key.
     * 
     * @param {Array} src - The source list of dictionaries, each expected to contain a 'datetime' key.
     * @param {string|number} datetimeVal - The datetime value used for filtering, which can be a date string or an index.
     * @returns {Object|null} - The filtered dictionary item.
     */
    static filterItemByDatetimeVal(src, datetimeVal) {
        if (typeof datetimeVal === 'string') {
            return src.find(item => item.datetime === datetimeVal) || null;
        } else if (typeof datetimeVal === 'number') {
            return src[datetimeVal] || null;
        } else {
            throw new Error(`Invalid input datetime value for filterItemByDatetimeVal with str or int: ${datetimeVal}`);
        }
    }

    /**
     * Sets an item's data by its datetime value in a list of dictionaries based on the given datetimeVal.
     *
     * @param {Array} src - The source list of dictionaries, each expected to contain a 'datetime' key.
     * @param {string|number} datetimeVal - The datetime value used for updating, which can be a date string or an index.
     * @param {Object} data - The new data dictionary to replace the old dictionary.
     *
     * @throws {Error} If the input data is not an object or datetimeVal is neither a string nor a number.
     */
    static setItemByDatetimeVal(src, datetimeVal, data) {
        // Check if the data is an object
        if (typeof data !== 'object' || data === null) {
            throw new Error(`Invalid input data value for setItemByDatetimeVal with object: ${data}`);
        }

        if (typeof datetimeVal === 'string') {
            // Loop through the source array to find the matching datetime
            for (const item of src) {
                if (item.datetime === datetimeVal) {
                    // Ensure datetime is not changed and update item
                    Object.assign(item, data, { datetime: datetimeVal });
                    break;
                }
            }
        } else if (typeof datetimeVal === 'number') {
            // Ensure datetime is not changed and replace item at the index
            data.datetime = src[datetimeVal].datetime;
            src[datetimeVal] = { ...data };
        } else {
            throw new Error(`Invalid input datetime value for setItemByDatetimeVal with string or number: ${datetimeVal}`);
        }
    }

    /**
     * Updates an item's data by its datetime value in a list of dictionaries based on the given datetimeVal.
     *
     * @param {Array} src - The source list of dictionaries, each expected to contain a 'datetime' key.
     * @param {string|number} datetimeVal - The datetime value used for updating, which can be a date string or an index.
     * @param {Object} data - The new data dictionary to update the old dictionary.
     *
     * @throws {Error} If the input data is not an object or datetimeVal is neither a string nor a number.
     */
    static updateItemByDatetimeVal(src, datetimeVal, data) {
        // Check if the data is an object
        if (typeof data !== 'object' || data === null) {
            throw new Error(`Invalid input data value for updateItemByDatetimeVal with object: ${data}`);
        }

        if (typeof datetimeVal === 'string') {
            // Loop through the source array to find the matching datetime
            for (const item of src) {
                if (item.datetime === datetimeVal) {
                    // Ensure datetime is not changed and update item
                    Object.assign(item, data);
                    item.datetime = datetimeVal;
                    break;
                }
            }
        } else if (typeof datetimeVal === 'number') {
            // Ensure datetime is not changed and update item at the index
            data.datetime = src[datetimeVal].datetime;
            Object.assign(src[datetimeVal], data);
        } else {
            throw new Error(`Invalid input datetime value for updateItemByDatetimeVal with string or number: ${datetimeVal}`);
        }
    }

    /**
     * Fetch weather data for a specified location and date range.
     * 
     * @param {string} location - Location for which weather data is requested.
     * @param {string} fromDate - Start date of the weather data period (in `yyyy-MM-dd` format).
     * @param {string} toDate - End date of the weather data period (in `yyyy-MM-dd` format).
     * @param {string} unitGroup - Unit system for the weather data ('us', 'metric', 'uk' or 'base').
     * @param {string} include - Data types to include (e.g., 'days', 'hours').
     * @param {string} elements - Specific weather elements to retrieve.
     * @returns {Promise<object>} - The weather data as a dictionary.
     */
    async fetchWeatherData(location, fromDate = '', toDate = '', unitGroup = 'us', include = 'days', elements = '') {
        try {
            const params = new URLSearchParams({
                unitGroup,
                elements,
                include,
                key: this.apiKey
            });
            const url = `${BASE_URL}/${location}/${fromDate}/${toDate}?${params.toString()}`;

            const response = await fetch(url);
            this.#weatherData = await response.json();
            // console.log(this.#weatherData)
            return this.#weatherData

            // try {
            //     const response = await fetch(url);
            //     if (!response.ok) {
            //         throw new Error('Network response was not ok');
            //     }
            //     this.#weatherData = await response.json();
            //     console.log(this.#weatherData);
            // } catch (error) {
            //     console.error('There has been a problem with your fetch operation:', error);
            // }
        } catch (error) {
            throw new Error(error);
        }
    }

    /**
     * Get the stored weather data.
     * 
     * @param {Array<string>} elements - List of elements to include in the returned data.
     * @returns {object} - The weather data as a dictionary, filtered by elements if specified.
     */
    getWeatherData(elements = []) {
        try {
            if (elements.length > 0) {
                return extractSubobjectByKeys(this.#weatherData, elements);
            } else {
                return this.#weatherData;
            }
        } catch (error) {
            return null;
        }
    }

    /**
     * Set the internal weather data.
     * 
     * @param {object} data - Weather data to store.
     */
    setWeatherData(data) {
        this.#weatherData = data;
    }

    /**
     * Get daily weather data, optionally filtered by elements.
     * 
     * @param {Array<string>} elements - List of elements to include in the returned data.
     * @returns {Array<object>} - List of daily data dictionaries, filtered by elements if specified.
     */
    getWeatherDailyData(elements = []) {
        try {
            if (elements.length > 0) {
                return this.#weatherData.days.map(day => extractSubobjectByKeys(day, elements));
            } else {
                return this.#weatherData.days;
            }
        } catch (error) {
            return null;
        }
    }

    /**
     * Set the daily weather data.
     * 
     * @param {Array<object>} dailyData - List of daily weather data dictionaries.
     */
    setWeatherDailyData(dailyData) {
        this.#weatherData.days = dailyData;
    }

    /**
     * Get hourly weather data for all days, optionally filtered by elements.
     * 
     * @param {Array<string>} elements - List of elements to include in the returned data.
     * @returns {Array<object>} - List of hourly data dictionaries, filtered by elements if specified.
     */
    getWeatherHourlyData(elements = []) {
        try {
            const hourlyData = this.#weatherData.days.flatMap(day => day.hours);
            if (elements.length > 0) {
                return hourlyData.map(hourDt => extractSubobjectByKeys(hourDt, elements));
            } else {
                return hourlyData;
            }
        } catch (error) {
            return null;
        }
    }

    /**
     * Retrieves the cost of the query from the weather data.
     * 
     * @returns {number|null} - The cost of the query if available, otherwise null.
     */
    getQueryCost() {
        return this.#weatherData.queryCost || null;
    }

    /**
     * Sets the cost of the query in the weather data.
     * 
     * @param {number} value - The new cost to be set for the query.
     */
    setQueryCost(value) {
        this.#weatherData.queryCost = value;
    }

    /**
     * Retrieves the latitude from the weather data.
     * 
     * @returns {number|null} - The latitude if available, otherwise null.
     */
    getLatitude() {
        return this.#weatherData.latitude || null;
    }

    /**
     * Sets the latitude in the weather data.
     * 
     * @param {number} value - The new latitude to be set.
     */
    setLatitude(value) {
        this.#weatherData.latitude = value;
    }

    /**
     * Retrieves the longitude from the weather data.
     * 
     * @returns {number|null} - The longitude if available, otherwise null.
     */
    getLongitude() {
        return this.#weatherData.longitude || null;
    }

    /**
     * Sets the longitude in the weather data.
     * 
     * @param {number} value - The new longitude to be set.
     */
    setLongitude(value) {
        this.#weatherData.longitude = value;
    }

    /**
     * Retrieves the resolved address from the weather data.
     * 
     * @returns {string|null} - The resolved address if available, otherwise null.
     */
    getResolvedAddress() {
        return this.#weatherData.resolvedAddress || null;
    }

    /**
     * Sets the resolved address in the weather data.
     * 
     * @param {string} value - The new resolved address to be set.
     */
    setResolvedAddress(value) {
        this.#weatherData.resolvedAddress = value;
    }

    /**
     * Retrieves the address from the weather data.
     * 
     * @returns {string|null} - The address if available, otherwise null.
     */
    getAddress() {
        return this.#weatherData.address || null;
    }

    /**
     * Sets the address in the weather data.
     * 
     * @param {string} value - The new address to be set.
     */
    setAddress(value) {
        this.#weatherData.address = value;
    }

    /**
     * Retrieves the timezone from the weather data.
     * 
     * @returns {string|null} - The timezone if available, otherwise null.
     */
    getTimezone() {
        return this.#weatherData.timezone || null;
    }

    /**
     * Sets the timezone in the weather data.
     * 
     * @param {string} value - The new timezone to be set.
     */
    setTimezone(value) {
        this.#weatherData.timezone = value;
    }

    /**
     * Retrieves the timezone offset from the weather data.
     * 
     * @returns {number|null} - The timezone offset if available, otherwise null.
     */
    getTzoffset() {
        return this.#weatherData.tzoffset || null;
    }

    /**
     * Sets the timezone offset in the weather data.
     * 
     * @param {number} value - The new timezone offset to be set.
     */
    setTzoffset(value) {
        this.#weatherData.tzoffset = value;
    }

    /**
     * Retrieves the list of weather stations from the weather data.
     * 
     * @returns {Array} - The list of weather stations if available, otherwise an empty list.
     */
    getStations() {
        return this.#weatherData.stations || [];
    }

    /**
     * Sets the list of weather stations in the weather data.
     * 
     * @param {Array} value - The new list of weather stations to be set.
     */
    setStations(value) {
        this.#weatherData.stations = value;
    }

    /**
     * Retrieves a list of datetime objects representing each day's date from the weather data.
     * 
     * @returns {Array<Date>} - A list of Date objects parsed from the 'datetime' key of each day in the weather data.
     */
    getDailyDatetimes() {
        return this.#weatherData.days.map(day => new Date(day.datetime));
    }

    /**
     * Retrieves a list of datetime objects representing each hour's datetime from the weather data.
     * 
     * @returns {Array<Date>} - A list of Date objects parsed from the 'datetime' keys of each day and hour in the weather data.
     */
    getHourlyDatetimes() {
        return this.#weatherData.days.flatMap(day =>
            day.hours.map(hour => new Date(`${day.datetime}T${hour.datetime}`))
        );
    }

    /**
     * Retrieves weather data for a specific day based on a date string or index.
     * 
     * @param {string|number} dayInfo - The identifier for the day, which can be a date string (YYYY-MM-DD) or an index of the day list.
     * @param {Array<string>} elements - Specific weather elements to retrieve.
     * @returns {object|null} - The weather data dictionary for the specified day.
     */
    getDataOnDay(dayInfo, elements = []) {
        try {
            let dayData;
            if (typeof dayInfo === 'string') {
                dayData = this.#weatherData.days.find(day => day.datetime === dayInfo);
            } else if (typeof dayInfo === 'number') {
                dayData = this.#weatherData.days[dayInfo];
            } else {
                throw new ValueError(`Invalid input value for getDataOnDay() with str or int: ${dayInfo}`);
            }

            if (elements.length > 0) {
                return extractSubobjectByKeys(dayData, elements);
            } else {
                return dayData;
            }
        } catch (e) {
            console.error(`Error accessing data on this day: ${e}`);
            return null;
        }
    }

    /**
     * Updates weather data for a specific day based on a date string or index.
     * 
     * @param {string|number} dayInfo - The identifier for the day, which can be a date string (YYYY-MM-DD) or an index of the day list.
     * @param {object} data - The new weather data dictionary to replace the existing day's data.
     */
    setDataOnDay(dayInfo, data) {
        try {
            if (typeof dayInfo === 'string') {
                for (let i = 0; i < this.#weatherData.days.length; i++) {
                    if (this.#weatherData.days[i].datetime === dayInfo) {
                        this.#weatherData.days[i] = data;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo] = data;
            } else {
                throw new ValueError(`Invalid input day value for setDataOnDay() with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the temperature for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The temperature for the specified day.
     */
    getTempOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.temp || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.temp || null;
            } else {
                throw new ValueError(`Invalid input value for dayInfo: ${dayInfo}. Expected a date string or day index.`);
            }
        } catch (e) {
            console.error(`Error accessing temperature data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the temperature for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new temperature value to set.
     */
    setTempOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                let day = this.#weatherData.days.find(day => day.datetime === dayInfo);
                if (day) day.temp = value;
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].temp = value;
            } else {
                throw new ValueError(`Invalid input value for dayInfo: ${dayInfo}. Expected a date string or day index.`);
            }
        } catch (e) {
            throw new Error(`Error setting temperature data: ${e}`);
        }
    }

    /**
     * Retrieves the maximum temperature for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The maximum temperature for the specified day.
     */
    getTempmaxOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.tempmax || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.tempmax || null;
            } else {
                throw new ValueError(`Invalid input value for getTempmaxOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing maximum temperature data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the maximum temperature for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new maximum temperature value to set.
     */
    setTempmaxOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.tempmax = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].tempmax = value;
            } else {
                throw new ValueError(`Invalid input day value for setTempmaxOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting maximum temperature data: ${e}`);
        }
    }

    /**
     * Retrieves the minimum temperature for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The minimum temperature for the specified day.
     */
    getTempminOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.tempmin || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.tempmin || null;
            } else {
                throw new ValueError(`Invalid input value for getTempminOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing minimum temperature data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the minimum temperature for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new minimum temperature value to set.
     */
    setTempminOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.tempmin = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].tempmin = value;
            } else {
                throw new ValueError(`Invalid input day value for setTempminOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting minimum temperature data: ${e}`);
        }
    }

    /**
     * Retrieves the 'feels like' temperature for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The 'feels like' temperature for the specified day.
     */
    getFeelslikeOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.feelslike || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.feelslike || null;
            } else {
                throw new ValueError(`Invalid input value for getFeelslikeOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing 'feels like' temperature data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the 'feels like' temperature for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new 'feels like' temperature value to set.
     */
    setFeelslikeOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.feelslike = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].feelslike = value;
            } else {
                throw new ValueError(`Invalid input day value for setFeelslikeOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting 'feels like' temperature data: ${e}`);
        }
    }

    /**
     * Retrieves the maximum 'feels like' temperature for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The maximum 'feels like' temperature for the specified day.
     */
    getFeelslikemaxOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.feelslikemax || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.feelslikemax || null;
            } else {
                throw new ValueError(`Invalid input value for getFeelslikemaxOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing 'feels like max' temperature data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the maximum 'feels like' temperature for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new maximum 'feels like' temperature value to set.
     */
    setFeelslikemaxOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.feelslikemax = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].feelslikemax = value;
            } else {
                throw new ValueError(`Invalid input day value for setFeelslikemaxOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting 'feels like max' temperature data: ${e}`);
        }
    }

    /**
     * Retrieves the minimum 'feels like' temperature for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The minimum 'feels like' temperature for the specified day.
     */
    getFeelslikeminOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.feelslikemin || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.feelslikemin || null;
            } else {
                throw new ValueError(`Invalid input value for getFeelslikeminOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing 'feels like min' temperature data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the minimum 'feels like' temperature for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new minimum temperature value to set.
     */
    setFeelslikeminOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.feelslikemin = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].feelslikemin = value;
            } else {
                throw new ValueError(`Invalid input day value for setFeelslikeminOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting 'feels like min' temperature data: ${e}`);
        }
    }

    /**
     * Retrieves the dew point for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The dew point for the specified day.
     */
    getDewOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.dew || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.dew || null;
            } else {
                throw new ValueError(`Invalid input value for getDewOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing dew point data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the dew point for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new dew point value to set.
     */
    setDewOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.dew = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].dew = value;
            } else {
                throw new ValueError(`Invalid input day value for setDewOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting dew point data: ${e}`);
        }
    }


    /**
     * Retrieves the humidity percentage for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The humidity percentage for the specified day.
     */
    getHumidityOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.humidity || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.humidity || null;
            } else {
                throw new Error(`Invalid input value for getHumidityOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing humidity data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the humidity percentage for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new humidity percentage value to set.
     */
    setHumidityOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.humidity = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].humidity = value;
            } else {
                throw new Error(`Invalid input day value for setHumidityOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting humidity data: ${e}`);
        }
    }

    /**
     * Retrieves the precipitation amount for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The precipitation amount for the specified day.
     */
    getPrecipOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.precip || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.precip || null;
            } else {
                throw new Error(`Invalid input value for getPrecipOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing precipitation data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the precipitation amount for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new precipitation amount value to set.
     */
    setPrecipOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.precip = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].precip = value;
            } else {
                throw new Error(`Invalid input day value for setPrecipOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting precipitation data: ${e}`);
        }
    }

    /**
     * Retrieves the probability of precipitation for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The probability of precipitation for the specified day.
     */
    getPrecipprobOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.precipprob || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.precipprob || null;
            } else {
                throw new Error(`Invalid input value for getPrecipprobOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing precipitation probability data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the probability of precipitation for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new probability of precipitation value to set.
     */
    setPrecipprobOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.precipprob = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].precipprob = value;
            } else {
                throw new Error(`Invalid input day value for setPrecipprobOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting precipitation probability data: ${e}`);
        }
    }

    /**
     * Retrieves the precipitation coverage for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The precipitation coverage for the specified day.
     */
    getPrecipcoverOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.precipcover || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.precipcover || null;
            } else {
                throw new Error(`Invalid input value for getPrecipcoverOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing precipitation coverage data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the precipitation coverage for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new precipitation coverage value to set.
     */
    setPrecipcoverOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.precipcover = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].precipcover = value;
            } else {
                throw new Error(`Invalid input day value for setPrecipcoverOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting precipitation coverage data: ${e}`);
        }
    }

    /**
     * Retrieves the type of precipitation for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {string|null} - The type of precipitation for the specified day.
     */
    getPreciptypeOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.preciptype || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.preciptype || null;
            } else {
                throw new Error(`Invalid input value for getPreciptypeOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing precipitation type data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the type of precipitation for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {string} value - The new type of precipitation value to set.
     */
    setPreciptypeOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.preciptype = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].preciptype = value;
            } else {
                throw new Error(`Invalid input day value for setPreciptypeOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting precipitation type data: ${e}`);
        }
    }

    /**
     * Retrieves the snowfall amount for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The snowfall amount for the specified day.
     */
    getSnowOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.snow || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.snow || null;
            } else {
                throw new Error(`Invalid input value for getSnowOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing snow data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the snowfall amount for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new snowfall amount to set.
     */
    setSnowOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.snow = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].snow = value;
            } else {
                throw new Error(`Invalid input day value for setSnowOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting snow data: ${e}`);
        }
    }

    /**
     * Retrieves the snow depth for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The snow depth for the specified day.
     */
    getSnowdepthOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.snowdepth || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.snowdepth || null;
            } else {
                throw new Error(`Invalid input value for getSnowdepthOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing snow depth data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the snow depth for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new snow depth to set.
     */
    setSnowdepthOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.snowdepth = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].snowdepth = value;
            } else {
                throw new Error(`Invalid input day value for setSnowdepthOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting snow depth data: ${e}`);
        }
    }

    /**
     * Retrieves the wind gust value for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The wind gust value for the specified day.
     */
    getWindgustOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.windgust || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.windgust || null;
            } else {
                throw new Error(`Invalid input value for getWindgustOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing wind gust data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the wind gust value for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new wind gust value to set.
     */
    setWindgustOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.windgust = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].windgust = value;
            } else {
                throw new Error(`Invalid input day value for setWindgustOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting wind gust data: ${e}`);
        }
    }

    /**
     * Retrieves the wind speed for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The wind speed for the specified day.
     */
    getWindspeedOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.windspeed || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.windspeed || null;
            } else {
                throw new Error(`Invalid input value for getWindspeedOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing wind speed data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the wind speed for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new wind speed value to set.
     */
    setWindspeedOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.windspeed = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].windspeed = value;
            } else {
                throw new Error(`Invalid input day value for setWindspeedOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting wind speed data: ${e}`);
        }
    }

    /**
     * Retrieves the wind direction for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The wind direction for the specified day.
     */
    getWinddirOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.winddir || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.winddir || null;
            } else {
                throw new Error(`Invalid input value for getWinddirOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing wind direction data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the wind direction for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new wind direction value to set.
     */
    setWinddirOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.winddir = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].winddir = value;
            } else {
                throw new Error(`Invalid input day value for setWinddirOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting wind direction data: ${e}`);
        }
    }

    /**
     * Retrieves the atmospheric pressure for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The atmospheric pressure for the specified day.
     */
    getPressureOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.pressure || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.pressure || null;
            } else {
                throw new Error(`Invalid input value for getPressureOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing pressure data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the atmospheric pressure for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new pressure value to set.
     */
    setPressureOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.pressure = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].pressure = value;
            } else {
                throw new Error(`Invalid input day value for setPressureOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting pressure data: ${e}`);
        }
    }

    /**
     * Retrieves the cloud cover percentage for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The cloud cover percentage for the specified day.
     */
    getCloudcoverOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.cloudcover || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.cloudcover || null;
            } else {
                throw new Error(`Invalid input value for getCloudcoverOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing cloud cover data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the cloud cover percentage for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new cloud cover percentage to set.
     */
    setCloudcoverOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.cloudcover = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].cloudcover = value;
            } else {
                throw new Error(`Invalid input day value for setCloudcoverOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting cloud cover data: ${e}`);
        }
    }

    /**
     * Retrieves the visibility distance for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The visibility distance for the specified day.
     */
    getVisibilityOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.visibility || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.visibility || null;
            } else {
                throw new Error(`Invalid input value for getVisibilityOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing visibility data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the visibility distance for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new visibility distance to set.
     */
    setVisibilityOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.visibility = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].visibility = value;
            } else {
                throw new Error(`Invalid input day value for setVisibilityOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting visibility data: ${e}`);
        }
    }

    /**
     * Retrieves the solar radiation level for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The solar radiation level for the specified day.
     */
    getSolarradiationOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.solarradiation || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.solarradiation || null;
            } else {
                throw new Error(`Invalid input value for getSolarradiationOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing solar radiation data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the solar radiation level for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new solar radiation level to set.
     */
    setSolarradiationOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.solarradiation = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].solarradiation = value;
            } else {
                throw new Error(`Invalid input day value for setSolarradiationOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting solar radiation data: ${e}`);
        }
    }

    /**
     * Retrieves the solar energy generated on a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The solar energy generated on the specified day.
     */
    getSolarenergyOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.solarenergy || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.solarenergy || null;
            } else {
                throw new Error(`Invalid input value for getSolarenergyOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing solar energy data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the solar energy level for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new solar energy level to set.
     */
    setSolarenergyOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.solarenergy = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].solarenergy = value;
            } else {
                throw new Error(`Invalid input day value for setSolarenergyOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting solar energy data: ${e}`);
        }
    }

    /**
     * Retrieves the UV index for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The UV index for the specified day.
     */
    getUvindexOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.uvindex || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.uvindex || null;
            } else {
                throw new Error(`Invalid input value for getUvindexOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing UV index data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the UV index for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new UV index value to set.
     */
    setUvindexOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.uvindex = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].uvindex = value;
            } else {
                throw new Error(`Invalid input day value for setUvindexOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting UV index data: ${e}`);
        }
    }

    /**
     * Retrieves the severe weather risk level for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The severe weather risk level for the specified day.
     */
    getSevereriskOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.severerisk || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.severerisk || null;
            } else {
                throw new Error(`Invalid input value for getSevereriskOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing severe risk data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the severe weather risk level for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new severe weather risk level to set.
     */
    setSevereriskOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.severerisk = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].severerisk = value;
            } else {
                throw new Error(`Invalid input day value for setSevereriskOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting severe risk data: ${e}`);
        }
    }

    /**
     * Retrieves the sunrise time for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {string|null} - The sunrise time for the specified day.
     */
    getSunriseOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.sunrise || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.sunrise || null;
            } else {
                throw new Error(`Invalid input value for getSunriseOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing sunrise data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the sunrise time for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {string} value - The new sunrise time value to set.
     */
    setSunriseOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.sunrise = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].sunrise = value;
            } else {
                throw new Error(`Invalid input day value for setSunriseOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting sunrise data: ${e}`);
        }
    }

    /**
     * Retrieves the Unix timestamp for the sunrise time for a specific day.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The sunrise Unix timestamp for the specified day.
     */
    getSunriseEpochOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.sunriseEpoch || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.sunriseEpoch || null;
            } else {
                throw new Error(`Invalid input value for getSunriseEpochOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing sunrise epoch data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the Unix timestamp for the sunrise time for a specific day.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new sunrise Unix timestamp value to set.
     */
    setSunriseEpochOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.sunriseEpoch = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].sunriseEpoch = value;
            } else {
                throw new Error(`Invalid input day value for setSunriseEpochOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting sunrise epoch data: ${e}`);
        }
    }

    /**
     * Retrieves the sunset time for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {string|null} - The sunset time for the specified day.
     */
    getSunsetOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.sunset || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.sunset || null;
            } else {
                throw new Error(`Invalid input value for getSunsetOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing sunset data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the sunset time for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {string} value - The new sunset time value to set.
     */
    setSunsetOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.sunset = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].sunset = value;
            } else {
                throw new Error(`Invalid input day value for setSunsetOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting sunset data: ${e}`);
        }
    }

    /**
     * Retrieves the Unix timestamp for the sunset time for a specific day.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The sunset Unix timestamp for the specified day.
     */
    getSunsetEpochOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.sunsetEpoch || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.sunsetEpoch || null;
            } else {
                throw new Error(`Invalid input value for getSunsetEpochOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing sunset epoch data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the Unix timestamp for the sunset time for a specific day.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new sunset Unix timestamp value to set.
     */
    setSunsetEpochOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.sunsetEpoch = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].sunsetEpoch = value;
            } else {
                throw new Error(`Invalid input day value for setSunsetEpochOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting sunset epoch data: ${e}`);
        }
    }

    /**
     * Retrieves the moon phase for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {number|null} - The moon phase for the specified day.
     */
    getMoonphaseOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.moonphase || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.moonphase || null;
            } else {
                throw new Error(`Invalid input value for getMoonphaseOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing moon phase data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the moon phase for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {number} value - The new moon phase value to set.
     */
    setMoonphaseOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.moonphase = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].moonphase = value;
            } else {
                throw new Error(`Invalid input day value for setMoonphaseOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting moon phase data: ${e}`);
        }
    }

    /**
     * Retrieves the weather conditions for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {string|null} - The weather conditions for the specified day.
     */
    getConditionsOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.conditions || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.conditions || null;
            } else {
                throw new Error(`Invalid input value for getConditionsOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing conditions data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the weather conditions for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {string} value - The new conditions value to set.
     */
    setConditionsOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.conditions = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].conditions = value;
            } else {
                throw new Error(`Invalid input day value for setConditionsOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting conditions data: ${e}`);
        }
    }

    /**
     * Retrieves the weather description for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {string|null} - The weather description for the specified day.
     */
    getDescriptionOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.description || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.description || null;
            } else {
                throw new Error(`Invalid input value for getDescriptionOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing description data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the weather description for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {string} value - The new description to set.
     */
    setDescriptionOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.description = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].description = value;
            } else {
                throw new Error(`Invalid input day value for setDescriptionOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting description data: ${e}`);
        }
    }

    /**
     * Retrieves the weather icon for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {string|null} - The weather icon for the specified day.
     */
    getIconOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.icon || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.icon || null;
            } else {
                throw new Error(`Invalid input value for getIconOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing icon data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the weather icon for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {string} value - The new icon to set.
     */
    setIconOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.icon = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].icon = value;
            } else {
                throw new Error(`Invalid input day value for setIconOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting icon data: ${e}`);
        }
    }

    /**
     * Retrieves the weather stations data for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @returns {Array|null} - The list of weather stations active on the specified day.
     */
    getStationsOnDay(dayInfo) {
        try {
            if (typeof dayInfo === 'string') {
                return this.#weatherData.days.find(day => day.datetime === dayInfo)?.stations || null;
            } else if (typeof dayInfo === 'number') {
                return this.#weatherData.days[dayInfo]?.stations || null;
            } else {
                throw new Error(`Invalid input value for getStationsOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            console.error(`Error accessing stations data: ${e}`);
            return null;
        }
    }

    /**
     * Sets the weather stations data for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {Array} value - The new list of weather stations to set.
     */
    setStationsOnDay(dayInfo, value) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.stations = value;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].stations = value;
            } else {
                throw new Error(`Invalid input day value for setStationsOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting stations data: ${e}`);
        }
    }

    /**
     * Retrieves hourly weather data for a specific day identified by date or index.
     * Optionally filters the data to include only specified elements.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {Array} elements - Optional list of keys to filter the hourly data.
     * @returns {Array} - A list of hourly data dictionaries for the specified day.
     */
    getHourlyDataOnDay(dayInfo, elements = []) {
        try {
            let hourlyData;
            if (typeof dayInfo === 'string') {
                hourlyData = this.#weatherData.days.find(day => day.datetime === dayInfo)?.hours || [];
            } else if (typeof dayInfo === 'number') {
                hourlyData = this.#weatherData.days[dayInfo]?.hours || [];
            } else {
                throw new Error(`Invalid input value for getHourlyDataOnDay with str or int: ${dayInfo}`);
            }

            if (elements.length > 0) {
                return hourlyData.map(hour => {
                    const filtered = {};
                    elements.forEach(el => {
                        filtered[el] = hour[el];
                    });
                    return filtered;
                });
            }
            return hourlyData;
        } catch (e) {
            throw new Error(`Error retrieving hourly data: ${e}`);
        }
    }

    /**
     * Sets the hourly weather data for a specific day identified by date or index.
     * 
     * @param {string|number} dayInfo - The day's date as a string ('YYYY-MM-DD') or index as an integer.
     * @param {Array} data - The new list of hourly weather data dictionaries to set.
     */
    setHourlyDataOnDay(dayInfo, data) {
        try {
            if (typeof dayInfo === 'string') {
                for (let day of this.#weatherData.days) {
                    if (day.datetime === dayInfo) {
                        day.hours = data;
                        break;
                    }
                }
            } else if (typeof dayInfo === 'number') {
                this.#weatherData.days[dayInfo].hours = data;
            } else {
                throw new Error(`Invalid input day value for setHourlyDataOnDay with str or int: ${dayInfo}`);
            }
        } catch (e) {
            throw new Error(`Error setting hourly data: ${e}`);
        }
    }


    /**
     * Retrieves weather data for a specific date and time from the weather data collection.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index, pointing to a specific day in the data.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index, pointing to a specific time slot in the day's data.
     * @param {Array} elements - Specific weather elements to retrieve.
     * @returns {Object} The specific hourly data dictionary corresponding to the given day and time.
     * @throws {Error} Propagates any exceptions that may occur during data retrieval.
     */
    getDataAtDatetime(dayInfo, timeInfo, elements = []) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            const data = Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo);
            if (elements.length) {
                return extractSubobjectByKeys(data, elements);
            } else {
                return data;
            }
        } catch (e) {
            throw e;
        }
    }

    /**
     * Sets weather data for a specific date and time in the weather data collection.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index, pointing to a specific day in the data.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index, pointing to a specific time slot in the day's data.
     * @param {Object} data - The data dictionary to be set for the specific hourly time slot.
     * @throws {Error} Propagates any exceptions that may occur during data setting.
     */
    setDataAtDatetime(dayInfo, timeInfo, data) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            Weather.setItemByDatetimeVal(dayItem.hours, timeInfo, data);
        } catch (e) {
            throw e;
        }
    }

    /**
     * Updates weather data for a specific date and time in the weather data collection.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index, pointing to a specific day in the data.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index, pointing to a specific time slot in the day's data.
     * @param {Object} data - The data dictionary to be updated for the specific hourly time slot.
     * @throws {Error} Propagates any exceptions that may occur during data setting.
     */
    updateDataAtDatetime(dayInfo, timeInfo, data) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            Weather.updateItemByDatetimeVal(dayItem.hours, timeInfo, data);
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the epoch time for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} The epoch time corresponding to the specific day and time.
     * @throws {Error} Logs any exceptions that may occur during the retrieval.
     */
    getDatetimeEpochAtDatetime(dayInfo, timeInfo) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).datetimeEpoch;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the epoch time for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The epoch time value to be set.
     * @throws {Error} Propagates any exceptions that may occur during the setting process.
     */
    setDatetimeEpochAtDatetime(dayInfo, timeInfo, value) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).datetimeEpoch = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the temperature for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} The temperature at the specified datetime.
     * @throws {Error} Logs any exceptions that may occur during the retrieval.
     */
    getTempAtDatetime(dayInfo, timeInfo) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).temp;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the temperature for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The temperature value to be set.
     * @throws {Error} Propagates any exceptions that may occur during the setting process.
     */
    setTempAtDatetime(dayInfo, timeInfo, value) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).temp = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the 'feels like' temperature for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} The 'feels like' temperature at the specified datetime.
     * @throws {Error} Logs any exceptions that may occur during the retrieval.
     */
    getFeelsLikeAtDatetime(dayInfo, timeInfo) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).feelslike;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the 'feels like' temperature for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The 'feels like' temperature value to be set.
     * @throws {Error} Propagates any exceptions that may occur during the setting process.
     */
    setFeelsLikeAtDatetime(dayInfo, timeInfo, value) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).feelslike = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the humidity for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} The humidity percentage at the specified datetime.
     * @throws {Error} Logs any exceptions that may occur during the retrieval.
     */
    getHumidityAtDatetime(dayInfo, timeInfo) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).humidity;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the humidity for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The humidity percentage to be set.
     * @throws {Error} Propagates any exceptions that may occur during the setting process.
     */
    setHumidityAtDatetime(dayInfo, timeInfo, value) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).humidity = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the dew point temperature for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} The dew point temperature at the specified datetime.
     * @throws {Error} Logs any exceptions that may occur during the retrieval.
     */
    getDewAtDatetime(dayInfo, timeInfo) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).dew;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the dew point temperature for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The dew point temperature to be set.
     * @throws {Error} Propagates any exceptions that may occur during the setting process.
     */
    setDewAtDatetime(dayInfo, timeInfo, value) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).dew = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the precipitation amount for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} The precipitation amount at the specified datetime.
     * @throws {Error} Logs any exceptions that may occur during the retrieval.
     */
    getPrecipAtDatetime(dayInfo, timeInfo) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).precip;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the precipitation amount for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The precipitation amount to be set.
     * @throws {Error} Propagates any exceptions that may occur during the setting process.
     */
    setPrecipAtDatetime(dayInfo, timeInfo, value) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).precip = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the probability of precipitation for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} The probability of precipitation at the specified datetime.
     * @throws {Error} Logs any exceptions that may occur during the retrieval.
     */
    getPrecipProbAtDatetime(dayInfo, timeInfo) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).precipprob;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the probability of precipitation for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The probability of precipitation to be set.
     * @throws {Error} Propagates any exceptions that may occur during the setting process.
     */
    setPrecipProbAtDatetime(dayInfo, timeInfo, value) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).precipprob = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the snow amount for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} The snow amount at the specified datetime.
     * @throws {Error} Logs any exceptions that may occur during the retrieval.
     */
    getSnowAtDatetime(dayInfo, timeInfo) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).snow;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the snow amount for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The snow amount to be set.
     * @throws {Error} Propagates any exceptions that may occur during the setting process.
     */
    setSnowAtDatetime(dayInfo, timeInfo, value) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).snow = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the snow depth for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} The snow depth at the specified datetime.
     * @throws {Error} Logs any exceptions that may occur during the retrieval.
     */
    getSnowDepthAtDatetime(dayInfo, timeInfo) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).snowdepth;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }


    /**
     * Sets the snow depth for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The snow depth to be set.
     * @throws {Error} Propagates any exceptions that may occur during the setting process.
     */
    setSnowDepthAtDatetime(dayInfo, timeInfo, value) {
        try {
            const dayItem = Weather.filterItemByDatetimeVal(this.#weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).snowdepth = value;
        } catch (e) {
            throw e;
        }
    }

    /**
 * Retrieves the type of precipitation for a specific datetime within the weather data.
 *
 * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
 * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
 * @returns {string} - The type of precipitation at the specified datetime.
 */
    getPreciptypeAtDatetime(dayInfo, timeInfo) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).preciptype;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the type of precipitation for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {string} value - The type of precipitation to be set.
     */
    setPreciptypeAtDatetime(dayInfo, timeInfo, value) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).preciptype = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the wind gust speed for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} - The wind gust speed at the specified datetime.
     */
    getWindgustAtDatetime(dayInfo, timeInfo) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).windgust;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the wind gust speed for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The wind gust speed to be set.
     */
    setWindgustAtDatetime(dayInfo, timeInfo, value) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).windgust = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the wind speed for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} - The wind speed at the specified datetime.
     */
    getWindspeedAtDatetime(dayInfo, timeInfo) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).windspeed;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the wind speed for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The wind speed to be set.
     */
    setWindspeedAtDatetime(dayInfo, timeInfo, value) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).windspeed = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the wind direction for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} - The wind direction at the specified datetime.
     */
    getWinddirAtDatetime(dayInfo, timeInfo) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).winddir;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the wind direction for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The wind direction to be set.
     */
    setWinddirAtDatetime(dayInfo, timeInfo, value) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).winddir = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the atmospheric pressure for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} - The atmospheric pressure at the specified datetime.
     */
    getPressureAtDatetime(dayInfo, timeInfo) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).pressure;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the atmospheric pressure for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The atmospheric pressure to be set.
     */
    setPressureAtDatetime(dayInfo, timeInfo, value) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).pressure = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the visibility for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} - The visibility at the specified datetime.
     */
    getVisibilityAtDatetime(dayInfo, timeInfo) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).visibility;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the visibility for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The visibility to be set.
     */
    setVisibilityAtDatetime(dayInfo, timeInfo, value) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).visibility = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the cloud cover for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} - The cloud cover at the specified datetime.
     */
    getCloudcoverAtDatetime(dayInfo, timeInfo) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).cloudcover;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the cloud cover for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The cloud cover to be set.
     */
    setCloudcoverAtDatetime(dayInfo, timeInfo, value) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).cloudcover = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the solar radiation for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} - The solar radiation at the specified datetime.
     */
    getSolarradiationAtDatetime(dayInfo, timeInfo) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).solarradiation;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the solar radiation for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The solar radiation to be set.
     */
    setSolarradiationAtDatetime(dayInfo, timeInfo, value) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).solarradiation = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the solar energy for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} - The solar energy at the specified datetime.
     */
    getSolarenergyAtDatetime(dayInfo, timeInfo) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).solarenergy;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the solar energy for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The solar energy to be set.
     */
    setSolarenergyAtDatetime(dayInfo, timeInfo, value) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).solarenergy = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the UV index for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} - The UV index at the specified datetime.
     */
    getUvindexAtDatetime(dayInfo, timeInfo) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).uvindex;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the UV index for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The UV index to be set.
     */
    setUvindexAtDatetime(dayInfo, timeInfo, value) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).uvindex = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the severe risk for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {number} - The severe risk at the specified datetime.
     */
    getSevereriskAtDatetime(dayInfo, timeInfo) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).severerisk;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the severe risk for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {number} value - The severe risk to be set.
     */
    setSevereriskAtDatetime(dayInfo, timeInfo, value) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).severerisk = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the conditions for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {string} - The conditions at the specified datetime.
     */
    getConditionsAtDatetime(dayInfo, timeInfo) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).conditions;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the conditions for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {string} value - The conditions to be set.
     */
    setConditionsAtDatetime(dayInfo, timeInfo, value) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).conditions = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the weather icon for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {string} - The weather icon at the specified datetime.
     */
    getIconAtDatetime(dayInfo, timeInfo) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).icon;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the weather icon for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {string} value - The weather icon to be set.
     */
    setIconAtDatetime(dayInfo, timeInfo, value) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).icon = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the weather stations that were used for creating the observation for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {string[]} - The weather stations that were used for creating the observation at the specified datetime.
     */
    getStationsAtDatetime(dayInfo, timeInfo) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).stations;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the weather stations that were used for creating the observation for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {string[]} value - The weather stations to be set.
     */
    setStationsAtDatetime(dayInfo, timeInfo, value) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).stations = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Retrieves the type of weather data used for this weather object for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @returns {string} - The type of weather data used for this weather object at the specified datetime.
     *                     Values include historical observation (“obs”), forecast (“fcst”), historical forecast (“histfcst”) or statistical forecast (“stats”).
     *                     If multiple types are used in the same day, “comb” is used. Today a combination of historical observations and forecast data.
     */
    getSourceAtDatetime(dayInfo, timeInfo) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            return Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).source;
        } catch (e) {
            console.error(`An exception occurred: ${e.name} -> ${e.message}`);
        }
    }

    /**
     * Sets the type of weather data used for this weather object for a specific datetime within the weather data.
     *
     * @param {string|number} dayInfo - A day identifier, which can be a date string (YYYY-MM-DD) or an index.
     * @param {string|number} timeInfo - A time identifier, which can be a time string (HH:MM:SS) or an index.
     * @param {string} value - The type of weather data to be set.
     */
    setSourceAtDatetime(dayInfo, timeInfo, value) {
        try {
            let dayItem = Weather.filterItemByDatetimeVal(this.weatherData.days, dayInfo);
            Weather.filterItemByDatetimeVal(dayItem.hours, timeInfo).source = value;
        } catch (e) {
            throw e;
        }
    }

    /**
     * Clear the weather data of the class
     */
    clearWeatherData() {
        this.#weatherData = {};
    }
}

module.exports = { 
    Weather,
    updateObject,
    isValidObject,
    extractSubobjectByKeys
};
