// name=lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/enterprises_list_screen.dart';
import 'screens/add_enterprise_screen.dart';
import 'screens/enterprise_detail_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PoultryProApp());
}

class PoultryProApp extends StatelessWidget {
  const PoultryProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'PoultryPro',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),
          DashboardScreen.routeName: (_) => const DashboardScreen(),
          EnterprisesListScreen.routeName: (_) => const EnterprisesListScreen(),
          // AddEnterpriseScreen and EnterpriseDetailScreen are pushed via MaterialPageRoute
        },
        home: const EntryDecider(),
      ),
    );
  }
}

class EntryDecider extends StatelessWidget {
  const EntryDecider({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!auth.isAuthenticated) {
      return const LoginScreen();
    }
    return const HomeShell();
  }
}

/// HomeShell provides bottom navigation with three tabs:
/// Dashboard, Enterprises, Reports
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static final List<Widget> _pages = <Widget>[
    const DashboardScreen(),
    const EnterprisesListScreen(),
    const _ReportsPlaceholder(),
  ];

  void _onTap(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _onTap,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.business), label: 'Enterprises'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Reports'),
        ],
      ),
      floatingActionButton: _index == 1
          ? FloatingActionButton(
              onPressed: () async {
                final res = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddEnterpriseScreen()),
                );
                if (res == true) {
                  // if on Enterprises tab, refresh by using a simple mechanism:
                  // push and pop EnterprisesListScreen to force reloading when returned
                  // but here we just call setState to rebuild current page
                  setState(() {});
                }
              },
              child: const Icon(Icons.add),
              tooltip: 'Add Enterprise',
            )
          : null,
    );
  }
}

class _ReportsPlaceholder extends StatelessWidget {
  const _ReportsPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: const Center(child: Text('Reports will go here (placeholder)')),
    );
  }
}
