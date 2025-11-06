import 'package:miniappflutter/services/auth/Auth_provider.dart';
import 'package:miniappflutter/services/auth/auth_user.dart';
import 'package:miniappflutter/services/auth/firebase_auth_provider.dart';

class AuthServices implements AuthProvider{

  final AuthProvider provider;
  const AuthServices(this.provider);

  factory AuthServices.firebase() => AuthServices(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,

  }) => provider.createUser(
      email: email,
      password: password,
  );

  @override
  // TODO: implement currentuser
  AuthUser? get currentuser => provider.currentuser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) => provider.logIn(
      email: email,
      password: password
  );

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailverification() => provider.sendEmailverification();

  @override
  Future<void> initalize() => provider.initalize();

}