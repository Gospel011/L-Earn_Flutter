import 'package:bloc/bloc.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super( const AuthInitial());

  //? METHODS
  //* Sign up
  Future<void> signUp() async {}

  //* Send otp
  Future<void> sendOtp() async {}

  //* Verify Email
  Future<void> verifyEmail() async {}

  Future<void> verifyPhone(String phone) async {}

  //* Log in
  Future<void> login() async {}

  //* Log out
  Future<void> logout() async {}
}
