import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser{
  final String? Email;
  final bool isEmailverified;
  const AuthUser({
    required this.isEmailverified,
    required this.Email,
   });

  factory AuthUser.fromFirebase(User user) =>  AuthUser(
      Email: user.email, isEmailverified: user.emailVerified
  );
}

