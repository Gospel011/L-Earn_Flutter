import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';


//! NETWORK CONSTANTS
class NetWorkConstants {
  static const String baseUrl = "https://l-earn.onrender.com/api/v1"; //? [PRODUCTION]
  // static const String baseUrl = "http://127.0.0.1:5000/api/v1"; //? [DEVELOPMENT]
  static final Map<String, String> defaultHeader = {
    "Content-Type": "application/json"
  };
}

// final random = Random();

//* IMAGES
final Image googleImage =
    Image.asset('assets/logos/google_logo.png', width: 24, height: 24);

//*CURSOR WIDTH
const double cursorWidth = 1.0;
