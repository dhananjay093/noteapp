import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:newapp/pages/constants/routes.dart';
import 'package:newapp/pages/serices/auth/auth_service.dart';
import 'package:newapp/pages/serices/auth/authexceptions.dart';
import 'package:newapp/pages/serices/bloc/auth_bloc.dart';
import 'package:newapp/pages/serices/bloc/auth_event.dart';
import 'package:newapp/pages/utilities/dailog/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      appBar: AppBar(
        title: const Text('Login'),
      ),
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
                context.read<AuthBloc>().add(
                      AuthEventLogIn(email, password),
                    );
              } on UserNotFoundAuthException {
                showerrordialog(context, 'user not found');
              } on WrongPasswordAuthException {
                showerrordialog(context, 'wrong password');
              } on GenericAuthException {
                showerrordialog(context, 'Error');
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
