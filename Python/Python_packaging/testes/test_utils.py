# test_utils.py
import unittest
from weather import update_dictionary, is_valid_dict, extract_subdict_by_keys

class TestUtils(unittest.TestCase):
    def test_update_dictionary(self):
        original_dict = {'name': 'Alice', 'age': 30, 'location': 'New York', 'email': 'alice@example.com'}
        updates_dict = {'name': 'Alice Smith', 'age': 31, 'location': 'Los Angeles', 'email': 'alice.smith@example.com'}
        keys_to_exclude = ['email']
        update_dictionary(original_dict, updates_dict, keys_to_exclude)
        self.assertEqual(original_dict, {'name': 'Alice Smith', 'age': 31, 'location': 'Los Angeles', 'email': 'alice@example.com'})

    def test_is_valid_dict(self):
        allowed_keys = ['name', 'age', 'email']
        valid_dict = {'name': 'Alice', 'age': 30}
        invalid_dict = {'name': 'Bob', 'age': 25, 'location': 'City'}
        not_a_dict = ['name', 'Alice']
        self.assertTrue(is_valid_dict(valid_dict, allowed_keys))
        self.assertFalse(is_valid_dict(invalid_dict, allowed_keys))
        self.assertFalse(is_valid_dict(not_a_dict, allowed_keys))

    def test_extract_subdict_by_keys(self):
        original_dict = {'name': 'John Doe', 'age': 30, 'email': 'johndoe@example.com', 'country': 'USA'}
        keys_list = ['name', 'email']
        sub_dict = extract_subdict_by_keys(original_dict, keys_list)
        self.assertEqual(sub_dict, {'name': 'John Doe', 'email': 'johndoe@example.com'})

if __name__ == "__main__":
    unittest.main()
