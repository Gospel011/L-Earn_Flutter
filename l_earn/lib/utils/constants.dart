

// import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//! NETWORK CONSTANTS
class NetWorkConstants {
  static const String baseUrl =
      "https://l-earn.onrender.com/api/v1"; //? [PRODUCTION]
  // static const String baseUrl = "http://127.0.0.1:5000/api/v1"; //? [DEVELOPMENT]
  static final Map<String, String> defaultHeader = {
    "Content-Type": "application/json"
  };
}

// final random = Random();

//*CURSOR WIDTH
const double cursorWidth = 1.0;

final class AppIcons {
  static final homeThin = SvgPicture.asset('assets/svg_icons/home-thin.svg');
  static final homeFill = SvgPicture.asset('assets/svg_icons/home-fill.svg');
  static final bookFill = SvgPicture.asset('assets/svg_icons/book-filled.svg');
  static final community = SvgPicture.asset('assets/svg_icons/community.svg');
  static final eventsFill = SvgPicture.asset('assets/svg_icons/events-fill.svg');
  static final eventsThin = SvgPicture.asset('assets/svg_icons/events-thin_v2.svg');
  static final eventsThin2 = SvgPicture.asset('assets/svg_icons/events-thin.svg');
  static final googleIcon = SvgPicture.asset('assets/svg_icons/google_icon.svg');
  static final learnThin = SvgPicture.asset('assets/svg_icons/learn-thin_v2.svg');
  static final learnThin2 = SvgPicture.asset('assets/svg_icons/learn-thin.svg');
  static final learnFill = SvgPicture.asset('assets/svg_icons/learn-fill.svg');
  static final post = SvgPicture.asset('assets/svg_icons/post.svg');
  static final searchThin = SvgPicture.asset('assets/svg_icons/search-thin.svg');
  static final verifiedIcon = SvgPicture.asset('assets/svg_icons/verified_icon.svg');
  static final write = SvgPicture.asset('assets/svg_icons/write.svg');
}
