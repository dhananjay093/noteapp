import 'package:bloc/bloc.dart';
import 'package:newapp/pages/serices/auth/auth_provider.dart';
import 'package:newapp/pages/serices/bloc/auth_state.dart';
import 'package:newapp/pages/serices/bloc/auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    // send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.SendEmailVerification();
      emit(state);
    });
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.CreateUser(
          email: email,
          password: password,
        );
        await provider.SendEmailVerification();
        emit(const AuthStateNeedsVerification());
      } on Exception catch (e) {
        emit(AuthStateRegistering(e));
      }
    });

    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentuser;
      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });
    // log in
    on<AuthEventLogIn>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.LogIn(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(const AuthStateNeedsVerification());
        } else {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(AuthStateLoggedIn(user));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });
    // log out
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.LogOut();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });
  }
}
