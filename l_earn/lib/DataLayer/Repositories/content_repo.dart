import 'package:l_earn/DataLayer/DataSources/backend_source.dart';
import 'package:l_earn/DataLayer/Models/article_model.dart';
import 'package:l_earn/DataLayer/Models/file_model.dart';
import 'package:l_earn/DataLayer/Models/video_model.dart';

import '../Models/content_model.dart';
import '../Models/error_model.dart';

class ContentRepo {
  static loadContents(String token, int page,
      {String? type, String? userId}) async {
    final endpoint =
        'contents${userId != null ? '/info/user-contents' : ''}?page=$page&sort=-dateCreated${type != null ? '&type=$type' : ''}${userId != null ? '&id=$userId' : ''}';

    print("::: R E Q U E S T   E N D P O I N T   $endpoint");
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

  static getContentById(token, contentId) async {
    final endpoint = 'contents/$contentId';

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

  static getChapterById(
      {required token,
      required contentId,
      required chapterId,
      required type}) async {
    final endpoint = 'contents/$contentId/chapters/$chapterId?type=$type';
    final response = await BackendSource.makeGETRequest(token, endpoint);

    print('R E S P O N S E   F R O M   S O U R C E  IS  $response');

    if (response['status'] == 'success') {
      if (type == 'book') {
        final Article article = Article.fromMap(response['chapter']);

        return article;
      } else {
        return Video.fromMap(response['chapter']);
      }
    } else {
      return AppError.errorObject(response);
    }
  }

  /// This method communicates with the backend to  create a new book on the
  /// server. The [details] parameter should be a Map and have a file field
  /// named [file] that contains the thumbnail for the book.
  static initializeBook(token, Map<String, dynamic> details) async {
    const String endpoint = 'contents?type=book';
    final File file = details['file'];
    details.remove('file');

    final Map<String, String> body = Map<String, String>.from(details.map((key, value) => MapEntry(key, value.toString())));

    print("B O D Y   $body, $file");
    // return;

    final response = await BackendSource.makeMultiPartPUTRequest(
        token, endpoint,
        body: body, file: file);

    print(
        ":::::::; R E S O N S E   F R O M   B A C K E N D S O U R C E   I S   $response");

    if (response['status'] == 'success') {
      return 'success';
    } else {
      return AppError.errorObject(response);
    }
  }
}
