import 'package:l_earn/DataLayer/DataSources/post_source.dart';
import 'package:l_earn/DataLayer/Models/comment_model.dart';
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
        postMap['comments'] = postMap['comments'].length;

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

  static createNewPost(
      String userId, String token, Map<String, dynamic> post) async {
    final response = await PostSource.createPost(token, post);
    final newPost = response['post'];

    print("::; R E S P O N S E    I S    $response :::;");

    if (response['status'] == 'success') {
      newPost['user'] = newPost['userId'];
      newPost['userId'] = null;

      newPost['liked'] = newPost['likes'].contains(userId);
      newPost['likes'] = newPost['likes'].length;
      newPost['comments'] = newPost['comments'].length;

      print("UPDATED USER : $response");
      return Post.fromMap(response['post']);
    } else {
      return AppError.errorObject(response);
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

  static loadComments(
      {required id, required userId, required token, required int page}) async {
    final dynamic response = await PostSource.loadComments(
        id: id, userId: userId, token: token, page: page);

    List<Comment> comments = [];

    if (response['status'] == 'success') {
      for (int i = 0; i < response['comments'].length; i++) {
        Map<String, dynamic> comment = response['comments'][i];
        print("C O M M E N T   IS   $comment");
        print("L I K E S   IS   ${comment['likes']}");

        final List<dynamic> likesArray = comment['likes'] = comment['likes'];

        comment['likes'] = comment['likes'].length;
        comment['liked'] = likesArray.contains(userId);

        print("likes = ${comment['likes']}");

        print("$i.) ${Comment.fromMap(comment)}");

        comments.add(Comment.fromMap(comment));
      }

      return comments;
    } else {
      print(response);
      return AppError.errorObject(response);
    }
  }

  static postNewComment(
      String userId, String token, String endpoint, String comment) async {
    final response = await PostSource.makePostRequest(
        endpoint: endpoint, token: token, body: {"comment": comment});

    print('response $response');

    if (response['status'] == 'success') {
      final comment = response['newComment'];
      print("LIKES = $comment");
      final likesArray = comment['likes'];
      comment['likes'] = likesArray.length;
      comment['liked'] = likesArray.contains(userId);
      // comment['comments'] = comment['comments'].length
      return Comment.fromMap(comment);
    } else {
      return AppError.errorObject(response as AppError);
    }
  }
}
