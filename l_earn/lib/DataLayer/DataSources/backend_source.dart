import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BackendSource {
  static makePostRequest({
    required String endpoint,
    required String token,
    required Map<String, String> body,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'POST', Uri.parse('${NetWorkConstants.baseUrl}/$endpoint'));
    request.body = json.encode({"comment": body['comment']});
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

  static makeGETRequest(String token, String endpoint) async {
    var headers = {'Authorization': 'Bearer $token'};

    final Uri url = Uri.parse('${NetWorkConstants.baseUrl}/$endpoint');

    var request = http.Request('GET', url);

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      return jsonDecode(await response.stream.bytesToString());
    } catch (e) {
      AppError.handleError(e);
    }
  }


  
}
