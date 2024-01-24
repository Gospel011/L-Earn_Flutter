// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_cubit.dart';

abstract class AuthState {
  final User? user;
  final String? email;

  const AuthState({this.user, this.email});

  @override
  String toString() => 'AuthState(user: $user, email: $email)';
}

//*
///? Auth state for new users and for those that have not logged in
final class AuthInitial extends AuthState {
  const AuthInitial({super.user});
}

///? Auth state when login request is sent to the server to process
final class AuthLoggingIn extends AuthState {}

///? Auth state for those that have logged in
final class AuthLoggedIn extends AuthState {
  const AuthLoggedIn({required super.user});
}

//*
/// Auth state for users that want to signup signup
final class AuthRequestSignup extends AuthState {}

///? Auth state when signup request is sent to the server to process
final class AuthSigningUp extends AuthState {}

///? Auth state when signup request is approved
final class AuthSignedUp extends AuthState {
  ///* The email of the recently signed up user
  const AuthSignedUp({required super.email});
}

//*
///? Auth state when forgot

//*
///? Auth state when authentication failed
final class AuthFailed extends AuthState {
  final AppError error;
  const AuthFailed({required this.error});
}

