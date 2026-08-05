// name=lib/screens/enterprise_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/enterprise.dart';
import '../services/enterprise_storage.dart';
import 'add_enterprise_screen.dart';

class EnterpriseDetailScreen extends StatefulWidget {
  final String enterpriseId;
  const EnterpriseDetailScreen({required this.enterpriseId, super.key});

  @override
  State<EnterpriseDetailScreen> createState() => _EnterpriseDetailScreenState();
}

class _EnterpriseDetailScreenState extends State<EnterpriseDetailScreen> {
  Enterprise? _ent;
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
    final e = await EnterpriseStorage.getById(widget.enterpriseId);
    setState(() {
      _ent = e;
      _loading = false;
    });
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
                      const SizedBox(height: 18),
                      ElevatedButton.icon(
                        onPressed: () {
                          // placeholder for adding bird/animal
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add Bird/Animal — not implemented')));
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Bird/Animal'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          // placeholder for viewing records
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('View Records — not implemented')));
                        },
                        icon: const Icon(Icons.list),
                        label: const Text('View Records'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
