import 'package:newapp/pages/serices/auth/auth_provider.dart';
import 'package:newapp/pages/serices/auth/auth_user.dart';
import 'package:newapp/pages/serices/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> CreateUser({
    required String email,
    required String password,
  }) =>
      provider.CreateUser(
        email: email,
        password: password,
      );

  @override
  Future<AuthUser> LogIn({
    required String email,
    required String password,
  }) =>
      provider.LogIn(
        email: email,
        password: password,
      );

  @override
  Future<void> LogOut() async => await provider.LogOut();

  @override
  Future<void> SendEmailVerification() async =>
      await provider.SendEmailVerification();

  @override
  AuthUser? get currentuser => provider.currentuser;

  @override
  Future<void> initialize() async {
    return await provider.initialize();
  }
}
