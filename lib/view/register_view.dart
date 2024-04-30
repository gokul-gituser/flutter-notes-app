import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';


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
    _email = TextEditingController();
    _password = TextEditingController();
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
   return Scaffold(
    appBar: AppBar(title: const Text("Register"),),
     body: Column(children: [
                    TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(hintText: "Enter Your Email"),
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration:
                          const InputDecoration(hintText: "Enter Your Password"),
                    ),
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try{
                            await AuthService.firebase().createUser(email: email, password: password);
                             // devtools.log(userCredential.toString());
                             AuthService.firebase().sendEmailVerification();
                             Navigator.of(context).pushNamed(verifyEmailRoute);

                        }on WeakPasswordAuthException{
                          showErrorDialog(context, 'Password should be at least 6 characters');
                        }on InvalidEmailAuthException{
                          showErrorDialog(context, 'Enter a Valid Email');
                        }on ChannelErrorAuthException{
                          showErrorDialog(context, 'Fields Cannot Be Empty');
                        }on EmailAlreadyInUseAuthException{
                          showErrorDialog(context, 'The email address is already in use by another account.');
                        }on GenericAuthException{
                          await showErrorDialog(context, 'Failed to Register');
                        }
               
                        
                      },
                      child: const Text('Register'),
                    ),
                    Text("Already have an account? "),
                    TextButton(onPressed: (){
                        Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false,);

                    }, child: Text("Login"),)
                  ]),
   );
  }
}

