import 'package:l_earn/DataLayer/DataSources/backend_source.dart';
import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';

class ProfileRepo {
  static getUser(token, id) async {
    final endpoint = 'user/$id';

    final response = await BackendSource.makeGETRequest(token, endpoint);

    if (response["status"] == 'success') {
      Map<String, dynamic> userMap = response["user"];
      userMap["token"] = response["token"];
      return User.fromMap(userMap);
    } else {
      return AppError(
          title: response["title"] ?? 'An Error Occured',
          content: response["message"]);
    }
  }
}
