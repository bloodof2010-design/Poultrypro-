// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../db/DatabaseHelper.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _count = 0;
  List<Map<String, Object?>> _items = [];

  Future<void> _refresh() async {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final userId = userProv.userId;
    if (userId == null) return;
    final items = await DatabaseHelper.instance.getPoultryForUser(userId);
    final count = await DatabaseHelper.instance.getPoultryCountForUser(userId);
    setState(() {
      _items = items;
      _count = count;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await userProv.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Text('Welcome ${userProv.email ?? ''}'),
            const SizedBox(height: 8),
            Text('Total poultry: $_count'),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            ..._items.map((it) {
              return ListTile(
                title: Text(it['type'] as String? ?? 'Unknown'),
                subtitle: Text('${it['breed'] ?? ''} • qty ${it['quantity'] ?? 0}'),
              );
            }).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add_poultry').then((_) => _refresh()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
