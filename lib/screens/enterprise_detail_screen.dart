import 'package:flutter/material.dart';
import '../models/enterprise.dart';
import '../models/inventory_item.dart';
import '../services/storage_service.dart';
import 'add_inventory_screen.dart';

class EnterpriseDetailScreen extends StatefulWidget {
  final String enterpriseId;
  const EnterpriseDetailScreen({required this.enterpriseId, super.key});

  @override
  State<EnterpriseDetailScreen> createState() => _EnterpriseDetailScreenState();
}

class _EnterpriseDetailScreenState extends State<EnterpriseDetailScreen> {
  Enterprise? _ent;
  List<InventoryItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
    });
    final e = await StorageService.getEnterpriseById(widget.enterpriseId);
    final items = await StorageService.getInventoryForEnterprise(widget.enterpriseId);
    setState(() {
      _ent = e;
      _items = items;
      _loading = false;
    });
  }

  Future<void> _onAddInventory() async {
    final res = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AddInventoryScreen(enterpriseId: widget.enterpriseId)),
    );
    if (res == true) {
      await _load();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inventory item added')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enterprise Details'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _ent == null
              ? const Center(child: Text('Enterprise not found'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_ent!.name, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text('Type: ${enterpriseTypeToString(_ent!.type)}'),
                      const SizedBox(height: 8),
                      Text('Created: ${_ent!.dateCreated.toLocal().toString().split(' ').first}'),
                      const SizedBox(height: 12),
                      if (_ent!.notes != null) ...[
                        const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(_ent!.notes!),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 12),
                      const Text('Inventory', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _items.isEmpty
                            ? const Center(child: Text('No inventory items yet.'))
                            : ListView.separated(
                                itemCount: _items.length,
                                separatorBuilder: (_, __) => const Divider(),
                                itemBuilder: (ctx, i) {
                                  final it = _items[i];
                                  return ListTile(
                                    title: Text(it.name),
                                    subtitle: Text('${it.quantity} ${inventoryUnitToString(it.unit)} • ${it.dateAdded.toLocal().toString().split(' ').first}'),
                                    isThreeLine: it.notes != null,
                                    trailing: Text(it.quantity.toString()),
                                    onTap: () {
                                      if (it.notes != null && it.notes!.isNotEmpty) {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                                  title: Text(it.name),
                                                  content: Text(it.notes!),
                                                  actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
                                                ));
                                      }
                                    },
                                  );
                                },
                              ),
                      )
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddInventory,
        child: const Icon(Icons.add),
        tooltip: 'Add Inventory Item',
      ),
    );
  }
}
