import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final email = auth.email ?? 'User';
    return Scaffold(
      appBar: AppBar(
        title: const Text('PoultryPro — Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Welcome, $email', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                const Text('This is the Dashboard. The app is intentionally minimal — Login and Dashboard only.'),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // small demo action
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demo action')));
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Demo action'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
