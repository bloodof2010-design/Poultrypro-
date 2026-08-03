// lib/screens/list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/poultry_provider.dart';

class ListScreen extends StatelessWidget {
  static const routeName = '/list';
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final poultry = Provider.of<PoultryProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Lists')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text('Birds', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...poultry.birds.map((b) => ListTile(title: Text(b.tag ?? 'No tag'), subtitle: Text(b.breed ?? ''))),
          const Divider(),
          const Text('Feed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...poultry.feeds.map((f) => ListTile(title: Text(f.feedType), subtitle: Text('${f.quantity} kg • ${f.date.toLocal().toIso8601String().split("T").first}'))),
          const Divider(),
          const Text('Labour', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...poultry.labours.map((l) => ListTile(title: Text(l.description), subtitle: Text('${l.hours} hrs • \$${l.cost.toStringAsFixed(2)}'))),
          const Divider(),
          const Text('Income', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...poultry.incomes.map((i) => ListTile(title: Text(i.source), subtitle: Text('\$${i.amount.toStringAsFixed(2)}'))),
          const Divider(),
          const Text('Expenses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...poultry.expenses.map((e) => ListTile(title: Text(e.description), subtitle: Text('\$${e.amount.toStringAsFixed(2)}'))),
        ],
      ),
    );
  }
}
