
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:miniappflutter/firebase_options.dart';
import 'package:miniappflutter/views/Register_view.dart';
import 'package:miniappflutter/views/login_view.dart';
import 'package:miniappflutter/views/verify_emailview.dart';




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

enum MenuAction{
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


          PopupMenuButton<MenuAction>(
              onSelected: (value) {},
            itemBuilder: (context) {
                return const[
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text('Log out'),)
            ];

            },
          )

      ],
      ),
      body: const Text('Hello my notes'),

    );
  }
}





