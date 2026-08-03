// lib/screens/add_feed_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/poultry_provider.dart';
import '../models/feed_entry.dart';

class AddFeedScreen extends StatefulWidget {
  static const routeName = '/add-feed';
  const AddFeedScreen({super.key});
  @override
  State<AddFeedScreen> createState() => _AddFeedScreenState();
}

class _AddFeedScreenState extends State<AddFeedScreen> {
  final feedTypeCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final poultry = Provider.of<PoultryProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Feed Entry')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          TextField(controller: feedTypeCtrl, decoration: const InputDecoration(labelText: 'Feed type')),
          TextField(controller: qtyCtrl, decoration: const InputDecoration(labelText: 'Quantity (kg)'), keyboardType: TextInputType.number),
          TextField(controller: notesCtrl, decoration: const InputDecoration(labelText: 'Notes')),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: saving ? null : () async {
              if (auth.userId == null) return;
              setState(() { saving = true; });
              final entry = FeedEntry(feedType: feedTypeCtrl.text.trim(), quantity: double.tryParse(qtyCtrl.text.trim()) ?? 0, notes: notesCtrl.text.trim(), ownerUserId: auth.userId);
              await poultry.addFeed(entry);
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
