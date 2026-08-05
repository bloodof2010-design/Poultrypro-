// name=lib/screens/add_enterprise_screen.dart
import 'package:flutter/material.dart';
import '../models/enterprise.dart';
import '../services/enterprise_storage.dart';

class AddEnterpriseScreen extends StatefulWidget {
  const AddEnterpriseScreen({super.key});

  @override
  State<AddEnterpriseScreen> createState() => _AddEnterpriseScreenState();
}

class _AddEnterpriseScreenState extends State<AddEnterpriseScreen> {
  EnterpriseType _type = EnterpriseType.hens;
  final _nameCtl = TextEditingController();
  final _notesCtl = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _nameCtl.dispose();
    _notesCtl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _error = null;
    });
    final name = _nameCtl.text.trim();
    if (name.isEmpty) {
      setState(() {
        _error = 'Enter a name for the enterprise';
      });
      return;
    }

    setState(() {
      _saving = true;
    });

    final ent = Enterprise(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // simple id
      type: _type,
      name: name,
      dateCreated: DateTime.now(),
      notes: _notesCtl.text.trim().isEmpty ? null : _notesCtl.text.trim(),
    );

    try {
      await EnterpriseStorage.addEnterprise(ent);
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to save: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // use a simple date string (no external package)
    final createdAtText = DateTime.now().toLocal().toString().split(' ').first;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Enterprise')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<EnterpriseType>(
              value: _type,
              decoration: const InputDecoration(labelText: 'Type'),
              items: EnterpriseType.values
                  .map((t) => DropdownMenuItem(value: t, child: Text(enterpriseTypeToString(t).toUpperCase())))
                  .toList(),
              onChanged: (v) => setState(() => _type = v ?? EnterpriseType.hens),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameCtl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesCtl,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 4,
            ),
            const SizedBox(height: 18),
            if (_error != null) ...[
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
            ],
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving ? const CircularProgressIndicator() : const Text('Save'),
            ),
            const SizedBox(height: 12),
            Text('Created: $createdAtText', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
        
          
