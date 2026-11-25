import 'package:mysen/core/constant.dart';
import 'package:mysen/features/shared/model/patients.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Patientsservices {
  final patienttable = "patient";

  PostgrestTransformBuilder<Map<String, dynamic>?> fetchPatientsByUSerID(
    String userID,
  ) {
    return client
        .from(patienttable)
        .select("*")
        .eq("userID", userID)
        .maybeSingle();
  }

  PostgrestTransformBuilder<Map<String, dynamic>?> fetchPatientByPhone(
    String phone,
  ) {
    return client
        .from(patienttable)
        .select("*")
        .eq("phone", phone)
        .maybeSingle();
  }

  PostgrestFilterBuilder<dynamic> addPatient(Patient patient) {
    return client.from(patienttable).insert(patient.toMap());
  }

  PostgrestFilterBuilder<dynamic> updatePatient(Patient patient) {
    return client
        .from(patienttable)
        .update(patient.toMap())
        .eq("id", patient.id!);
  }
}
