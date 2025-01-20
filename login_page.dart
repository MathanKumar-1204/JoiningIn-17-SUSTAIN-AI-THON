import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dashboard_page.dart'; // Import the DashboardPage class
import 'register_page.dart'; // Import the RegisterPage class

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showMessage('Please enter both username and password.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Fetch users from the database
      final snapshot = await _database.child('users').get();

      if (snapshot.exists) {
        final users = Map<String, dynamic>.from(snapshot.value as Map);

        // Check if the username and password match
        final user = users.values.firstWhere(
          (user) => user['username'] == username && user['password'] == password,
          orElse: () => null,
        );

        if (user != null) {
          // Navigate to DashboardPage on successful login
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage(username: username)),
          );
        } else {
          _showMessage('Invalid username or password.');
        }
      } else {
        _showMessage('No users found in the database.');
      }
    } catch (e) {
      _showMessage('Error: ${e.toString()}');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade800,
                blurRadius: 20,
                spreadRadius: 2,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ease Mind',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Mental wellness, Simplified',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade300,
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _usernameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Login'),
                    ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Add your forgot password logic here
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.grey.shade300),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Don't have an account?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade300),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }
}
