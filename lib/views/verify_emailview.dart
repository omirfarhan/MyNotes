import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              final user=FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text('Send email Verification'),
          ),

          TextButton(
              onPressed: () async {
               await FirebaseAuth.instance.signOut();
              }, child: const Text('Restart'),
          )


        ],
      ),
    );
  }
}