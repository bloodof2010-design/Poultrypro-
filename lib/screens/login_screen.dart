// lib/screens/login_screen.dart
// LoginScreen: email + password + login button + register link (loginOrRegister creates user if missing)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _busy = false;
  String? _error;

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final provider = Provider.of<UserProvider>(context, listen: false);
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    if (email.isEmpty || pass.isEmpty) {
      setState(() {
        _error = 'Enter email and password';
        _busy = false;
      });
      return;
    }
    final res = await provider.loginOrRegister(email: email, password: pass);
    setState(() {
      _busy = false;
      _error = res;
    });
    if (res == null) {
      // success -> go to dashboard (replace)
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('PoultryPro Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _busy ? null : _submit,
              child: _busy ? const CircularProgressIndicator() : const Text('Login / Register'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // quick hint: same action; visually separated as a link
                final email = _emailCtrl.text.trim();
                final pass = _passCtrl.text;
                if (email.isEmpty || pass.isEmpty) {
                  setState(() {
                    _error = 'Fill email and password to register';
                  });
                  return;
                }
                _submit();
              },
              child: const Text('Register (if you don\'t have an account)'),
            ),
            const SizedBox(height: 8),
            if (provider.isLoggedIn) Text('Already logged in as ${provider.email}'),
          ],
        ),
      ),
    );
  }
}
