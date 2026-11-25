import 'package:mysen/core/constant.dart';
import 'package:mysen/features/shared/model/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserDetailsservices {
  final userDetailsTable = "userdetails";
  PostgrestTransformBuilder<Map<String, dynamic>?> fetchUserByUserID() {
    return client
        .from(userDetailsTable)
        .select('role')
        .eq('userID', client.auth.currentUser!.id)
        .maybeSingle();
  }

  //update user details
  PostgrestFilterBuilder<dynamic> upsertUserDetails(UserDetails userDetails) {
    return client
        .from(userDetailsTable)
        .upsert(userDetails.toMap(), onConflict: 'userID,role');
  }
}
