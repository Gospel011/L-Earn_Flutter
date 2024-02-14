import 'package:l_earn/DataLayer/DataSources/backend_source.dart';

class ContentRepo {
  static loadContents(String token, int page) async {
    final endpoint = 'contents?page=$page&sort=-dateCreated';
    final response = await BackendSource.makeGETRequest(token, endpoint);

    if (response['status'] == 'success')  {
      print("::::: r e s p o n s e   $response");

      
    }
  }
}
