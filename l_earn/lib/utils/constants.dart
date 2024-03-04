

// import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//! NETWORK CONSTANTS
class NetWorkConstants {
  // static const String baseUrl =
  //     "https://l-earn.onrender.com/api/v1"; //? [PRODUCTION]
  // static const String baseUrl =
  //     "https://learn-27c8.onrender.com/api/v1"; //? [PRODUCTION2]
  // static const String baseUrl = "http://127.0.0.1:5000/api/v1"; //? [DEVELOPMENT -> laptop]
  static const String baseUrl = "https://d0b0-2c0f-2a80-7d-f210-dc66-b011-1216-226e.ngrok-free.app/api/v1"; //? [DEVELOPMENT -> phone]
  static final Map<String, String> defaultHeader = {
    "Content-Type": "application/json"
  };
}

// final random = Random();

//*CURSOR WIDTH
const double cursorWidth = 1.0;

final class AppIcons {
  static final arrowDown = SvgPicture.asset('assets/svg_icons/arrow_down-thin.svg');
  static final book = SvgPicture.asset('assets/svg_icons/book_icon.svg');
  static final appLogo = SvgPicture.asset('assets/svg_icons/app_logo.svg');
  static final close = SvgPicture.asset('assets/svg_icons/light_close.svg');
  static final starOutline = SvgPicture.asset('assets/svg_icons/star_outline.svg');
  static final starSolid = SvgPicture.asset('assets/svg_icons/star_solid.svg');
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
  static final share = SvgPicture.asset('assets/svg_icons/share_icon.svg');
  static final comment = SvgPicture.asset('assets/svg_icons/comment_icon.svg',);
  static final liked = SvgPicture.asset('assets/svg_icons/liked.svg');
  static final likeCompact = SvgPicture.asset('assets/svg_icons/compact_like.svg');
  static final likeSolidCompact = SvgPicture.asset('assets/svg_icons/solid_compact_like.svg');
  static final likeDefault = SvgPicture.asset('assets/svg_icons/like-default.svg');
  static final verifiedIcon = SvgPicture.asset('assets/svg_icons/verified_icon.svg');
  static final write32 = SvgPicture.asset('assets/svg_icons/write.svg', width: 32, height: 32,);
  static final write = SvgPicture.asset('assets/svg_icons/write.svg');
}
