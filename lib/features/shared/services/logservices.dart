import 'package:mysen/core/constant.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Logservices {
  final auth = client.auth;

  Future<AuthResponse> signup(String email, String password) async {
    return await auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signin(String email, String password) async {
    return await auth.signInWithPassword(email: email, password: password);
  }
}
