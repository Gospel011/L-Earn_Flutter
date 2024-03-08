import 'package:l_earn/DataLayer/DataSources/auth_source.dart';
import 'package:l_earn/DataLayer/DataSources/backend_source.dart';
import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Models/file_model.dart';
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
          title: response["title"] ?? 'Login failed',
          content: response["message"]);
    }
  }

  static Future<dynamic> sentForgotPasswordOtp() async {
    final dynamic response = await AuthSource.sendPasswordResetOtp();

    //* return "success" or AppError
    if (response == 'success') {
      return "success";
    } else {
      return AppError(
          title: response["title"] ?? 'Error', content: response["message"]);
    }
  }

  static Future<dynamic> resetPassword() async {
    final dynamic response = await AuthSource.resetPassword();

    if (response == 'success') {
      return "success";
    } else {
      return AppError.errorObject(response);
    }
  }

  static editProfile(
      token, Map<String, String> details, List<File>? imageFiles) async {
    final response = await BackendSource.makeMultiPartRequest(
        token, 'user/update-profile',
        method: "PATCH", body: details, files: imageFiles);

    print("::: R E S P O N S E   F R O M   A U T H R E P O   $response");

    if (response['status'] == 'success') {
      return User.fromMap(response['user']);
    } else {
      return AppError.errorObject(response);
    }
  }

  static followUser(String token, String userId) async {
    final endpoint = 'user/$userId/actions/follow';

    final response = await BackendSource.makeRequest(
        endpoint: endpoint, token: token, body: {});

  print("::: F O L L O W   R E S P O N S E   F R O M   A U T H R E P O   $response");

    if (response['status'] == 'success') {
      return response['message'] == "user followed successfully" ? true : false;
    } else {
      return AppError.errorObject(response);
    }
  }

  static getFollowStatus(token, String userId) async {
    final endpoint = 'user/$userId/actions/follow-status';

    final response = await BackendSource.makeGETRequest(token, endpoint);

  print("::: F O L L O W S T A T U S   R E S P O N S E   F R O M   A U T H R E P O   $response");

    if (response['status'] == 'success') {
      return response['message'] == "followed" ? true : false;
    } else {
      return AppError.errorObject(response);
    }
  }
}
