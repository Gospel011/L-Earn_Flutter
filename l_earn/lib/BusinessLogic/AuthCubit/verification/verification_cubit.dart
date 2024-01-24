import 'package:bloc/bloc.dart';
import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Repositories/auth_repo.dart';

import '../../../Helpers/auth_helper.dart';

part 'verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  VerificationCubit() : super(VerificationInitial());

  //* request email verification otp
  Future<void> requestEmailVerificationOtp() async {
    emit(AuthRequestingEmailVerificationOtp(email: state.email));

    //? Ask AuthRepo to sendEmailOtp
    final response = await AuthRepo.sendEmailOtp(); //* string or AppError

    //? emit AuthEmailVerificationMailSent or AuthFailed
    if (response is String) {
      state.email != null
          ? emit(AuthEmailVerificationMailSent(email: state.email!))
          : null;
    } else {
      emit(VerificationFailed(error: response as AppError));
    }
  }

  //* request email verification otp
  Future<void> verifyEmailOtp() async {
    emit(VerifyingEmail());

    //? Ask AuthRepo to sendEmailOtp
    final response = await AuthRepo.verifyEmailOtp(); //* string or AppError


    //? emit AuthEmailVerificationMailSent or AuthFailed
    if (response == "success") {
    print(":::: RESPONSE FROM VERIFICATION CUBIT ::: \n$response");
      emit(EmailVerified(email: AuthHelper.userMap["email"]!));
    } else {
      emit(VerificationFailed(error: response as AppError));
    }
  }
}
