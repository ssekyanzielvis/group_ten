import 'package:flutter/material.dart';
import '../widgets/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  String? errorMessage = '';

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await _authService.signUp(
          _emailController.text, _passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text(
      'Sign Up',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage ?? 'Failed due to incorrect data',
      style: TextStyle(
        color: Colors.red,
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: createUserWithEmailAndPassword,
      child: Text('Sign Up'),
      style: ElevatedButton.styleFrom(
        iconColor: Colors.orange,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.fastfood,
                  size: 100.0,
                  color: Colors.orange,
                ),
                SizedBox(height: 50.0),
                _title(),
                SizedBox(height: 20.0),
                _entryField('Email', _emailController),
                SizedBox(height: 20.0),
                _entryField('Password', _passwordController, isPassword: true),
                SizedBox(height: 20.0),
                _errorMessage(),
                SizedBox(height: 20.0),
                _submitButton(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
