// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('PoultryPro Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: userCtrl, decoration: const InputDecoration(labelText: 'Username')),
          TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
          const SizedBox(height: 12),
          if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
          ElevatedButton(
            onPressed: loading ? null : () async {
              setState(() { loading = true; error = null; });
              final res = await auth.login(userCtrl.text.trim(), passCtrl.text.trim());
              setState(() { loading = false; });
              if (res != null) {
                setState(() { error = res; });
                return;
              }
              if (!mounted) return;
              Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
            },
            child: loading ? const CircularProgressIndicator() : const Text('Login'),
          ),
          TextButton(onPressed: () async {
            // quick register flow
            final res = await auth.register(userCtrl.text.trim(), passCtrl.text.trim());
            if (res != null) {
              setState(() { error = res; });
              return;
            }
            if (!mounted) return;
            Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
          }, child: const Text('Register (quick)')),
        ]),
      ),
    );
  }
}
