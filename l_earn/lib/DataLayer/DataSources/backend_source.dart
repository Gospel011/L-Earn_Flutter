import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Models/file_model.dart';
import 'package:l_earn/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BackendSource {
  static makeRequest({
    required String endpoint,
    required String token,
    String method = 'POST',
    required Map<String, String> body,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(method.toUpperCase(),
        Uri.parse('${NetWorkConstants.baseUrl}/$endpoint'));
    request.body = json.encode(body);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      String responseStr = await response.stream.bytesToString();

      print("R E S P O N S E S T R   $responseStr");

      return jsonDecode(responseStr);
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
      return AppError.handleError(e);
    }
  }

  static makeMultiPartRequest(String token, String endpoint,
      {required String method,
      required Map<String, String> body,
      File? file,
      List<File>? files}) async {
    //? SETUP REQUEST HEADER
    var headers = {'Authorization': 'Bearer $token'};

    //? SETUP URL
    final Uri url = Uri.parse('${NetWorkConstants.baseUrl}/$endpoint');

    //? INITIALIZE MULTI-PART REQUEST
    var request = http.MultipartRequest(method.toUpperCase(), url);

    //? ADD REQUEST BODY
    request.fields.addAll(body);

    //? ADD ANY FILES
    try {
      if (file != null) {
        request.files
            .add(await http.MultipartFile.fromPath(file.name, file.path));
      } else if (files != null && files.isNotEmpty) {
        for (int i = 0; i < files.length; i++) {
          request.files.add(
              await http.MultipartFile.fromPath(files[i].name, files[i].path));
        }
      }

      print("::: R E Q U E S T   F I L E S   ${request.files} :::");
    } catch (e) {
      print(e);
    }

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      return jsonDecode(await response.stream.bytesToString());
    } catch (e) {
      return AppError.handleError(e);
    }
  }
}
