import 'package:mysen/core/utiles.dart';

class Requestreservation {
  final String? id;
  final String doctorID;
  final String patientID;
  final String patientName;
  final StateRequest stateRequest;
  final String phone;
  final DateTime? sendTime;
  final DateTime? reciveTime;

  Requestreservation({
    this.id,
    required this.doctorID,
    required this.patientID,
    required this.patientName,
    required this.stateRequest,
    required this.phone,
    this.sendTime,
    this.reciveTime,
  });

  Requestreservation copyWith({
    String? id,
    String? doctorID,
    String? patientID,
    String? patientName,

    StateRequest? stateRequest,
    String? phone,
    DateTime? sendTime,
    DateTime? reciveTime,
  }) {
    return Requestreservation(
      id: id ?? this.id,
      doctorID: doctorID ?? this.doctorID,
      patientID: patientID ?? this.patientID,
      patientName: patientName ?? this.patientName,
      stateRequest: stateRequest ?? this.stateRequest,
      phone: phone ?? this.phone,

      sendTime: sendTime ?? this.sendTime,
      reciveTime: reciveTime ?? this.reciveTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'doctorID': doctorID,
      'patientID': patientID,
      'stateRequest': stateRequest.name,
      'sendTime': sendTime?.toIso8601String().split('.')[0],
      'reciveTime': reciveTime?.toIso8601String(),
    };
  }

  factory Requestreservation.fromMap(Map<String, dynamic> map) {
    return Requestreservation(
      id: map['id'] as String?,
      doctorID: map['doctorID'] as String,
      patientID: map['patientID'] as String,
      patientName: map['patient']['fullName'] as String,
      stateRequest: StateRequest.values.firstWhere(
        (element) => element.name == map['stateRequest'],
      ),
      phone: map['patient']['phone'] as String,

      sendTime: map['sendTime'] != null
          ? DateTime.parse(map['sendTime'])
          : null,
      reciveTime: map['reciveTime'] != null
          ? DateTime.parse(map['reciveTime'])
          : null,
    );
  }
  factory Requestreservation.fromMapPyload({
    required Map<String, dynamic> map,
    required String patientName,
    required String phone,
  }) {
    return Requestreservation(
      id: map['id'] as String?,
      doctorID: map['doctorID'] as String,
      patientID: map['patientID'] as String,
      patientName: patientName,
      stateRequest: StateRequest.values.firstWhere(
        (element) => element.name == map['stateRequest'],
      ),
      phone: phone,

      sendTime: map['sendTime'] != null
          ? DateTime.parse(map['sendTime'])
          : null,
      reciveTime: map['reciveTime'] != null
          ? DateTime.parse(map['reciveTime'])
          : null,
    );
  }
  factory Requestreservation.fromMapsql(Map<String, dynamic> map) {
    return Requestreservation(
      id: map['id'] as String?,
      doctorID: map['doctorID'] as String,
      patientID: map['patientID'] as String,
      patientName: map['fullName'] as String,
      stateRequest: StateRequest.values.firstWhere(
        (element) => element.name == map['stateRequest'],
      ),
      phone: map['phone'] as String,

      sendTime: map['sendTime'] != null
          ? DateTime.parse(map['sendTime'])
          : null,
      reciveTime: map['reciveTime'] != null
          ? DateTime.parse(map['reciveTime'])
          : null,
    );
  }

  Map<String, dynamic> toMapsql() {
    return <String, dynamic>{
      'id': id,
      'doctorID': doctorID,
      'patientID': patientID,
      'fullName': patientName,
      'stateRequest': stateRequest.name,
      'phone': phone,
      'sendTime': sendTime?.toIso8601String(),
      'reciveTime': reciveTime?.toIso8601String(),
    };
  }
}
