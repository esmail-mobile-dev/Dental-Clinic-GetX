import 'package:mysen/core/constant.dart';
import 'package:mysen/features/shared/model/treatment_case.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Treatmentcaseservices {
  final treatmenttable = "treatmentCase";

  PostgrestFilterBuilder<List<Map<String, dynamic>>> fetchTreatmentCase() {
    return client.from(treatmenttable).select("*");
  }

  PostgrestTransformBuilder<List<Map<String, dynamic>>>
  fetchTreatmentCaseBydpID(String dpID) {
    return client
        .from(treatmenttable)
        .select("*")
        .eq('doctorPatientID', dpID)
        .order('createdAt', ascending: true);
  }

  PostgrestTransformBuilder<Map<String, dynamic>> addTreatmentCase(
    TreatmentCase treatmentCase,
  ) {
    return client
        .from(treatmenttable)
        .insert(treatmentCase.toMap())
        .select()
        .single();
  }

  PostgrestFilterBuilder<dynamic> updateTreatmentCase(
    TreatmentCase treatmentCase,
  ) {
    return client
        .from(treatmenttable)
        .update(treatmentCase.toMap())
        .eq('id', treatmentCase.id);
  }

  PostgrestFilterBuilder<dynamic> deleteTreatmentCase(
    TreatmentCase treatmentCase,
  ) {
    return client.from(treatmenttable).delete().eq('id', treatmentCase.id);
  }
}
