import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/pages/serices/auth/auth_service.dart';
import 'package:newapp/pages/serices/bloc/auth_bloc.dart';
import 'package:newapp/pages/serices/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text(
              'An email verification link has been sent to your email.Click on link to verify'),
          const Text(
              'If verification email not sent. Click on the below button'),
          TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(
                      AuthEventSendEmailVerification(),
                    );
              },
              child: const Text('send email verification')),
          TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      AuthEventLogOut(),
                    );
              },
              child: Text('Login'))
        ],
      ),
    );
  }
}
