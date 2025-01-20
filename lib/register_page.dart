import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Firebase Realtime Database
import 'login_page.dart'; // Import LoginPage
import 'question_page.dart'; // Import QuestionPage

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();

  final DatabaseReference _database = FirebaseDatabase.instance.ref('users'); // Reference to "users"

  void _registerUser() async {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;
    final String profession = _professionController.text.trim();

    if (username.isEmpty || password.isEmpty || profession.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      // Check if username already exists
      DataSnapshot snapshot = await _database.child(username).get();
      if (snapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username already exists')),
        );
        return;
      }

      // Add user data to Firebase Realtime Database with username as the key
      await _database.child(username).set({
        'username': username,
        'password': password,
        'profession': profession,
      });

      // Registration successful message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful!')),
      );

      // Navigate to QuestionPage with the username
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuestionPage(username: username)),
      );

      // Clear input fields
      _usernameController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _professionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade900,
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Row(
            children: [
              // Logo Section
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ease Mind',
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Mental wellness, Simplified',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Credentials Form
              Expanded(
                flex: 5,
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Username',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your username',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Password',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Confirm Password',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Confirm your password',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Profession',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      TextField(
                        controller: _professionController,
                        decoration: InputDecoration(
                          hintText: 'Enter your profession',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _registerUser,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.all(15),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                        child: Text('Register'),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Already an existing user?',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to LoginPage on Login click
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
