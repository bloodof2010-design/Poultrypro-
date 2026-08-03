// lib/models/bird.dart
class Bird {
  final int? id;
  final String? tag;
  final String? breed;
  final DateTime dateAdded;
  final String? notes;
  final int? ownerUserId;

  Bird({this.id, this.tag, this.breed, DateTime? dateAdded, this.notes, this.ownerUserId}) : dateAdded = dateAdded ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'tag': tag,
        'breed': breed,
        'date_added': dateAdded.toIso8601String(),
        'notes': notes,
        'owner_user_id': ownerUserId
      };

  factory Bird.fromMap(Map<String, dynamic> m) => Bird(
        id: m['id'] as int?,
        tag: m['tag'] as String?,
        breed: m['breed'] as String?,
        dateAdded: DateTime.parse(m['date_added'] as String),
        notes: m['notes'] as String?,
        ownerUserId: m['owner_user_id'] as int?,
      );
}
