import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:miniappflutter/constants/routes.dart';
import 'package:miniappflutter/utilities/show_Error_Dialoge.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}



class _LoginViewState extends State<LoginView> {
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
    return MaterialApp(

        title: 'flutter demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Login'),
          ),

          body: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, asyncSnapshot) {
              switch(asyncSnapshot.connectionState){

                case ConnectionState.done:

                  ;
                default:
                  return const Text('This is Loading...');
              }


            },
          ),

        )
    );

     */

    return Scaffold(
      appBar: AppBar(title: const Text('Login'),),
      body: Column(
      
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Enter Your Email',
      
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:InputDecoration(labelText: 'Enter your password'
            ),
          ),
      
          TextButton(onPressed:() async {
            final email=_email.text;
            final password=_password.text;
      
            try{
              final credential= await FirebaseAuth.instance.
              signInWithEmailAndPassword(
                  email: email,
                  password: password,
              );

              Navigator.of(context).pushNamedAndRemoveUntil(
                  mainuiRoute, (route)=> false,
              );
              // print(credential);
              debugPrint(credential.toString());
            } on FirebaseAuthException catch (e){



              if(e.code=='wrong-password'){

                await showErrorDialoge(context, 'wrong password');
                Fluttertoast.showToast(msg: 'Wrong Password please right password confirm');

              }else if(e.code=='user-not-found'){
                await showErrorDialoge(context, 'invalid credential');
              }else{
                await showErrorDialoge(context, 'Error: ${e.code}');
              }
            }catch (e){
              await showErrorDialoge(context, e.toString());
            }
      
      
          },
      
            child: const Text('Login'),
      
          ),
          
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute, (route) => false);
              }, 
              child: const Text('No register yet? Register here!')
          ),
          
      
        ],
      ),
    );


  }
}