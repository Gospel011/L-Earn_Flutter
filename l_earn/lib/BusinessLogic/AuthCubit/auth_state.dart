// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_cubit.dart';

abstract class AuthState {
  final User? user;

  const AuthState({this.user});

  @override
  String toString() => 'AuthState(user: $user)';
}

///? Auth state for new users and for those that have not logged in
final class AuthInitial extends AuthState {
  const AuthInitial({super.user});
}

///? Auth state for those that have logged in
final class AuthLoggedIn extends AuthState {
  const AuthLoggedIn({super.user});
}
