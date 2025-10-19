
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email=TextEditingController();
    _password=TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    /*
    return Scaffold(

      appBar: AppBar(
        title: const Text('Register'),

      ),

      backgroundColor: Colors.white60,

      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.done:
              //column
            default:
              return const Text('Loading...');
          }

        },



      ),

    );

  }

     */
    return Scaffold(
        appBar: AppBar(title: const Text('RegisterView'),),
      body: Column(
        children: [
      
          TextField(
            controller: _email,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration: InputDecoration(labelText: 'Enter the email'),
      
      
          ),
      
          TextField(
      
            controller: _password,
            decoration: InputDecoration(labelText: 'Enter the password'),
            autocorrect: false,
            obscureText: true,
            enableSuggestions: false,
      
          ),
      
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  final credentital = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                      email: email,
                      password: password
                  );
                  print(credentital);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'email-already-in-use') {
                    Fluttertoast.showToast(
                        msg: "Email already used!");
      
                    print('Alrady email is used');
                  }
                }
              },
              child: const Text('Register')
      
          ),
          TextButton(
              onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login/', (route)=>false);
              },
              child: const Text('Already registerd? Login here!')
          )
      
        ],
      
      
      ),
    );
  }
}