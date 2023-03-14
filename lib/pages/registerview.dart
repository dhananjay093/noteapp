//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newapp/pages/serices/auth/auth_service.dart';
import 'package:newapp/pages/serices/auth/authexceptions.dart';
import 'package:newapp/pages/utilities/showerrordialog.dart';

import 'constants/routes.dart';
//import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);
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
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'enter email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'enter password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase()
                    .CreateUser(email: email, password: password);

                await AuthService.firebase().SendEmailVerification();
                Navigator.of(context).pushNamed('/verifyemail/');
              } on EmailAlreadyInUseAuthException {
                showerrordialog(context, 'email-already-in-use');
              } on WeakPasswordFoundAuthException {
                showerrordialog(context, 'weak password');
              } on GenericAuthException {
                showerrordialog(context, 'Error');
              }
            },
            child: const Text('register'),
          ),
          TextButton(
              onPressed: (() {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginroute, (route) => false);
              }),
              child: const Text('Already registered? Login here!'))
        ],
      ),
    );
  }
}
