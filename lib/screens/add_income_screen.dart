// lib/screens/add_income_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/poultry_provider.dart';
import '../models/income.dart';

class AddIncomeScreen extends StatefulWidget {
  static const routeName = '/add-income';
  const AddIncomeScreen({super.key});
  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final srcCtrl = TextEditingController();
  final amtCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final poultry = Provider.of<PoultryProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Income')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          TextField(controller: srcCtrl, decoration: const InputDecoration(labelText: 'Source')),
          TextField(controller: amtCtrl, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
          TextField(controller: notesCtrl, decoration: const InputDecoration(labelText: 'Notes')),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: saving ? null : () async {
              if (auth.userId == null) return;
              setState(() { saving = true; });
              final entry = Income(source: srcCtrl.text.trim(), amount: double.tryParse(amtCtrl.text.trim()) ?? 0, notes: notesCtrl.text.trim(), ownerUserId: auth.userId);
              await poultry.addIncome(entry);
              setState(() { saving = false; });
              if (!mounted) return;
              Navigator.of(context).pop();
            },
            child: saving ? const CircularProgressIndicator() : const Text('Save'),
          )
        ]),
      ),
    );
  }
}
