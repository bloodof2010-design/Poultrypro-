// lib/screens/reports_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/poultry_provider.dart';

class ReportsScreen extends StatefulWidget {
  static const routeName = '/reports';
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  double totalIncome = 0;
  double totalExpenses = 0;
  double totalLabourCost = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final p = Provider.of<PoultryProvider>(context);
    _calc(p);
  }

  void _calc(PoultryProvider p) {
    totalIncome = p.incomes.fold(0, (s, i) => s + i.amount);
    totalExpenses = p.expenses.fold(0, (s, e) => s + e.amount);
    totalLabourCost = p.labours.fold(0, (s, l) => s + l.cost);
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<PoultryProvider>(context);
    _calc(p);
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Total Income: \$${totalIncome.toStringAsFixed(2)}'),
          Text('Total Expenses: \$${totalExpenses.toStringAsFixed(2)}'),
          Text('Total Labour Cost: \$${totalLabourCost.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          Text('Net Profit: \$${(totalIncome - (totalExpenses + totalLabourCost)).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}
