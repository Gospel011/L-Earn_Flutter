//? APP THEME
import 'package:flutter/material.dart';
import 'package:l_earn/utils/colors.dart';

final class AppTheme {
//* MY APP THEME DATA
  static ThemeData myAppTheme = ThemeData(
      primaryColor: AppColor.maincolorBlue,

      //* My text themes
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
            color: AppColor.textColor,
            fontFamily: 'Nunito',
            fontSize: 16,
            height: 24 / 16,
            fontWeight: FontWeight.w400),
        bodyLarge: TextStyle(
            color: AppColor.textColor,
            fontFamily: 'Nunito',
            fontSize: 24,
            height: 24 / 24,
            fontWeight: FontWeight.w400),
      ),

      //*My list tile theme

      listTileTheme: const ListTileThemeData(
        titleAlignment: ListTileTitleAlignment.top,
        minVerticalPadding: 10,
      ),

      //* My button themes
      elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
              elevation: MaterialStatePropertyAll(1.0),
              backgroundColor:
                  MaterialStatePropertyAll(AppColor.mainColorBlack),
              minimumSize: MaterialStatePropertyAll(Size(double.maxFinite, 48)),
              textStyle: MaterialStatePropertyAll(TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  height: 24 / 16)))),
      textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
              overlayColor: MaterialStatePropertyAll(Colors.transparent),
              textStyle: MaterialStatePropertyAll(TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  height: 22.5 / 15)))),
      outlinedButtonTheme: const OutlinedButtonThemeData(
          style: ButtonStyle(
        fixedSize: MaterialStatePropertyAll(Size(double.maxFinite, 48)),
        side: MaterialStatePropertyAll(BorderSide(color: Colors.transparent)),
      )),

      //* Scaffold theme
      scaffoldBackgroundColor: Colors.white,

      //* My app bar theme
      appBarTheme: const AppBarTheme(
          elevation: 1,
          toolbarHeight: 54,
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          iconTheme:
              IconThemeData(size: 24, weight: 1, color: AppColor.textColor),
          titleTextStyle: TextStyle(
              color: AppColor.textColor,
              fontFamily: 'Nunito',
              fontSize: 17,
              fontWeight: FontWeight.w500,
              height: 27 / 17),
          centerTitle: true),

      //* Input slider theme
      sliderTheme: SliderThemeData(
          minThumbSeparation: 0,
          trackHeight: 0.2,
          activeTrackColor: AppColor.textColor,
          thumbColor: AppColor.textColor,
          overlayColor: AppColor.textColor.withOpacity(0.2),
          inactiveTrackColor: AppColor.textColor),
      useMaterial3: false,

      //* Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
          //* suffix icon style
          suffixIconColor: MyMainButtonColor(),
          hintStyle: const TextStyle(
              color: AppColor.textColor,
              fontFamily: 'Nunito',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 27 / 16),
          //* padding
          contentPadding: const EdgeInsets.only(left: 16, top: 10),
          //* for normal border
          border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColor.textfieldEnabledBoderColor),
              borderRadius: BorderRadius.circular(8)),
          //* for focused border
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColor.textfieldFocusedBoderColor),
              borderRadius: BorderRadius.circular(8)),

          //* for enabled border
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColor.textfieldEnabledBoderColor),
              borderRadius: BorderRadius.circular(8))));
}
