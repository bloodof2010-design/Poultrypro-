// lib/screens/dashboard_screen.dart
// Dashboard: shows welcome, total poultry count and list for logged in user,
// FAB opens AddPoultryScreen and reloads list after returning.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../db/DatabaseHelper.dart';
import 'add_poultry_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, Object?>> _poultry = [];
  int _count = 0;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // load will be triggered in didChangeDependencies when provider available
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProv = Provider.of<UserProvider>(context, listen: false);
    if (!userProv.isLoggedIn) {
      // if no user, go back to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      });
      return;
    }
    _reload();
  }

  Future<void> _reload() async {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final uid = userProv.userId;
    if (uid == null) return;
    setState(() => _loading = true);
    _poultry = await DatabaseHelper.instance.getPoultryForUser(uid);
    _count = await DatabaseHelper.instance.getPoultryCountForUser(uid);
    setState(() => _loading = false);
  }

  Future<void> _onAdd() async {
    // Navigate to AddPoultryScreen and wait for result; if true, reload
    final res = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const AddPoultryScreen()));
    if (res == true) {
      await _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('PoultryPro Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await userProv.logout();
              if (!mounted) return;
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome ${userProv.email ?? ''}', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Total poultry: $_count', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  const Text('Your Poultry', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _poultry.isEmpty
                        ? const Center(child: Text('No poultry recorded yet. Tap + to add.'))
                        : ListView.builder(
                            itemCount: _poultry.length,
                            itemBuilder: (ctx, i) {
                              final row = _poultry[i];
                              final type = row['type'] as String? ?? '';
                              final breed = row['breed'] as String? ?? '';
                              final qty = (row['quantity'] as num?)?.toInt() ?? 0;
                              final date = row['date_added'] as String? ?? '';
                              final notes = row['notes'] as String? ?? '';
                              return Card(
                                child: ListTile(
                                  title: Text('$type • $breed'),
                                  subtitle: Text('Qty: $qty • Date: ${date.split('T').first}\n$notes'),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAdd,
        child: const Icon(Icons.add),
        tooltip: 'Add poultry',
      ),
    );
  }
}
