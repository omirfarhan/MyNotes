
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:miniappflutter/firebase_options.dart';
import 'package:miniappflutter/views/Register_view.dart';
import 'package:miniappflutter/views/login_view.dart';




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
            print(user);
            // if(user?.emailVerified??false){
            //   print('You are verified user');
            //
            // }else{
            //   print('you need to email verify first');
            //
            //   return const VerifyEmailView();
            // }

            return const LoginView();
        //return const Text('Firebase is Connected');
          default:
            return const Text('Loading...');

        }

      },



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
    return   Column(
      children: [
        const Text('Verify is your email Address'),
        TextButton(
          onPressed: () async {
            final user=FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          },
          child: const Text('Send email Verification'),
        )


      ],
    );
  }
}



