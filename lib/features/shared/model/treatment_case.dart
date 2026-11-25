// ignore_for_file: public_member_api_docs, sort_constructors_first
enum TreatmentSatus { active, canceled, deleted }

class TreatmentCase {
  final String id;
  final String doctorPatientID;
  final int totalPrice;
  final TreatmentSatus treatmentSatus;

  final DateTime? createdAt;

  TreatmentCase({
    required this.id,
    required this.doctorPatientID,
    required this.totalPrice,
    this.createdAt,
    required this.treatmentSatus,
  });

  TreatmentCase copyWith({
    String? id,
    String? doctorPatientID,
    int? numberTreatmentCase,
    int? totalPrice,
    TreatmentSatus? treatmentSatus,
    DateTime? createdAt,
  }) {
    return TreatmentCase(
      id: id ?? this.id,
      doctorPatientID: doctorPatientID ?? this.doctorPatientID,
      totalPrice: totalPrice ?? this.totalPrice,
      treatmentSatus: treatmentSatus ?? this.treatmentSatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'doctorPatientID': doctorPatientID,
      'totalPrice': totalPrice,
      'treatmentStatus': treatmentSatus.name,
    };
  }

  Map<String, dynamic> toMapSql() {
    return <String, dynamic>{
      'id': id,
      'doctorPatientID': doctorPatientID,
      'totalPrice': totalPrice,
      'treatmentStatus': treatmentSatus.name,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory TreatmentCase.fromMap(Map<String, dynamic> map) {
    return TreatmentCase(
      id: map['id'] as String,
      doctorPatientID: map['doctorPatientID'] as String,
      totalPrice: map['totalPrice'] as int,
      treatmentSatus: TreatmentSatus.values.firstWhere(
        (element) => element.name == map['treatmentStatus'],
      ),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
    );
  }
  factory TreatmentCase.fromMapSql(Map<String, dynamic> map) {
    return TreatmentCase(
      id: map['id'] as String,
      doctorPatientID: map['doctorPatientID'] as String,
      totalPrice: map['totalPrice'] as int,
      treatmentSatus: TreatmentSatus.values.firstWhere(
        (element) => element.name == map['treatmentStatus'],
      ),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
    );
  }
}
