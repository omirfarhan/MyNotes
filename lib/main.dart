
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

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:(context) => VerifyEmailView(),
                    ),
                  );
                }
                return const Text('Firebase is Connected');
              default:
                return const Text('Loading...');

            }

          },



      ),


    );
  }
}


class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Column(
        children: [
          const Text('Verify is your email Address'),
          TextButton(
              onPressed: () {
                
              },
              child: const Text('Send email Verification'),
          )


        ],
      ),

    );
  }
}



