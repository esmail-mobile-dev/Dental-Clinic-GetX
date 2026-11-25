class Doctorforpatient {
  final String id;
  final String fullName;

  final String patientID;
  final String doctorID;

  Doctorforpatient({
    required this.id,
    required this.fullName,
    required this.patientID,
    required this.doctorID,
  });

  factory Doctorforpatient.fromMap(Map<String, dynamic> map) {
    return Doctorforpatient(
      id: map['id'] as String,
      doctorID: map['doctorID'] as String,
      patientID: map['patientID'] as String,
      fullName: map['doctor']['fullName'] as String,
    );
  }
  Map<String, dynamic> toMapsql() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'patientID': patientID,
      'doctorID': doctorID,
    };
  }

  factory Doctorforpatient.fromMapsql(Map<String, dynamic> map) {
    return Doctorforpatient(
      id: map['id'] as String,
      doctorID: map['doctorID'] as String,
      patientID: map['patientID'] as String,

      fullName: map['fullName'] as String,
    );
  }
}
