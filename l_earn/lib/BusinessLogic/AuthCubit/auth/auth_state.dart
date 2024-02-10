// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
// part of 'auth_cubit.dart';

class BaseState extends AuthState {
  const BaseState({super.user, super.email, super.error});
}

abstract class AuthState {
  final User? user;
  final String? email;
  final AppError? error;

  const AuthState({this.user, this.email, this.error});

  @override
  String toString() => 'AuthState(user: $user, email: $email)';

  Map<String, dynamic> toMap() {
    print(':::Converting authstate to map:::');
    return <String, dynamic>{
      'user': user?.toMap(),
      'email': email,
      'error': error?.toMap(),
    };
  }

  static AuthState fromMap(Map<String, dynamic> map) {
    print(':::Getting authstate from map:::');
    return BaseState(
      user: map['user'] != null
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      email: map['email'] != null ? map['email'] as String : null,
      error: map['error'] != null
          ? AppError.fromMap(map['error'] as Map<String, dynamic>)
          : null,
    );
  }
}

//*
///? Auth state when authentication failed
final class AuthFailed extends AuthState {
  const AuthFailed({required super.error});

  @override
  Map<String, dynamic> toMap() {
    print(':::Converting authstate to map:::');
    return <String, dynamic>{
      'error': error?.toMap(),
    };
  }

  @override
  AuthFailed fromMap(Map<String, dynamic> map) {
    print(':::Getting authstate from map:::');
    return AuthFailed(
      error: map['error'] != null
          ? AppError.fromMap(map['error'] as Map<String, dynamic>)
          : null,
    );
  }
}

//*
final class AuthPasswordResetFailed extends AuthState {
  AuthPasswordResetFailed({required super.error, super.email});

  @override
  Map<String, dynamic> toMap() {
    print(':::Converting authstate to map:::');
    return <String, dynamic>{
      'email': email,
      'error': error?.toMap(),
    };
  }

  @override
  AuthPasswordResetFailed fromMap(Map<String, dynamic> map) {
    print(':::Getting authstate from map:::');
    return AuthPasswordResetFailed(
      email: map['email'] != null ? map['email'] as String : null,
      error: map['error'] != null
          ? AppError.fromMap(map['error'] as Map<String, dynamic>)
          : null,
    );
  }
}

//*
///? Auth state for new users and for those that have not logged in
final class AuthInitial extends AuthState {
  const AuthInitial({super.user});

  @override
  Map<String, dynamic> toMap() {
    print(':::Converting authstate to map:::');
    return <String, dynamic>{
      'user': user?.toMap(),
    };
  }

  @override
  AuthInitial fromMap(Map<String, dynamic> map) {
    print(':::Getting authstate from map:::');
    return AuthInitial(
      user: map['user'] != null
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : null,
    );
  }
}

///? Auth state when login request is sent to the server to process
final class AuthLoggingIn extends AuthState {
  @override
  AuthLoggingIn fromMap(Map<String, dynamic> map) {
    print(':::Getting authstate from map:::');
    return AuthLoggingIn();
  }

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

///? Auth state when password reset otp request is being proccssed
final class AuthRequestingPasswordResetOtp extends AuthState {
  @override
  AuthRequestingPasswordResetOtp fromMap(Map<String, dynamic> map) {
    print(':::Getting authstate from map:::');
    return AuthRequestingPasswordResetOtp();
  }

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

///? Auth state when password reset otp request is being proccssed
final class AuthPasswordResetOtpSent extends AuthState {
  const AuthPasswordResetOtpSent({required super.email});

  @override
  Map<String, dynamic> toMap() {
    print(':::Converting authstate to map:::');
    return <String, dynamic>{
      'email': email,
    };
  }

  @override
  AuthPasswordResetOtpSent fromMap(Map<String, dynamic> map) {
    print(':::Getting authstate from map:::');
    return AuthPasswordResetOtpSent(
      email: map['email'] != null ? map['email'] as String : null,
    );
  }
}

final class AuthPasswordResetOtpNotSent extends AuthState {
  const AuthPasswordResetOtpNotSent({super.error});

  @override
  Map<String, dynamic> toMap() {
    print(':::Converting authstate to map:::');
    return <String, dynamic>{
      'error': error?.toMap(),
    };
  }

  @override
  AuthPasswordResetOtpNotSent fromMap(Map<String, dynamic> map) {
    print(':::Getting authstate from map:::');
    return AuthPasswordResetOtpNotSent(
      error: map['error'] != null
          ? AppError.fromMap(map['error'] as Map<String, dynamic>)
          : null,
    );
  }
}

///? Auth state when password has been changed
final class AuthPasswordChanged extends AuthState {
  const AuthPasswordChanged({super.email});

  @override
  Map<String, dynamic> toMap() {
    print(':::Converting authstate to map:::');
    return <String, dynamic>{
      'email': email,
    };
  }

  AuthPasswordChanged fromMap(Map<String, dynamic> map) {
    print(':::Getting authstate from map:::');
    return AuthPasswordChanged(
      email: map['email'] != null ? map['email'] as String : null,
    );
  }
}

///? Auth state when password is being reseted
final class AuthResetingPassword extends AuthState {
  const AuthResetingPassword() : super();

  @override
  AuthResetingPassword fromMap(Map<String, dynamic> map) {
    print(':::Getting authstate from map:::');
    return const AuthResetingPassword();
  }

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

///? Auth state for those that have logged in
final class AuthLoggedIn extends AuthState {
  const AuthLoggedIn({required User user}) : super(user: user);

  @override
  Map<String, dynamic> toMap() {
    print(':::Converting authstate to map:::');
    return <String, dynamic>{
      'user': user?.toMap(),
    };
  }

  @override
  AuthInitial fromMap(Map<String, dynamic> map) {
    print(':::Getting authstate from map:::');
    return AuthInitial(
      user: map['user'] != null
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : null,
    );
  }
}

//*
/// Auth state for users that want to signup signup
final class AuthRequestSignup extends AuthState {
  const AuthRequestSignup() : super();

  @override
  AuthRequestSignup fromMap(Map<String, dynamic> map) {
    print(':::Getting authstate from map:::');
    return const AuthRequestSignup();
  }

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

///? Auth state when signup request is sent to the server to process
final class AuthSigningUp extends AuthState {
  const AuthSigningUp() : super();

  @override
  AuthSigningUp fromMap(Map<String, dynamic> map) {
    print(':::Getting authstate from map:::');
    return const AuthSigningUp();
  }

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

///? Auth state when signup request is approved
final class AuthSignedUp extends AuthState {
  ///* The email of the recently signed up user
  const AuthSignedUp({required String email}) : super(email: email);

  @override
  Map<String, dynamic> toMap() {
    print(':::Converting authstate to map:::');
    return <String, dynamic>{
      'email': email,
    };
  }

  @override
  AuthPasswordChanged fromMap(Map<String, dynamic> map) {
    print(':::Getting authstate from map:::');
    return AuthPasswordChanged(
      email: map['email'] != null ? map['email'] as String : null,
    );
  }
}

//*
///? Auth state when forgot
