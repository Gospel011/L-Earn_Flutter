//? APP COLOR

import 'package:flutter/material.dart';

class AppColor {
//* COLORS
  static const Color maincolorBlue = Color(0xFF30A2FF);
  static const Color mainColorBlack = Colors.black;
  static const buttonTextBlue = Color(0xFF2271B2);
  static const Color textColor = Color(0xFF555555);
  static const Color chatTextColorBlue = Color(0xFF093576);
  static const Color mainColorBlue2 = Color(0xFF2271B2);
  static const Color miscellenousColorRed = Color(0xFFF20C0C);
  static final Color dividerColor = Colors.black.withOpacity(0.2);
  static const dividerEnabledColor = Color(0xFFCCCCCC);
  static const dividerFocusedColor = Colors.black;
  static final Color textfieldFocusedBoderColor = Colors.black.withOpacity(0.5);
  static final Color textfieldEnabledBoderColor = Colors.black.withOpacity(0.3);
}

class MyMainButtonColor extends MaterialStateColor {
  static final int _defaultColor = Colors.black.withOpacity(0.6).value;
  final int _focusedColor = 0xFF000000;
  
  MyMainButtonColor(): super(_defaultColor);

  @override
  Color resolve(Set<MaterialState> states) {
    // TODO: implement resolve
    if (states.contains(MaterialState.focused)) {
      return Color(_focusedColor);
    } else {
      return Color(_defaultColor);
    }
  }
}
