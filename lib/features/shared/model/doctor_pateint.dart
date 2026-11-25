import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DoctorPateint {
  final String? id;
  final String doctorID;
  final String patientID;
  final bool isDeleteDoctor;
  final bool isDeletePatient;
  final DateTime? createdAt;

  DoctorPateint({
    this.id,
    required this.doctorID,
    required this.patientID,
    this.isDeleteDoctor = false,
    this.isDeletePatient = false,
    this.createdAt,
  });

  DoctorPateint copyWith({
    String? id,
    String? doctorID,
    String? patientID,
    bool? isDeleteDoctor,
    bool? isDeletePatient,
    DateTime? createdAt,
  }) {
    return DoctorPateint(
      id: id ?? this.id,
      doctorID: doctorID ?? this.doctorID,
      patientID: patientID ?? this.patientID,
      isDeleteDoctor: isDeleteDoctor ?? this.isDeleteDoctor,
      isDeletePatient: isDeletePatient ?? this.isDeletePatient,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'doctorID': doctorID,
      'patientID': patientID,
      'isDeleteDoctor': isDeleteDoctor,
      'isDeletePatient': isDeletePatient,
    };
  }

  factory DoctorPateint.fromMap(Map<String, dynamic> map) {
    return DoctorPateint(
      id: map['id'] as String?,
      doctorID: map['doctorID'] as String,
      patientID: map['patientID'] as String,
      isDeleteDoctor: map['isDeleteDoctor'] as bool? ?? false,
      isDeletePatient: map['isDeletePatient'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }

  factory DoctorPateint.fromJson(String source) =>
      DoctorPateint.fromMap(json.decode(source) as Map<String, dynamic>);
}
