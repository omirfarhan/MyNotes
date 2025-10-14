
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:miniappflutter/firebase_options.dart';
import 'package:miniappflutter/views/Register_view.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'flutter demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const Home()
    ),

  );
}


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),

      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform
          ),
          builder: (context, snapshot) {

            switch(snapshot.connectionState){

              case ConnectionState.done:
                final user= FirebaseAuth.instance.currentUser;
                if(user?.emailVerified??false){
                  print('You are verified user');
                }else{
                  print('you need to email verify first');
                }

                return const Text('Firebase is Connected'
                );

              default:
                return const Text('Loading...');

            }

          },



      ),


    );
  }
}





