import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:l_earn/utils/constants.dart';

class PostSource {
  static dynamic loadNewPosts(
      {required int page, required String token}) async {
    //? DEFINE THE HEADERS
    var headers = {'Authorization': 'Bearer $token'};

    //? SETUP THE REQUEST
    var request =
        http.Request('GET', Uri.parse('${NetWorkConstants.baseUrl}/posts'));

    //? ADD HEADERS
    request.headers.addAll(headers);

    //? RECIEVE RESPONSE
    try {
      http.StreamedResponse response = await request.send();

      return jsonDecode(await response.stream.bytesToString());
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
        print("U N K N O W N ERROR IS $e");
        return {
          "title": "Something went wrong",
          "message":
              "Please contact us with a description of what you were doing before you saw this message."
        };
      }
    }
  }
}
