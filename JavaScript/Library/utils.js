// utils.js

/**
 * Update the original Object with values from the updates Object,
 * excluding keys specified in excludeKeys.
 *
 * @param {Object} original - The original Object to update.
 * @param {Object} updates - The Object with update values.
 * @param {Array} excludeKeys - A list of keys to exclude from updating.
 */
function updateObject(original, updates, excludeKeys = []) {
    for (const [key, value] of Object.entries(updates)) {
        if (!excludeKeys.includes(key)) {
            original[key] = value;
        }
    }
}

/**
 * Check if the variable is a Object and if all its keys are in the allowed keys.
 *
 * @param {Object} variable - The variable to check.
 * @param {Array} allowedKeys - A list of allowed keys.
 * @return {boolean} - True if variable is a Object and all keys are in allowedKeys, false otherwise.
 */
function isValidObject(variable, allowedKeys) {
    if (typeof variable === 'object' && !Array.isArray(variable) && variable !== null) {
        return Object.keys(variable).every(key => allowedKeys.includes(key));
    }
    return false;
}

/**
 * Extract a sub-Object from the original Object with keys specified in keysList.
 *
 * @param {Object} originalDict - The original Object to extract from.
 * @param {Array} keysList - A list of keys to include in the sub-Object.
 * @return {Object} - A sub-Object containing only the specified keys.
 */
function extractSubobjectByKeys(originalDict, keysList) {
    const subDict = {};
    keysList.forEach(key => {
        if (key in originalDict) {
            subDict[key] = originalDict[key];
        }
    });
    return subDict;
}

// Export functions for use in other modules
module.exports = {
    updateObject,
    isValidObject,
    extractSubobjectByKeys
};

// Test cases
if (require.main === module) {
    const originalDict = { name: 'Alice', age: 30, location: 'New York', email: 'alice@example.com' };
    const updatesDict = { name: 'Alice Smith', age: 31, location: 'Los Angeles', email: 'alice.smith@example.com' };
    const keysToExclude = ['email'];

    // Case: Test with a Object
    updateObject(originalDict, updatesDict, keysToExclude);
    console.log(originalDict);

    const allowedKeys = ['name', 'age', 'email'];

    // Case 1: Test with a valid Object
    const validDict = { name: 'Alice', age: 30 };
    console.log(isValidObject(validDict, allowedKeys));  // Output: true

    // Case 2: Test with an invalid Object (extra key)
    const invalidDict = { name: 'Bob', age: 25, location: 'City' };
    console.log(isValidObject(invalidDict, allowedKeys));  // Output: false

    // Case 3: Test with a non-Object variable
    const notADict = ['name', 'Alice'];
    console.log(isValidObject(notADict, allowedKeys));  // Output: false

    const originalDict2 = {
        name: 'John Doe',
        age: 30,
        email: 'johndoe@example.com',
        country: 'USA'
    };
    const keysList = ['name', 'email'];

    // Extracting the sub-Object
    const subDict = extractSubobjectByKeys(originalDict2, keysList);
    console.log(subDict);  // Output will be { name: 'John Doe', email: 'johndoe@example.com' }
}
