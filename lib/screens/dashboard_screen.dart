// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/poultry_provider.dart';
import 'list_screen.dart';
import 'reports_screen.dart';
import 'add_bird_screen.dart';
import 'add_feed_screen.dart';
import 'add_labour_screen.dart';
import 'add_income_screen.dart';
import 'add_expense_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/';
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.userId != null) {
      Provider.of<PoultryProvider>(context, listen: false).loadAll(ownerUserId: auth.userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final poultry = Provider.of<PoultryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('PoultryPro Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () async {
            await auth.logout();
            if (!mounted) return;
            Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
          })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 8, runSpacing: 8, children: [
            ElevatedButton.icon(icon: const Icon(Icons.pets), label: const Text('Add Bird'), onPressed: () => Navigator.of(context).pushNamed(AddBirdScreen.routeName)),
            ElevatedButton.icon(icon: const Icon(Icons.food_bank), label: const Text('Add Feed'), onPressed: () => Navigator.of(context).pushNamed(AddFeedScreen.routeName)),
            ElevatedButton.icon(icon: const Icon(Icons.work), label: const Text('Add Labour'), onPressed: () => Navigator.of(context).pushNamed(AddLabourScreen.routeName)),
            ElevatedButton.icon(icon: const Icon(Icons.attach_money), label: const Text('Add Income'), onPressed: () => Navigator.of(context).pushNamed(AddIncomeScreen.routeName)),
            ElevatedButton.icon(icon: const Icon(Icons.money_off), label: const Text('Add Expense'), onPressed: () => Navigator.of(context).pushNamed(AddExpenseScreen.routeName)),
            ElevatedButton.icon(icon: const Icon(Icons.list), label: const Text('Lists'), onPressed: () => Navigator.of(context).pushNamed(ListScreen.routeName)),
            ElevatedButton.icon(icon: const Icon(Icons.bar_chart), label: const Text('Reports'), onPressed: () => Navigator.of(context).pushNamed(ReportsScreen.routeName)),
          ]),
          const SizedBox(height: 12),
          Text('Summary', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Birds: ${poultry.birds.length}  Feeds: ${poultry.feeds.length}  Income: ${poultry.incomes.length}  Expenses: ${poultry.expenses.length}'),
        ]),
      ),
    );
  }
}
