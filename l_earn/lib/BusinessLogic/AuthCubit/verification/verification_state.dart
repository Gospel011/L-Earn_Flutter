part of 'verification_cubit.dart';

abstract class VerificationState {
  final String? email;
  const VerificationState({this.email});
}

final class VerificationInitial extends VerificationState {}

//? Auth state when requesting email verification otp
final class AuthRequestingEmailVerificationOtp extends VerificationState {
  ///* Email of the user requesting email verification

  const AuthRequestingEmailVerificationOtp({required super.email});
}

final class AuthEmailVerificationMailSent extends VerificationState {
  const AuthEmailVerificationMailSent({required super.email});
}

final class VerificationFailed extends VerificationState {
  final AppError error;
  const VerificationFailed({required this.error});
}

final class VerifyingEmail extends VerificationState{}

final class EmailVerified extends VerificationState {
  
  const EmailVerified({required super.email});
}
