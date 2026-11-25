class Patient {
  final String? id;
  final String? userID;
  final String fullName;
  final String phone;
  final bool isActive;
  final DateTime? createdAt;

  Patient({
    this.id,
    this.userID,
    required this.fullName,
    required this.phone,
    this.isActive = true,
    this.createdAt,
  });

  Patient copyWith({
    String? id,
    String? userID,
    String? fullName,
    String? phone,
    bool? isActive,
    String? accessCode,
    DateTime? crearedAt,
  }) {
    return Patient(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,

      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userID': userID,
      'fullName': fullName,
      'phone': phone,
      'isActive': isActive,
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] as String?,
      fullName: map['fullName'] as String,
      userID: map['userID'] as String?,
      phone: map['phone'] as String,

      isActive: map['isActive'] as bool? ?? true,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toMapsql() {
    return <String, dynamic>{
      'id': id,
      'userID': userID,
      'fullName': fullName,
      'phone': phone,
    };
  }

  factory Patient.fromMapsql(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] as String?,
      fullName: map['fullName'] as String,
      userID: map['userID'] as String?,
      phone: map['phone'] as String,
    );
  }
}
