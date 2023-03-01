import 'package:newapp/pages/serices/auth/auth_provider.dart';
import 'package:newapp/pages/serices/auth/auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

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
  Future<void> LogOut() => provider.LogOut();

  @override
  Future<void> SendEmailVerification() => provider.SendEmailVerification();

  @override
  AuthUser? get currentuser => provider.currentuser;
}
