import 'package:newapp/pages/serices/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentuser;
  Future<AuthUser> LogIn({
    required String email,
    required String password,
  });

  Future<AuthUser> CreateUser({
    required String email,
    required String password,
  });

  Future<void> LogOut();
  Future<void> SendEmailVerification();
}
