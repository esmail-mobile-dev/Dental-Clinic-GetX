import 'dart:convert';

import 'package:mysen/core/utiles.dart';

class Doctor {
  final String? id;
  final String? userID;
  final String fullName;
  final Map<String, dynamic> phone;
  final String location;
  final Gender gender;
  final bool isWorking;
  final List<String>? equlatifications;
  final String? imgUrl;
  final DateTime? createdAt;

  Doctor({
    this.id,
    this.userID,
    required this.fullName,
    required this.location,
    required this.phone,
    required this.gender,
    this.isWorking = true,
    this.equlatifications,
    this.imgUrl,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "userID": userID,
      'fullName': fullName,
      'phone': phone,
      'gender': gender.name,
      'equlatifications': equlatifications,
      'location': location,
      'imgUrl': imgUrl,
      'isWorking': isWorking,
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] as String?,
      userID: map['userID'] as String?,
      fullName: map['fullName'] as String,
      phone: Map<String, dynamic>.from(map['phone'] as Map),
      gender: Gender.values.firstWhere(
        (element) => element.name == map['gender'],
      ),
      isWorking: map['isWorking'] as bool? ?? true,
      equlatifications: map['equlatifications'] != null
          ? List<String>.from(map['equlatifications'])
          : null,
      location: map['location'] as String,
      imgUrl: map['imgUrl'] as String?,
    );
  }

  Map<String, dynamic> toMapSql() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'phone': jsonEncode(phone),
      'gender': gender.name,
      'isWorking': isWorking ? 1 : 0,
      'equlatifications': jsonEncode(equlatifications),
      'location': location,
      'imgUrl': imgUrl,
    };
  }

  factory Doctor.fromMapSql(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'] as String?,
      fullName: map['fullName'] as String,
      phone: Map<String, dynamic>.from(jsonDecode(map['phone']) as Map),
      gender: Gender.values.firstWhere(
        (element) => element.name == map['gender'],
      ),
      isWorking: map['isWorking'] == 0 ? false : true as bool? ?? true,
      equlatifications: jsonDecode(map['equlatifications']) != null
          ? List<String>.from(jsonDecode(map['equlatifications']))
          : null,
      location: map['location'] as String,
      imgUrl: map['imgUrl'] as String?,
    );
  }

  Doctor copyWith({
    String? id,
    String? userID,
    String? fullName,
    Map<String, dynamic>? phone,
    String? location,
    Gender? gender,
    bool? isWorking,
    List<String>? equlatifications,
    String? imgUrl,
    DateTime? createdAt,
  }) {
    return Doctor(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      gender: gender ?? this.gender,
      isWorking: isWorking ?? this.isWorking,
      equlatifications: equlatifications ?? this.equlatifications,
      imgUrl: imgUrl ?? this.imgUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
