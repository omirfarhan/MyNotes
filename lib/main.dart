

import 'package:flutter/material.dart';
import 'package:miniappflutter/constants/routes.dart';
import 'package:miniappflutter/services/auth/auth_services.dart';
import 'package:miniappflutter/views/Register_view.dart';
import 'package:miniappflutter/views/login_view.dart';
import 'package:miniappflutter/views/verify_emailview.dart';

import 'notes_view.dart';





void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'flutter demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const Home(),
      routes: {
        registerRoute : (context) =>const RegisterView(),
        loginRoute : (context) =>const LoginView(),
        mainuiRoute : (context) =>const NotesMainUI(),
        verifyemailRoute: (context) => const VerifyEmailView(),

      },

    ),

  );
}


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
      future: AuthServices.firebase().initalize(),

      builder: (context, snapshot) {

        switch(snapshot.connectionState){

          case ConnectionState.done:

            final user= AuthServices.firebase().currentuser;

            if(user!=null){

              if(user.isEmailverified){
                return const NotesMainUI();
              }else{
                return const VerifyEmailView();
              }

            }else{
              return const LoginView();
            }

            
          default:
            return const CircularProgressIndicator();

        }

      },



    );
  }
}






