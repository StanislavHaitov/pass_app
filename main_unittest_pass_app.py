import unittest
from pass_app import app

class FlaskAppTests(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    def test_get_passwords_without_master_password(self):
        response = self.app.get('/password/')
        self.assertEqual(response.status_code, 401)
        self.assertIn(b"Master password required", response.data)

    def test_get_passwords_with_master_password(self):
        response = self.app.get('/passwords/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b"example.com", response.data)
        self.assertIn(b"github.com", response.data)
        self.assertIn(b"email.com", response.data)

    def test_get_password_by_id_without_master_password(self):
        response = self.app.get('/api/passwords/1/')
        self.assertEqual(response.status_code, 401)
        self.assertIn(b"Master password required", response.data)

    def test_get_password_by_id_with_master_password(self):
        response = self.app.get('/api/passwords/1/?pass=masterpass')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b"example.com", response.data)

    def test_get_password_by_invalid_id_with_master_password(self):
        response = self.app.get('/api/passwords/99/?pass=masterpass')
        self.assertEqual(response.status_code, 404)
        self.assertIn(b"Password not found", response.data)

if __name__ == '__main__':
    unittest.main()
