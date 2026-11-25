// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserDetails {
  final int? id;
  final String? userID;
  final String role;
  final bool isActive;
  final DateTime? createAt;

  UserDetails({
    this.id,
    this.userID,
    this.createAt,
    required this.role,
    this.isActive = true,
  });

  UserDetails copyWith({
    int? id,
    String? userID,
    String? role,
    DateTime? createAt,
  }) {
    return UserDetails(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      role: role ?? this.role,
      createAt: createAt ?? this.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'role': role};
  }

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      id: map['id'] as int,
      userID: map['userID'] as String,
      role: map['role'] as String,
      createAt: map['createAt'] != null
          ? DateTime.parse(map['createAt'])
          : null,
    );
  }
}
