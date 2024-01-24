import 'package:bloc/bloc.dart';
import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/DataLayer/Repositories/auth_repo.dart';
import 'package:l_earn/Helpers/auth_helper.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  //? METHODS
  //* Sign up
  Future<void> signUp() async {
    //* emit signing up
    emit(AuthSigningUp());

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
}
