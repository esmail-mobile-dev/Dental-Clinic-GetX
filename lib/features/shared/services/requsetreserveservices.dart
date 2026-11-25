import 'package:mysen/core/constant.dart';
import 'package:mysen/features/shared/model/request_reservation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Requstreserveservices {
  final requstReservtable = "requestreservation";

  PostgrestFilterBuilder<List<Map<String, dynamic>>> fetchRequstReserve() {
    return client.from(requstReservtable).select("*,patient(fullName,phone)");
  }

  PostgrestFilterBuilder<dynamic> upsertRequstReserve(
    Requestreservation requestreservation,
  ) {
    return client
        .from(requstReservtable)
        .upsert(requestreservation.toMap(), onConflict: 'patientID,doctorID');
  }

  PostgrestFilterBuilder<dynamic> updateRequest(
    Requestreservation requestreservation,
  ) {
    return client
        .from(requstReservtable)
        .update(requestreservation.toMap())
        .eq("id", requestreservation.id!);
  }
}
