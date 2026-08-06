import 'dart:convert';

enum InventoryUnit { kg, pcs, bags }

String inventoryUnitToString(InventoryUnit u) {
  switch (u) {
    case InventoryUnit.kg:
      return 'kg';
    case InventoryUnit.pcs:
      return 'pcs';
    case InventoryUnit.bags:
      return 'bags';
  }
}

InventoryUnit inventoryUnitFromString(String s) {
  switch (s) {
    case 'kg':
      return InventoryUnit.kg;
    case 'pcs':
      return InventoryUnit.pcs;
    case 'bags':
      return InventoryUnit.bags;
    default:
      return InventoryUnit.pcs;
  }
}

class InventoryItem {
  final String id;
  final String enterpriseId;
  final String name;
  final double quantity;
  final InventoryUnit unit;
  final DateTime dateAdded;
  final String? notes;

  InventoryItem({
    required this.id,
    required this.enterpriseId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.dateAdded,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'enterpriseId': enterpriseId,
        'name': name,
        'quantity': quantity,
        'unit': inventoryUnitToString(unit),
        'dateAdded': dateAdded.toIso8601String(),
        'notes': notes,
      };

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as String,
      enterpriseId: json['enterpriseId'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] is int) ? (json['quantity'] as int).toDouble() : (json['quantity'] as num).toDouble(),
      unit: inventoryUnitFromString(json['unit'] as String),
      dateAdded: DateTime.parse(json['dateAdded'] as String),
      notes: json['notes'] as String?,
    );
  }

  static List<InventoryItem> listFromJsonString(String encoded) {
    final List<dynamic> arr = json.decode(encoded) as List<dynamic>;
    return arr.map((e) => InventoryItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String listToJsonString(List<InventoryItem> list) {
    final arr = list.map((e) => e.toJson()).toList();
    return json.encode(arr);
  }
}
