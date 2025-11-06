import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniappflutter/constants/routes.dart';
import 'package:miniappflutter/services/auth/auth_services.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(title: const Text('Verify email'),),
      body: Column(
        children: [
          const Text("We've send you an email verification. Please open it to verify your account "),
          const Text("If you haven't receive a verification email yet, press the button below"),
          TextButton(
            onPressed: () async {

             await AuthServices.firebase().sendEmailverification();
              // final user=FirebaseAuth.instance.currentUser;
              // await user?.sendEmailVerification();
            },
            child: const Text('Send email Verification'),
          ),

          TextButton(
              onPressed: () async {
               //await FirebaseAuth.instance.signOut();
                await AuthServices.firebase().logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute, (route) => false);
              }, child: const Text('Restart'),
          )


        ],
      ),
    );
  }
}