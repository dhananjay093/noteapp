import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:newapp/pages/constants/routes.dart';
//import 'package:flutter/widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(title: const Text('Login'),),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter Email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter Password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final usercredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(email: email, password: password);
                devtools.log(usercredential.toString());
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(notesroute, (route) => false);

              } on FirebaseAuthException catch (e) {
                devtools.log(e.code);
              }
            },
            child: const Text('login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerroute, (route) => false);
            },
            child: const Text('Not registered yet? Register now!'),
          )
        ],
      ),
    );
  }
}
