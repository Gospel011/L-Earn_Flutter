String? emailValidator(value) {
  if (value.toString().contains('@')) {
    return null;
  } else {
    return 'Please provide a valid email address';
  }
}

String? passwordValidator(value) {
  if (value.split('').length != 8) {
    return 'Your password must be 8 characters long';
  } else {
    return null;
  }
}
