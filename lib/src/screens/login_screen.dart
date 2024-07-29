import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_dash/src/screens/signup_screen.dart';
import '../widgets/auth_service.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await _authService.signIn(
          _emailController.text, _passwordController.text);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      User? user = await _authService.signInWithGoogle();
      if (user != null) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          errorMessage = 'Failed to sign in with Google';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage ?? '',
      style: const TextStyle(
        color: Colors.red,
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: signInWithEmailAndPassword,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            const Color.fromARGB(255, 242, 75, 24), // Facebook blue
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: const TextStyle(fontSize: 18),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      child: const Text('Login', style: TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor:
            const Color.fromARGB(255, 242, 89, 24), // Facebook blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _entryField('Email', _emailController),
                const SizedBox(height: 20.0),
                _entryField('Password', _passwordController, isPassword: true),
                const SizedBox(height: 20.0),
                _errorMessage(),
                const SizedBox(height: 20.0),
                _submitButton(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text("You're new? Sign Up",
                      style: TextStyle(color: Colors.deepOrange)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen()),
                    );
                  },
                  child: const Text("Forgot password? Recover your account",
                      style: TextStyle(color: Colors.deepOrange)),
                ),
                const Divider(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SocialSignIn()),
                    );
                  },
                  child: const Text(
                    "Sign In With Google or Facebook",
                    style: TextStyle(color: Colors.deepOrange),
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
    _nameController.dispose();
    _phoneNumberController.dispose();
    _dobController.dispose();
    super.dispose();
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  void _sendPasswordResetEmail() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
      return;
    }

    try {
      await _authService.resetPassword(email);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendPasswordResetEmail,
              child: const Text('Send Password Reset Email'),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialSignIn extends StatefulWidget {
  const SocialSignIn({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SocialSignInState createState() => _SocialSignInState();
}

class _SocialSignInState extends State<SocialSignIn> {
  Map<String, String> profileDetail = {};
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  Future<void> getFbUserData() async {
    await FacebookAuth.instance.login();
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData(
        fields: "id,first_name,last_name,email,picture.width(200)",
      );
      setState(() {
        profileDetail['social_id'] = userData['id'];
        profileDetail['social_name'] =
            userData['first_name'] + ' ' + userData['last_name'];
        profileDetail['social_url'] = userData['picture']['data']['url'];
        profileDetail['social_email'] = userData['email'];
        profileDetail['social_type'] = '2';
      });

      signInCheck(
        profileDetail['social_id']!,
        profileDetail['social_email']!,
        profileDetail['social_phone'],
        profileDetail['social_type']!,
      );
    } else {
      if (kDebugMode) {
        print('Facebook login failed: ${result.message}');
      }
    }
  }

  Future<void> onSignInGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
      clientId: 'YOUR_CLIENT_ID.apps.googleusercontent.com',
    );
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        setState(() {
          profileDetail['social_id'] = googleUser.id;
          profileDetail['social_name'] = googleUser.displayName ?? '';
          profileDetail['social_url'] = googleUser.photoUrl ?? '';
          profileDetail['social_email'] = googleUser.email;
          profileDetail['social_type'] = '1';
        });

        signInCheck(
          profileDetail['social_id']!,
          profileDetail['social_email']!,
          profileDetail['social_phone'],
          profileDetail['social_type']!,
        );
      }
    } catch (error) {
      if (kDebugMode) {
        print('Google sign-in failed: $error');
      }
    }
  }

  Future<void> signInCheck(String userSocialId, String userSocialEmail,
      String? userSocialPhone, String userSocialType) async {
    if (userSocialId.isNotEmpty &&
        (userSocialEmail.isNotEmpty ||
            (userSocialPhone?.isNotEmpty ?? false)) &&
        userSocialType.isNotEmpty) {
      final response = await http.post(
        Uri.parse('/home'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "_token": "ZhyldROEYcLzAc8tc3RE9rHKxRMvM1p13SQjnHO5",
          "user_social_id": userSocialId,
          "user_social_email": userSocialEmail,
          "user_social_phone": userSocialPhone ?? '',
          "user_social_type": userSocialType,
        }),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (kDebugMode) {
          print(result);
        }

        if (result.containsKey('userRegister')) {
          if (profileDetail['social_name'] != null) {
            var name = profileDetail['social_name']!.split(' ');
            firstNameController.text = name[0];
            if (name.length > 1) {
              lastNameController.text = name[1];
            }
          }
          if (profileDetail['social_email'] != null) {
            emailController.text = profileDetail['social_email']!;
          }
          if (profileDetail['social_phone'] != null) {
            phoneController.text = profileDetail['social_phone']!;
          }
          // Open register popup
          showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Register'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _decoratedTextField(
                        controller: firstNameController,
                        labelText: 'First Name',
                      ),
                      _decoratedTextField(
                        controller: lastNameController,
                        labelText: 'Last Name',
                      ),
                      _decoratedTextField(
                        controller: emailController,
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _decoratedTextField(
                        controller: phoneController,
                        labelText: 'Phone Number',
                        keyboardType: TextInputType.phone,
                      ),
                      _decoratedTextField(
                        controller: dobController,
                        labelText: 'Date of Birth',
                        keyboardType: TextInputType.datetime,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
        }

        if (result.containsKey('socialLogin')) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        }
      } else {
        if (kDebugMode) {
          print('Failed to sign in: ${response.statusCode}');
        }
      }
    } else {
      if (kDebugMode) {
        print('Provide proper input');
      }
    }
  }

  Widget _decoratedTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Sign-In'),
        backgroundColor:
            const Color.fromARGB(255, 242, 75, 24), // Custom color for app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: getFbUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 242, 71, 24), // Facebook blue
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text('Sign in with Facebook'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onSignInGoogle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDB4437), // Google red
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text('Sign in with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
