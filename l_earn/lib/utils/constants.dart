import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';


//! NETWORK CONSTANTS
class NetWorkConstants {
  final String baseUrl = "http://127.0.0.1:5000/api/v1";
  final Map<String, String> defaultHeader = {
    "Content-Type": "application/json"
  };
}

// final random = Random();

//* IMAGES
final Image googleImage =
    Image.asset('assets/logos/google_logo.png', width: 24, height: 24);

//*CURSOR WIDTH
const double cursorWidth = 1.0;
