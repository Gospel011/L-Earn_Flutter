import 'package:l_earn/DataLayer/DataSources/backend_source.dart';

import '../Models/content_model.dart';
import '../Models/error_model.dart';

class ContentRepo {
  static loadContents(String token, int page) async {
    final endpoint = 'contents?page=$page&sort=-dateCreated';
    final response = await BackendSource.makeGETRequest(token, endpoint);

    if (response['status'] == 'success') {
      print("::::: r e s p o n s e   $response");

      final contentMaps = response['contents'];
      List<Content> contents = [];

      for (int i = 0; i < contentMaps.length; i++) {
        contentMaps[i]['articles'] = contentMaps[i]['articles'].length;
        contentMaps[i]['videos'] = contentMaps[i]['videos'].length;
        contentMaps[i]['students'] = contentMaps[i]['students'].length;

        final Content content = Content.fromMap(contentMaps[i]);

        contents.add(content);
      }

      print('______ C O N T E N T   M A P S  = $contents');
      return contents;
    } else {
      return AppError.errorObject(response);
    }
  }

  static getContentById(token, id) async {
    final endpoint = 'contents/$id';
    final response = await BackendSource.makeGETRequest(token, endpoint);

    print(" C O N T E N T   R E S P O N S E   I S   $response");

    if (response['status'] == 'success') {
      final contentMap = response['content'];

      final List<dynamic> videosList = contentMap['videos'];
      final List<dynamic> articlesList = contentMap['articles'];

      contentMap['articles'] = articlesList.length;
      contentMap['videos'] = videosList.length;
      contentMap['students'] = contentMap['students'].length;

      contentMap['videoChapters'] = videosList;
      contentMap['bookChapters'] = articlesList;

      final Content content = Content.fromMap(contentMap);

      return content;
    } else {
      return AppError.errorObject(response);
    }
  }
}
