import 'package:flutter/material.dart';
import 'package:newapp/pages/constants/routes.dart';
import 'package:newapp/pages/serices/auth/auth_service.dart';

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
                await AuthService.firebase().SendEmailVerification();
              },
              child: const Text('send email verification')),
          TextButton(
              onPressed: () {
                AuthService.firebase().LogOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerroute, (route) => false);
              },
              child: Text('Login'))
        ],
      ),
    );
  }
}
