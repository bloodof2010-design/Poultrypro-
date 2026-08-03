// lib/screens/add_poultry_screen.dart
// Form to add poultry: type, breed, quantity, date, notes.
// On save inserts into DB and pops with true.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../db/DatabaseHelper.dart';

class AddPoultryScreen extends StatefulWidget {
  static const routeName = '/add-poultry';
  const AddPoultryScreen({super.key});

  @override
  State<AddPoultryScreen> createState() => _AddPoultryScreenState();
}

class _AddPoultryScreenState extends State<AddPoultryScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'Broiler';
  final List<String> _types = ['Broiler', 'Layer', 'Kuroiler'];
  final _breedCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController(text: '1');
  DateTime _date = DateTime.now();
  final _notesCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _breedCtrl.dispose();
    _qtyCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final uid = userProv.userId;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not logged in')));
      return;
    }
    setState(() => _saving = true);
    final qty = int.tryParse(_qtyCtrl.text.trim()) ?? 0;
    await DatabaseHelper.instance.insertPoultry(
      userId: uid,
      type: _type,
      breed: _breedCtrl.text.trim(),
      quantity: qty,
      dateAddedIso: _date.toIso8601String(),
      notes: _notesCtrl.text.trim(),
    );
    setState(() => _saving = false);
    // Return true to signal dashboard to refresh
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Poultry')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _type = v ?? _type),
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              TextFormField(
                controller: _breedCtrl,
                decoration: const InputDecoration(labelText: 'Breed'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter breed' : null,
              ),
              TextFormField(
                controller: _qtyCtrl,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n <= 0) return 'Enter a positive integer';
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(child: Text('Date: ${_date.toLocal().toIso8601String().split('T').first}')),
                  TextButton(onPressed: _pickDate, child: const Text('Pick date')),
                ],
              ),
              TextFormField(
                controller: _notesCtrl,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving ? const CircularProgressIndicator() : const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
