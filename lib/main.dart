
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:miniappflutter/firebase_options.dart';
import 'package:miniappflutter/views/Register_view.dart';
import 'package:miniappflutter/views/login_view.dart';
import 'package:miniappflutter/views/verify_emailview.dart';
import 'dart:developer' as devtools show log;




void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'flutter demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const Home(),
      routes: {
        '/Register/': (context) =>const RegisterView(),
        '/login/': (context) =>const LoginView(),
        '/notes/': (context) =>const NotesMainUI(),
      },

    ),

  );
}


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform
      ),
      builder: (context, snapshot) {

        switch(snapshot.connectionState){

          case ConnectionState.done:
            final user= FirebaseAuth.instance.currentUser;
            if(user!=null){
              if(user.emailVerified){
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

enum MainAction{
  logout
}

class NotesMainUI extends StatefulWidget {
  const NotesMainUI({super.key});

  @override
  State<NotesMainUI> createState() => _NotesMainUIState();
}

class _NotesMainUIState extends State<NotesMainUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('My Notes')
        ,actions: [

          PopupMenuButton<MainAction>(
            onSelected: (value) async {
              switch(value)  {

                case MainAction.logout:
                 final showlogout= await showLogoutDialoge(context);

                 if(showlogout){
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login/', (_) => false,
                  );
                 }

                 debugPrint(showlogout.toString());
                 break;
              }
              //debugPrint(value.toString());
            },

            itemBuilder: (context) {
              return const[
                PopupMenuItem<MainAction>(
                  value:MainAction.logout,
                  child: const Text('Logout'),
                ),
                


              ];
            },

          )

      ],
      ),
      body: const Text('Hello my notes'),

    );
  }
}
Future<bool> showLogoutDialoge(BuildContext context){
  
  return showDialog<bool>(
      context: context,
      builder: (context){
       return AlertDialog(
         title: const Text('Sign Out'),
         content: const Text('Are you sure you want to sign out?'),
         actions: [
           TextButton(
               onPressed: () {
                 Navigator.of(context).pop(false);
               },
               child: const Text('Cancel')
           ),

           TextButton(
               onPressed: () {
                 Navigator.of(context).pop(true);
               },
               child: const Text('Log out'))
         ],
       );
      }
  ).then((value) => value ?? false,);
}





