import 'package:l_earn/DataLayer/DataSources/post_source.dart';
import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Models/like_model.dart';
import 'package:l_earn/DataLayer/Models/poll_model.dart';
import 'package:l_earn/DataLayer/Models/post_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';

class PostRepo {
  static dynamic loadNewPosts(
      {required int page,
      required String userId,
      required String token}) async {
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

        var likesArray = postMap['likes'];
        postMap['likes'] = likesArray.length;
        postMap['liked'] = likesArray.contains(userId);

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

  static createNewPost(String token, Map<String, dynamic> post) async {
    final response = await PostSource.createPost(token, post);

    print("::; R E S P O N S E    I S    $response :::;");

    if (response['status'] == 'success') {
      try {
        return Post.fromMap(response['newPost']);
      } catch (e) {
        response['status'] = 'fail';
        response['message'] =
            'Some error occured, please contact us with a description of what you were doing before you saw this message';
        return AppError(title: 'Error', content: response['content']);
      }
    } else {
      return AppError(
          title: response["title"] ?? 'Error', content: response["message"]);
    }
  }

  static likePost(token, postId, resource) async {
    final response = await PostSource.likePost(token, postId, resource);

    print("S T A T U S     IS     ${response['status']}");

    if (response['status'] == 'success') {
      return Like.fromMap(response['likes']);
    } else {
      return AppError(title: 'Fail', content: response['message']);
    }
  }
}
