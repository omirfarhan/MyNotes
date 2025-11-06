
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:miniappflutter/constants/routes.dart';
import 'package:miniappflutter/services/auth/auth_services.dart';
import 'package:miniappflutter/utilities/show_Error_Dialoge.dart';

import 'package:miniappflutter/services/auth/auth_exceptions.dart';

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
                  await AuthServices.firebase().createUser(
                      email: email,
                      password: password);

                  await AuthServices.firebase().sendEmailverification();
                  Navigator.of(context).pushNamed(verifyemailRoute);
                 // print(credentital);
                }on EmailAreadyInuseAuthException{
                  Fluttertoast.showToast(
                      msg: "Email already used!");
                  await showErrorDialoge(context,
                    'Email already used!',
                  );

                }on WeekPasswordAuthException{
                  await showErrorDialoge(context,
                      'Week password please ensure strong password',
                  );

                }on GenericEmailAuthException{
                  await showErrorDialoge(context,
                      'Faild to register'
                  );
                }

              },
              child: const Text('Register')
      
          ),
          TextButton(
              onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute, (route)=>false);
              },
              child: const Text('Already registerd? Login here!')
          )
      
        ],
      
      
      ),
    );
  }
}