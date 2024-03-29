import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/pages/constants/routes.dart';
import 'package:newapp/pages/forgot_password_view.dart';
import 'package:newapp/pages/loginview.dart';
import 'package:newapp/pages/notes/create_update_note_view.dart';
import 'package:newapp/pages/registerview.dart';
import 'package:newapp/pages/serices/auth/auth_service.dart';
import 'package:newapp/pages/serices/auth/firebase_auth_provider.dart';
import 'package:newapp/pages/serices/bloc/auth_bloc.dart';
import 'package:newapp/pages/serices/bloc/auth_event.dart';
import 'package:newapp/pages/serices/bloc/auth_state.dart';
import 'package:newapp/pages/verify_email_view.dart';
import 'package:newapp/pages/notes/notes.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as devtools show log;

import 'helpers/loading/loading_Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: Homepage(),
      ),
      routes: {
        createupdatenoteview: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class Homepage extends StatelessWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedOut) {
          return const LoginView();
          } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );

    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            devtools.log(AuthService.firebase().currentuser.toString());
            final user = AuthService.firebase().currentuser;
            if (user != null) {
              if (user.isEmailVerified) {
                devtools.log('email verified');
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
