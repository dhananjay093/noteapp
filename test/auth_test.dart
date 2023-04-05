import 'package:flutter_test/flutter_test.dart';
import 'package:newapp/pages/serices/auth/auth_provider.dart';
import 'package:newapp/pages/serices/auth/auth_user.dart';
import 'package:newapp/pages/serices/auth/authexceptions.dart';

void main() {
  group('Mock Authentication', () {
    final provider = mockAuthProvider();
    test('Should not be initialized', () {
      expect(provider.isInitialized, false);
    });

    test(
      'Should be able to initialize in less than 2 second',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
  });
}

class NotInitializedExceptiion implements Exception {}

class mockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> CreateUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedExceptiion();
    await Future.delayed(Duration(seconds: 1));
    throw LogIn(email: email, password: password);
  }

  @override
  Future<AuthUser> LogIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedExceptiion();
    if (email == 'dhananjaysharma@gmail') throw UserNotFoundAuthException();
    if (password == '00') throw WrongPasswordAuthException();
    const user = AuthUser(id: 'user-id',isEmailVerified: false, email: 'dhananjaysharma2021@gmail',);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> LogOut() async {
    if (isInitialized == false) throw NotInitializedExceptiion();
    await Future.delayed(Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> SendEmailVerification() async {
    if (!isInitialized) throw NotInitializedExceptiion();
    await Future.delayed(Duration(seconds: 1));
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newuser = AuthUser(id: 'user-id',isEmailVerified: true, email: 'dhananjaysharma2021@gmail',);
    _user = newuser;
  }

  @override
  // TODO: implement currentuser
  AuthUser? get currentuser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(Duration(seconds: 1));
    _isInitialized = true;
  }
}
