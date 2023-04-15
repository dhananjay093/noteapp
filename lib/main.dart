import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp/pages/constants/routes.dart';
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
        loginroute: (context) => const LoginView(),
        registerroute: (context) => const RegisterView(),
        notesroute: (context) => const NotesView(),
        verifyemailview: (context) => const VerifyEmailView(),
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedIn) {
          return const NotesView();
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
