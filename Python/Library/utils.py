__all__ = ['update_dictionary', 'is_valid_dict', 'extract_subdict_by_keys']

def update_dictionary(original, updates, exclude_keys=[]):
    """
    Update the original dictionary with values from the updates dictionary,
    excluding keys specified in exclude_keys.

    :param original: The original dictionary to update.
    :param updates: The dictionary with update values.
    :param exclude_keys: A list of keys to exclude from updating.
    """
    for key, value in updates.items():
        if key not in exclude_keys:
            original[key] = value

def is_valid_dict(variable, allowed_keys):
    """
    Check if the variable is a dictionary and if all its keys are in the allowed keys.

    :param variable: The variable to check.
    :param allowed_keys: A list of allowed keys.
    :return: True if variable is a dictionary and all keys are in allowed_keys, False otherwise.
    """
    if isinstance(variable, dict):
        # Check if all keys in the dictionary are in the allowed keys
        return all(key in allowed_keys for key in variable.keys())
    return False

def extract_subdict_by_keys(original_dict, keys_list):
    """
    Extract a sub-dictionary from the original dictionary with keys specified in keys_list.

    :param original_dict: The original dictionary to extract from.
    :param keys_list: A list of keys to include in the sub-dictionary.
    :return: A sub-dictionary containing only the specified keys.
    """
    # Create a sub-dictionary with keys from keys_list if they exist in original_dict
    return {key: original_dict[key] for key in keys_list if key in original_dict}


if __name__ == "__main__":
    # ***test***

    original_dict = {'name': 'Alice', 'age': 30, 'location': 'New York', 'email': 'alice@example.com'}
    updates_dict = {'name': 'Alice Smith', 'age': 31, 'location': 'Los Angeles', 'email': 'alice.smith@example.com'}
    keys_to_exclude = ['email']
    # Case: Text with a dictionary
    update_dictionary(original_dict, updates_dict, keys_to_exclude)
    print(original_dict)

    allowed_keys = ['name', 'age', 'email']
    # Case 1: Test with a valid dictionary
    valid_dict = {'name': 'Alice', 'age': 30}
    print(is_valid_dict(valid_dict, allowed_keys))  # Output: True
    # Case 2:Test with an invalid dictionary (extra key)
    invalid_dict = {'name': 'Bob', 'age': 25, 'location': 'City'}
    print(is_valid_dict(invalid_dict, allowed_keys))  # Output: False
    # Case 3: Test with a non-dictionary variable
    not_a_dict = ['name', 'Alice']
    print(is_valid_dict(not_a_dict, allowed_keys))  # Output: False

    original_dict = {
        'name': 'John Doe',
        'age': 30,
        'email': 'johndoe@example.com',
        'country': 'USA'
    }
    keys_list = ['name', 'email']
    # Extracting the sub-dictionary
    sub_dict = extract_subdict_by_keys(original_dict, keys_list)
    print(sub_dict)  # Output will be {'name': 'John Doe', 'email': 'johndoe@example.com'}