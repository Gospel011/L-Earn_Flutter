import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Models/file_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/DataLayer/Repositories/auth_repo.dart';
import 'package:l_earn/Helpers/auth_helper.dart';

import 'auth_state.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  //? METHODS
  //* Sign up
  Future<void> signUp() async {
    //* emit signing up
    emit(const AuthSigningUp());

    //* tell auth repo to sign user up
    final dynamic response = await AuthRepo.signup();
    print('response from authcubit is $response');

    //* return result to user
    if (response is String) {
      emit(AuthSignedUp(email: response));
      AuthHelper.userMap.clear();
    } else {
      emit(AuthFailed(error: response as AppError));
    }
  }

  //* Send otp
  Future<void> sendOtp() async {}

  //* Verify Email
  Future<void> verifyEmail() async {}

  Future<void> verifyPhone(String phone) async {}

  //? Log in
  Future<void> login() async {
    //* Emit AuthLoggingIn
    emit(AuthLoggingIn());

    //* Tell AuthRepo to log user in {response is User or AppError object}
    final response = await AuthRepo.logUserIn();

    print("::: L O G I N RESPONSE FROM AUTH CUBIT IS $response");

    //* Emit AuthLoggedIn or AuthFailed
    if (response is User) {
      emit(AuthLoggedIn(user: response));
    } else {
      emit(AuthFailed(error: response as AppError));
    }
  }

  //* Log out
  Future<void> logout() async {
    emit(const AuthInitial());
  }

  Future<void> forgotPassword() async {
    emit(AuthRequestingPasswordResetOtp());

    final dynamic response = await AuthRepo.sentForgotPasswordOtp();

    if (response == 'success') {
      emit(AuthPasswordResetOtpSent(email: AuthHelper.userMap["email"]!));
    } else {
      emit(AuthPasswordResetOtpNotSent(error: response as AppError));
    }
  }

  Future<void> resetPassword() async {
    emit(const AuthResetingPassword());

    final dynamic response = await AuthRepo.resetPassword();

    if (response == 'success') {
      emit(AuthPasswordChanged(email: AuthHelper.userMap["email"]!));
    } else {
      emit(AuthPasswordResetFailed(
          error: response as AppError, email: AuthHelper.userMap["email"]));
    }
  }

  Future<void> editProfile(
      {required Map<String, String> details, List<File>? imageFiles}) async {
    emit(AuthEditingProfile(user: state.user));

    String? token = state.user?.token;

    final response = await AuthRepo.editProfile(token, details, imageFiles);

    if (response is User) {
      User user = response.copyWith(token: token);

      emit(AuthProfileEdited(user: user));
    } else {
      emit(AuthEditingProfileFailed(
          user: state.user, error: response as AppError));
    }
  }

  @override
  AuthState fromJson(Map<String, dynamic> json) {
    print("Retrieved previously saved state");

    return AuthState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    print("::: SAVED $state :::");
    print("New state saved");

    return state.toMap();
  }




  

}


