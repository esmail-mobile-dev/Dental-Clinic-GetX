import 'package:mysen/core/constant.dart';
import 'package:mysen/features/shared/model/doctor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Doctorservices {
  final doctortable = "doctor";

  PostgrestFilterBuilder<List<Map<String, dynamic>>> fetchDoctors() {
    return client.from(doctortable).select("*");
  }

  PostgrestTransformBuilder<Map<String, dynamic>?> fetchDoctorByUserID(
    String userID,
  ) {
    return client
        .from(doctortable)
        .select("*")
        .eq("userID", userID)
        .maybeSingle();
  }

  PostgrestTransformBuilder<Map<String, dynamic>?> fetchDoctorByPhone(
    String phone,
  ) {
    return client
        .from(doctortable)
        .select("*")
        .eq('phone->>phone', phone)
        .maybeSingle();
  }

  PostgrestFilterBuilder<dynamic> updateDoctor(Doctor doctor) {
    return client
        .from(doctortable)
        .update(doctor.copyWith(userID: client.auth.currentUser?.id).toMap())
        .eq("id", doctor.id!);
  }
}
