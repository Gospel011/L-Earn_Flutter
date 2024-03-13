import 'package:l_earn/utils/constants.dart';
import 'package:email_validator/email_validator.dart';

///? Confirms if the email is valid
String? emailValidator(value) {
  if (EmailValidator.validate(value.toString())) {
    return null;
  } else {
    return 'Please provide a valid email address';
  }
}

///? Confirms if the handle is valid
String? handleValidator(value) {
  if (value.toString().replaceAll('@', '').trim() != '') {
    return null;
  } else {
    return 'Pleae provide a valid handle';
  }
}

///? confirms if the password is valid
String? passwordValidator(value) {
  if (value.split('').length >= passwordLowerLimit) {
    return null;
  } else {
    return 'Your password must be atleast $passwordLowerLimit characters long';
  }
}

///? Confirms if the confirmPassword field is valid and matches the password
///field
String? signupConfirmPasswordValidator(value, passwordValue) {
  //TODO

  print("Value = $value Password value = $passwordValue");
  if (value == '') {
    return "Please confirm your password";
  } else if (value != passwordValue) {
    return "Your password and confirm password don't match";
  } else {
    return null;
  }
}

///? Confirms if the lastName is valid
String? lastNameFieldValidator(value) {
  //TODO
  if (value == '') {
    return "Please enter your last name";
  } else if (value.split("").length < 2) {
    return "Atleast two letters long";
  } else {
    return null;
  }
}

///? Confirms if the firstName is valid
String? firstNameFieldValidator(value) {
  //TODO
  if (value == '') {
    return "Please enter your first name";
  } else if (value.split("").length < 2) {
    return "Atleast two letters long";
  } else {
    return null;
  }
}

///? Ensures that otp has value
String? otpValidator(value) {
  if (value == '') {
    return '';
  }
}
