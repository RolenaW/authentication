import 'package:flutter/material.dart';
import '../service/authen_service.dart';
import 'authen_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _newPasswordController = TextEditingController();

  String message = '';

  void _changePassword() async {
    try {
      if (_newPasswordController.text.length < 6) {
        setState(() {
          message = 'Password must be at least 6 characters';
        });
        return;
      }

      await _authService.changePassword(_newPasswordController.text.trim());

      setState(() {
        message = 'Password updated successfully';
      });

      _newPasswordController.clear();

    } catch (e) {
      setState(() {
        message = e.toString();
      });
    }
  }

  void _logout() async {
    await _authService.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthenticationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Logged in as: ${user?.email ?? "No user"}',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 30),
            const Text(
              'Change Password',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
              ),
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _changePassword,
              child: const Text('Update Password'),
            ),

            const SizedBox(height: 10),
            if (message.isNotEmpty)
              Text(message, style: const TextStyle(color: Colors.blue)),

            const Spacer(),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}