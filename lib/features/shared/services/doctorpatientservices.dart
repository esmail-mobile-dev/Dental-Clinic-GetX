import 'package:mysen/core/constant.dart';
import 'package:mysen/features/shared/model/doctor_pateint.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Doctorpatientservices {
  final doctorpatienttable = "doctorpateint";

  PostgrestFilterBuilder<List<Map<String, dynamic>>> fetchDoctors() {
    return client
        .from(doctorpatienttable)
        .select("id,doctorID,patientID,doctor(fullName)")
        .eq('isDeletePatient', false);
  }

  PostgrestFilterBuilder<List<Map<String, dynamic>>> fetchPatients() {
    return client
        .from(doctorpatienttable)
        .select("id,patient(id,fullName,phone)")
        .eq('isDeleteDoctor', false);
  }

  PostgrestTransformBuilder<Map<String, dynamic>?> fetchDoctorPatientById(
    String id,
  ) {
    return client
        .from(doctorpatienttable)
        .select("*")
        .eq('id', id)
        .maybeSingle();
  }

  PostgrestFilterBuilder<dynamic> upsertDoctorPatient(
    DoctorPateint doctorPateint,
  ) {
    return client
        .from(doctorpatienttable)
        .upsert(doctorPateint.toMap(), onConflict: 'patientID,doctorID');
  }

  PostgrestFilterBuilder<dynamic> updateDoctorPatient({
    required String doctorPateintID,
    required String column,
    required bool value,
  }) {
    return client
        .from(doctorpatienttable)
        .update({column: value})
        .eq("id", doctorPateintID);
  }

  PostgrestFilterBuilder<dynamic> updateIsDeletePatient(String patientID) {
    return client
        .from(doctorpatienttable)
        .update({'isDeletePatient': false})
        .eq("patientID", patientID);
  }

  PostgrestFilterBuilder<dynamic> deleteDoctorPatient(String id) {
    return client.from(doctorpatienttable).delete().eq("id", id);
  }
}
