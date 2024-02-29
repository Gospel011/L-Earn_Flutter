import 'dart:convert';

import 'package:l_earn/Helpers/auth_helper.dart';
import 'package:http/http.dart' as http;
import 'package:l_earn/utils/constants.dart';
import '../Models/error_model.dart';

class AuthSource {
  static dynamic signup() async {
    //* get firstName, lastName, email, password and confirmPassword from
    //  AuthHelper

    final Uri url = Uri.parse('${NetWorkConstants.baseUrl}/user/signup');

    final body = {
      "firstName": AuthHelper.userMap["firstName"],
      "lastName": AuthHelper.userMap["lastName"],
      "email": AuthHelper.userMap["email"],
      "password": AuthHelper.userMap["password"],
      "confirmPassword": AuthHelper.userMap["confirmPassword"],
    };

    print('SIGNUP R E Q U E S T BODY = $body');

    //* communicate with server to sign user up

    try {
      http.Response serverResponse = await http.put(url,
          body: jsonEncode(body), headers: NetWorkConstants.defaultHeader);

      print('S I G N U P RESPONSE = ${jsonDecode(serverResponse.body)}');

      return jsonDecode(serverResponse.body);
    } catch (e) {
      if (e is http.ClientException) {
        String errno = "$e".split('errno = ')[1].split('),')[0];
        print("E R R O R NUMBER IS $errno :::");
        print(" E R R IS $e");
        return {
          "title": "Network Error",
          "message": "Please check your internet connection"
        };
      } else {
        return AppError.handleError(e);
      }
    }
  }

  static Future<dynamic> sendEmailOtp() async {
    final Uri url =
        Uri.parse('${NetWorkConstants.baseUrl}/user/send-email-otp');

    //* REQUEST BODY
    final Map<String, String> body = {"email": AuthHelper.userMap["email"]};

    //* tell server to send email verification otp
    try {
      http.Response serverResponse = await http.post(url,
          body: jsonEncode(body), headers: NetWorkConstants.defaultHeader);

      if (serverResponse.statusCode == 200) {
        return "success";
      } else {
        return jsonDecode(serverResponse.body);
      }
    } catch (e) {
      return AppError.handleError(e);
    }
  }

  static verifyEmailOtp() async {
    final Uri url = Uri.parse('${NetWorkConstants.baseUrl}/user/verify-email');

    //* REQUEST BODY
    final Map<String, String> body = {"otp": AuthHelper.userMap["otp"]};

    //* tell server to send email verification otp
    try {
      http.Response serverResponse = await http.post(url,
          body: jsonEncode(body), headers: NetWorkConstants.defaultHeader);

      if (serverResponse.statusCode == 200) {
        print(":::: RESPONSE FROM VERIFY EMAIL OTP ::: success");
        return "success";
      } else {
        print(":::: RESPONSE FROM VERIFY EMAIL OTP ::: failed");
        return jsonDecode(serverResponse.body);
      }
    } catch (e) {
      return AppError.handleError(e);
    }
  }

  static login() async {
    Uri url = Uri.parse('${NetWorkConstants.baseUrl}/user/login');
    Map<String, dynamic> body = {
      'email': AuthHelper.userMap['email'],
      'password': AuthHelper.userMap["password"]
    };

    //* send login request to server
    try {
      final http.Response serverResponse = await http.post(url,
          body: jsonEncode(body), headers: NetWorkConstants.defaultHeader);
          

      return jsonDecode(serverResponse.body);
    } catch (e) {
      return AppError.handleError(e);
    }
  }

  static sendPasswordResetOtp() async {
    final Uri url =
        Uri.parse('${NetWorkConstants.baseUrl}/user/forgot-password');

    //* REQUEST BODY
    final Map<String, String> body = {"email": AuthHelper.userMap["email"]};

    //* tell server to send forgot passwort otp
    try {
      http.Response serverResponse = await http.post(url,
          body: jsonEncode(body), headers: NetWorkConstants.defaultHeader);

      if (serverResponse.statusCode == 200) {
        return "success";
      } else {
        return jsonDecode(serverResponse.body);
      }
    } catch (e) {
      return AppError.handleError(e);
    }
  }

  static Future<dynamic> resetPassword() async {
    final Uri url =
        Uri.parse('${NetWorkConstants.baseUrl}/user/reset-password');

    //* REQUEST BODY
    final Map<String, String> body = {
      "otp": AuthHelper.userMap["otp"],
      "newPassword": AuthHelper.userMap["newPassword"],
      "newConfirmPassword": AuthHelper.userMap["newConfirmPassword"],
    };

    print(body);

    //* tell server to reset password
    try {
      http.Response serverResponse = await http.patch(url,
          body: jsonEncode(body), headers: NetWorkConstants.defaultHeader);

      if (serverResponse.statusCode == 200) {
        return "success";
      } else {
        return jsonDecode(serverResponse.body);
      }
    } catch (e) {
      return AppError.handleError(e);
    }
  }
}
