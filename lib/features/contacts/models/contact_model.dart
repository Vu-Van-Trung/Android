class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String? avatarUrl;
  final bool isOnline;
  final String? lastSeen;

  const Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.avatarUrl,
    required this.isOnline,
    this.lastSeen,
  });

  // Convert Contact to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
    };
  }

  // Create Contact from JSON
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      isOnline: json['isOnline'] as bool,
      lastSeen: json['lastSeen'] as String?,
    );
  }

  // Create a copy with modified fields
  Contact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? avatarUrl,
    bool? isOnline,
    String? lastSeen,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
