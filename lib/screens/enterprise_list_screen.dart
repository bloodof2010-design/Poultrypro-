// name=lib/screens/enterprises_list_screen.dart
import 'package:flutter/material.dart';
import '../models/enterprise.dart';
import '../services/enterprise_storage.dart';
import 'add_enterprise_screen.dart';
import 'enterprise_detail_screen.dart';

class EnterprisesListScreen extends StatefulWidget {
  static const routeName = '/enterprises';
  const EnterprisesListScreen({super.key});

  @override
  State<EnterprisesListScreen> createState() => _EnterprisesListScreenState();
}

class _EnterprisesListScreenState extends State<EnterprisesListScreen> {
  List<Enterprise> _list = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  Future<void> _loadList() async {
    setState(() {
      _loading = true;
    });
    final items = await EnterpriseStorage.getAll();
    setState(() {
      _list = items;
      _loading = false;
    });
  }

  Future<void> _onAdd() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddEnterpriseScreen()),
    );
    if (result == true) {
      await _loadList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enterprises'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _list.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('No enterprises yet.'),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _onAdd,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Enterprise'),
                      )
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadList,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: _list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (ctx, i) {
                      final e = _list[i];
                      return ListTile(
                        tileColor: Theme.of(context).colorScheme.surfaceVariant,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        title: Text(e.name),
                        subtitle: Text('${enterpriseTypeToString(e.type)} • ${e.dateCreated.toLocal().toString().split(' ').first}'),
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EnterpriseDetailScreen(enterpriseId: e.id),
                              ));
                          await _loadList();
                        },
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAdd,
        child: const Icon(Icons.add),
        tooltip: 'Add Enterprise',
      ),
    );
  }
}
