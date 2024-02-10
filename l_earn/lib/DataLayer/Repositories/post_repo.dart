import 'package:l_earn/DataLayer/DataSources/post_source.dart';
import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Models/poll_model.dart';
import 'package:l_earn/DataLayer/Models/post_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';

class PostRepo {
  static dynamic loadNewPosts(
      {required int page, required String token}) async {
    final response = await PostSource.loadNewPosts(page: page, token: token);
    print(response);

    if (response['status'] == 'success') {
      //* convert list of post maps to actual objects;
      List<dynamic> postList = response['posts'];
      List<Post> posts = [];

      print(':::::::::::::::::::::');

      for (int i = 0; i < postList.length; i++) {
        Map<String, dynamic> postMap = postList[i];
        var user = postMap['userId'];
        postMap['user'] = user;
        postMap['userId'] = null;

        print("PostMap = $postMap");

        posts.add(Post.fromMap(postMap));

        print("POSTS = $posts");

      }
        return posts;
    } else {
      return AppError(
          title: response["title"] ?? 'Error', content: response["message"]);
    }
  }
}
