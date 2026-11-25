import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class Appointment {
  final String? id;
  final String treatmentCaseID;
  final DateTime timeAppointment;
  final int payPrice;
  final List<Map>? teethSelected;
  final DateTime? createdAt;

  Appointment({
    this.id,
    required this.treatmentCaseID,
    required this.timeAppointment,
    required this.payPrice,
    this.teethSelected,
    this.createdAt,
  });

  Appointment copyWith({
    String? id,
    String? treatmentCaseID,
    DateTime? timeAppointment,
    int? payPrice,
    List<Map>? teethSelected,

    DateTime? createdAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      treatmentCaseID: treatmentCaseID ?? this.treatmentCaseID,
      timeAppointment: timeAppointment ?? this.timeAppointment,
      payPrice: payPrice ?? this.payPrice,
      teethSelected: teethSelected ?? this.teethSelected,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'treatmentCaseID': treatmentCaseID,
      'timeAppointment': timeAppointment.toIso8601String(),
      'payPrice': payPrice,
      'teethSelected': teethSelected,
    };
  }

  Map<String, dynamic> toMapSql() {
    return <String, dynamic>{
      'id': id,
      'treatmentCaseID': treatmentCaseID,
      'timeAppointment': timeAppointment.toIso8601String(),
      'payPrice': payPrice,
      'teethSelected': jsonEncode(teethSelected),
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] as String?,
      treatmentCaseID: map['treatmentCaseID'] as String,

      timeAppointment: DateTime.parse(map['timeAppointment']),
      teethSelected: map['teethSelected'] != null
          ? List<Map<String, dynamic>>.from(map['teethSelected'] as List)
          : null,
      payPrice: map['payPrice'] as int,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : null,
    );
  }
  factory Appointment.fromMapSql(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] as String?,
      treatmentCaseID: map['treatmentCaseID'] as String,
      timeAppointment: DateTime.parse(map['timeAppointment']),
      teethSelected: map['teethSelected'] != null
          ? List<Map<String, dynamic>>.from(
              (jsonDecode(map['teethSelected']) as List),
            )
          : null,
      payPrice: map['payPrice'] as int,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : null,
    );
  }
}
