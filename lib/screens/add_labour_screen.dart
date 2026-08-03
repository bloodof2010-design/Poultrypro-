// lib/screens/add_labour_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/poultry_provider.dart';
import '../models/labour.dart';

class AddLabourScreen extends StatefulWidget {
  static const routeName = '/add-labour';
  const AddLabourScreen({super.key});
  @override
  State<AddLabourScreen> createState() => _AddLabourScreenState();
}

class _AddLabourScreenState extends State<AddLabourScreen> {
  final descCtrl = TextEditingController();
  final hoursCtrl = TextEditingController();
  final costCtrl = TextEditingController();
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final poultry = Provider.of<PoultryProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Labour')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
          TextField(controller: hoursCtrl, decoration: const InputDecoration(labelText: 'Hours'), keyboardType: TextInputType.number),
          TextField(controller: costCtrl, decoration: const InputDecoration(labelText: 'Cost'), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: saving ? null : () async {
              if (auth.userId == null) return;
              setState(() { saving = true; });
              final entry = LabourEntry(description: descCtrl.text.trim(), hours: double.tryParse(hoursCtrl.text.trim()) ?? 0, cost: double.tryParse(costCtrl.text.trim()) ?? 0, ownerUserId: auth.userId);
              await poultry.addLabour(entry);
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
