import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/inventory_item.dart';
import '../services/storage_service.dart';

class AddInventoryScreen extends StatefulWidget {
  final String enterpriseId;
  const AddInventoryScreen({required this.enterpriseId, super.key});

  @override
  State<AddInventoryScreen> createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends State<AddInventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _quantityCtl = TextEditingController();
  InventoryUnit _unit = InventoryUnit.pcs;
  final _notesCtl = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _nameCtl.dispose();
    _quantityCtl.dispose();
    _notesCtl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });

    final uuid = const Uuid();
    final id = uuid.v4();
    double qty = 0;
    try {
      qty = double.parse(_quantityCtl.text.trim());
    } catch (_) {
      qty = 0;
    }

    final item = InventoryItem(
      id: id,
      enterpriseId: widget.enterpriseId,
      name: _nameCtl.text.trim(),
      quantity: qty,
      unit: _unit,
      dateAdded: DateTime.now(),
      notes: _notesCtl.text.trim().isEmpty ? null : _notesCtl.text.trim(),
    );

    try {
      await StorageService.saveInventoryItem(item);
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to save: $e';
      });
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Inventory Item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quantityCtl,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter quantity';
                  final parsed = double.tryParse(v.trim());
                  if (parsed == null) return 'Enter valid number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<InventoryUnit>(
                value: _unit,
                decoration: const InputDecoration(labelText: 'Unit'),
                items: InventoryUnit.values.map((u) {
                  return DropdownMenuItem(value: u, child: Text(inventoryUnitToString(u).toUpperCase()));
                }).toList(),
                onChanged: (v) => setState(() => _unit = v ?? InventoryUnit.pcs),
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
            ],
          ),
        ),
      ),
    );
  }
}
