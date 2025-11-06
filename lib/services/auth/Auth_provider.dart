import 'package:miniappflutter/services/auth/auth_user.dart';


abstract class AuthProvider{

  //currentuser = এ মুহূর্তে কে logged in আছে” — সেই user-এর তথ্য দেওয়া।
  AuthUser? get currentuser;

  Future<void> initalize();

  Future<AuthUser> logIn({
    required String email,
    required String password,

});
  Future<AuthUser> createUser({
    required String email,
    required String password,
});

  Future<void> logout();
  Future<void> sendEmailverification();

}