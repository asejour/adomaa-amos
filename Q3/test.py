import unittest
from app import app

class TestJenkins(unittest.TestCase):
    def setUp(self):
        app.testing = True
        self.app = app.test_client()

    def test_jenkins(self):
        response = self.app.get('/')
        self.assertEqual(response.status, "200 OK")
        
if __name__ == "__main__":
    unittest.main()