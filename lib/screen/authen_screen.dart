import 'package:flutter/material.dart';
import '../service/authen_service.dart';
import 'profile_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isLogin = true;
  String errorMessage = '';

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      if (isLogin) {
        await _authService.signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        await _authService.register(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      }
      print("SUCCESS LOGIN");
      if (!mounted) return;

      Navigator.pushReplacement(context, 
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );

    } catch (e) {
      print("ERROR: $e"); // 🔥 ADD THIS
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Sign In' : 'Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email is required';
                  if (!value.contains('@')) return 'Enter a valid email like test@gsu.com';
                  return null;
                },
              ),

              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
              ),

              const SizedBox(height: 20),
              if (errorMessage.isNotEmpty)
                Text(errorMessage, style: const TextStyle(color: Colors.red)),

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isLogin ? 'Sign In' : 'Register'),
              ),

              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                    errorMessage = '';
                  });
                },
                child: Text(
                  isLogin
                      ? 'Create account'
                      : 'Already have an account? Sign in',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}