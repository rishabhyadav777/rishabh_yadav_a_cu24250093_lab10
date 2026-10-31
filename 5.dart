import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyA_APKI_API_KEY_YAHAN_AAYEGI',
      appId: '1:123456789:android:abcdef123456',
      messagingSenderId: '123456789012',
      projectId: 'apka-project-id',
    ),
  );
  runApp(const MaterialApp(
    home: AuthSnackBarDemo(),
    debugShowCheckedModeBanner: false,
  ));
}

class AuthSnackBarDemo extends StatefulWidget {
  const AuthSnackBarDemo({super.key});

  @override
  State<AuthSnackBarDemo> createState() => _AuthSnackBarDemoState();
}

class _AuthSnackBarDemoState extends State<AuthSnackBarDemo> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleAuth(bool isRegister) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Email and password cannot be empty.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (isRegister) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        _showSnackBar('Account created successfully!', isError: false);
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        _showSnackBar('Logged in successfully!', isError: false);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email address.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password entered. Please try again.';
          break;
        case 'email-already-in-use':
          errorMessage = 'This email address is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not formatted correctly.';
          break;
        case 'weak-password':
          errorMessage = 'The password must be at least 6 characters long.';
          break;
        default:
          errorMessage = e.message ?? 'Authentication error occurred.';
      }
      _showSnackBar(errorMessage, isError: true);
    } catch (e) {
      _showSnackBar('An unexpected error occurred: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Error Handling (SnackBar)'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _handleAuth(false),
                      child: const Text('Sign In'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _handleAuth(true),
                      child: const Text('Sign Up'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}