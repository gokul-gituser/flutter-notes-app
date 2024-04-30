import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';



class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title:const Text("Verify email")),
      body: Column(children: [
        const Text("We have sent you an email for verification. Please check your mail"),
        const Text("If you have not received a verification email, tap the text below"),
        TextButton(onPressed: () async {
          await AuthService.firebase().sendEmailVerification();
        }, child: Text(" send mail verification")),
        TextButton(onPressed: () async{
          await AuthService.firebase().logOut();
          Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
        }, child: const Text("Restart")),

      ],
      ),
    );
  }
}
