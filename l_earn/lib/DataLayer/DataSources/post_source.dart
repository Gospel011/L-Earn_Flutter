import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:l_earn/DataLayer/Models/error_model.dart';
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
      return AppError.handleError(e);
    }
  }

  static createPost(String token, Map<String, dynamic> post) async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest('PUT',
        Uri.parse('${NetWorkConstants.baseUrl}/posts?addon=${post['addon']}'));
    request.fields.addAll({'text': post['text']});

    if (post['poll'] != null) {
      request.fields.addAll({'poll': post['poll']});
    }

    if (post['image'] != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', post['image']));
    }
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      return jsonDecode(await response.stream.bytesToString());
    } catch (e) {
      // TODO
      print(":::::::: e is $e");
      return AppError.handleError(e);
    }
  }



  //? HANDLES THE NETWORK REQUEST REGARDING LIKING AND UNLIKING A POST
  static likePost(String token, String resourceId, String resource) async {
    NetWorkConstants.defaultHeader.addAll({'Authorization': 'Bearer $token'});

    var request = http.MultipartRequest(
        'POST', Uri.parse('${NetWorkConstants.baseUrl}/$resource/$resourceId/like'));

    request.headers.addAll(NetWorkConstants.defaultHeader);

    try {
      http.StreamedResponse response = await request.send();

      
      return jsonDecode(await response.stream.bytesToString());
    } catch (e) {
      return AppError.handleError(e);
    }
  }
}
