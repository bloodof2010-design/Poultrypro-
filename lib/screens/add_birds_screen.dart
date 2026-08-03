// lib/screens/add_bird_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/poultry_provider.dart';
import '../models/bird.dart';

class AddBirdScreen extends StatefulWidget {
  static const routeName = '/add-bird';
  const AddBirdScreen({super.key});
  @override
  State<AddBirdScreen> createState() => _AddBirdScreenState();
}

class _AddBirdScreenState extends State<AddBirdScreen> {
  final tagCtrl = TextEditingController();
  final breedCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final poultry = Provider.of<PoultryProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Bird')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          TextField(controller: tagCtrl, decoration: const InputDecoration(labelText: 'Tag')),
          TextField(controller: breedCtrl, decoration: const InputDecoration(labelText: 'Breed')),
          TextField(controller: notesCtrl, decoration: const InputDecoration(labelText: 'Notes')),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: saving ? null : () async {
              if (auth.userId == null) return;
              setState(() { saving = true; });
              final bird = Bird(tag: tagCtrl.text.trim(), breed: breedCtrl.text.trim(), notes: notesCtrl.text.trim(), ownerUserId: auth.userId);
              await poultry.addBird(bird);
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
