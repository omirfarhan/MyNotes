import 'package:firebase_core/firebase_core.dart';
import 'package:miniappflutter/firebase_options.dart';
import 'package:miniappflutter/services/auth/auth_user.dart';
import 'package:miniappflutter/services/auth/Auth_provider.dart';
import 'package:miniappflutter/services/auth/auth_exceptions.dart';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth,
FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider{

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {


    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password);

      final user=currentuser;
      if(user!=null){
        return user;
      }else{
        throw UserNotloggedinAuthException();
      }
    }on FirebaseAuthException catch (e){

      if(e.code=='email-already-in-use'){
        throw EmailAreadyInuseAuthException();
      }else if(e.code=='weak-password'){
        throw WeekPasswordAuthException();
      }else if(e.code=='invalid-email'){
        throw InvalidEmailAuthException();
      }else{
        throw GenericEmailAuthException();
      }

    }catch (_){
      throw GenericEmailAuthException();
    }

  }

   @override

   AuthUser? get currentuser {
     final user=FirebaseAuth.instance.currentUser;
     if(user!=null){
       return AuthUser.fromFirebase(user);
     }else{
       return null;
     }
   }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try{

     await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password);
     final user=currentuser;
     if(user!=null){
       return user;
     }else{
       throw UserNotloggedinAuthException();
     }

    }on FirebaseAuthException catch (e){

      if(e.code=='wrong-password'){
        throw WrongPasswordAuthException();
      }else if(e.code=='user-not-found'){
        throw UsernotFoundAuthException();
      }else {
        throw GenericEmailAuthException();
      }


    }catch (_) {
      throw GenericEmailAuthException();
    }
  }

  @override
  Future<void> logout() async{
    final user= await FirebaseAuth.instance.currentUser;
    if(user!=null){
     await FirebaseAuth.instance.signOut();
    }else{
      throw UserNotloggedinAuthException();
    }
  }

  @override
  Future<void> sendEmailverification() async{
   final user= await FirebaseAuth.instance.currentUser;

   if(user!=null){
     await user.sendEmailVerification();
   }else{
     throw UserNotloggedinAuthException();
   }

  }

  @override
  Future<void> initalize() async {

   await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  }


}