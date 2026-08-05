// name=lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/enterprise_storage.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _totalEnterprises = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTotals();
  }

  Future<void> _loadTotals() async {
    setState(() {
      _loading = true;
    });
    final list = await EnterpriseStorage.getAll();
    setState(() {
      _totalEnterprises = list.length;
      _loading = false;
    });
  }

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
      body: RefreshIndicator(
        onRefresh: _loadTotals,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              ConstrainedBox(
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
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demo action')));
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Demo action'),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Enterprises', style: TextStyle(fontWeight: FontWeight.bold)),
                            _loading ? const CircularProgressIndicator() : Text('$_totalEnterprises', style: Theme.of(context).textTheme.headlineSmall),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
