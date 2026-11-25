// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Patientsfordoctor {
  final String id;
  final String patientID;
  final String fullName;
  final String phone;

  Patientsfordoctor({
    required this.id,
    required this.patientID,
    required this.fullName,
    required this.phone,
  });

  factory Patientsfordoctor.fromMap(Map<String, dynamic> map) {
    return Patientsfordoctor(
      id: map['id'] as String,
      patientID: map['patient']['id'] as String,
      fullName: map['patient']['fullName'] as String,
      phone: map['patient']['phone'] as String,
    );
  }

  Map<String, dynamic> toMapSql() {
    return <String, dynamic>{
      'id': id,
      'patientID': patientID,
      'fullName': fullName,
      'phone': phone,
    };
  }

  factory Patientsfordoctor.fromMapSql(Map<String, dynamic> map) {
    return Patientsfordoctor(
      id: map['id'] as String,
      patientID: map['patientID'] as String,
      fullName: map['fullName'] as String,
      phone: map['phone'] as String,
    );
  }
  Patientsfordoctor copyWith({
    String? id,
    String? patientID,

    String? fullName,
    String? phone,
  }) {
    return Patientsfordoctor(
      id: id ?? this.id,
      patientID: patientID ?? this.patientID,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
    );
  }

  factory Patientsfordoctor.fromJson(String source) =>
      Patientsfordoctor.fromMap(json.decode(source) as Map<String, dynamic>);
}
