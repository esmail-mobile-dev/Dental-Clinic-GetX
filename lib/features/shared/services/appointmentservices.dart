import 'package:mysen/core/constant.dart';
import 'package:mysen/features/shared/model/appointment.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Appointmentservices {
  final appointmenttable = "appointment";

  PostgrestFilterBuilder<List<Map<String, dynamic>>> fetchAppointment() {
    return client.from(appointmenttable).select("*");
  }

  PostgrestTransformBuilder<List<Map<String, dynamic>>> fetchAppointmentBydpID(
    String dpID,
  ) {
    return client
        .from(appointmenttable)
        .select("*")
        .eq('doctorPatientID', dpID)
        .order('createdAt', ascending: true);
  }

  PostgrestTransformBuilder<Map<String, dynamic>> addAppointment(
    Appointment appointment,
  ) {
    return client
        .from(appointmenttable)
        .insert(appointment.toMap())
        .select()
        .single();
  }
}
