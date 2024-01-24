import 'package:l_earn/DataLayer/DataSources/auth_source.dart';
import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';

class AuthRepo {
  static dynamic signup() async {
    //* tell auth source to sign user up
    final dynamic response = await AuthSource.signup();

    //* return user's email or an error object

    if (response["status"] == 'success') {
      return response["data"]["newUser"]["email"];
    } else {
      return AppError(
          title: response["title"] ?? 'Signup failed',
          content: response["message"]);
    }
  }

  static Future<dynamic> sendEmailOtp() async {
    //* tell auth source to send email otp
    final dynamic response = await AuthSource.sendEmailOtp();
    //* return "success" or AppError
    if (response == 'success') {
      return "success";
    } else {
      return AppError(
          title: response["title"] ?? 'Email not sent',
          content: response["message"]);
    }
  }

  static verifyEmailOtp() async {
    //* tell auth source to send email otp
    final dynamic response = await AuthSource.verifyEmailOtp();

    print(":::: RESPONSE FROM AUTH REPO ::: \n$response");

    //* return "success" or AppError
    if (response == 'success') {
      return "success";
    } else {
      return AppError(
          title: response["title"] ?? 'Error', content: response["message"]);
    }
  }

  static Future<dynamic> logUserIn() async {
    //* Tell auth source to login
    final response = await AuthSource.login();
    //* return user or an error object

    if (response["status"] == 'success') {
      Map<String, dynamic> userMap = response["user"];
      userMap["token"] = response["token"];
      return User.fromMap(userMap);
    } else {
      return AppError(
          title: response["title"] ?? 'Signup failed',
          content: response["message"]);
    }
  }
}
