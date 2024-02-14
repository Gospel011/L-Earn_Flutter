import 'package:bloc/bloc.dart';
import 'package:l_earn/DataLayer/Models/comment_model.dart';

import 'package:l_earn/DataLayer/Repositories/post_repo.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(CommentsInitial(page: 0, comments: []));

  int currentPage = 0;

  Future<void> getNewComments(id, token, userId) async {
    currentPage++;

    print("Page is $currentPage");

    List<Comment> comments = [...state.comments];

    emit(CommentsLoading(page: currentPage, comments: comments));

    final response = await PostRepo.loadComments(
        id: id, userId: userId, token: token, page: currentPage);

    print(":::::::::::::::::::::::::::::::::response $response");

    if (response is List<Comment>) {
      print("E M I T T I N G   N E W   S T A T E ${comments.length}");

      comments.addAll(response);

      print("E M I T T I N G   N E W   S T A T E ${comments.length}");
      emit(CommentsLoaded(
          page: comments.isEmpty ? currentPage - 1 : currentPage,
          comments: comments));

      if (state.comments.length < 20 && currentPage > 2) --currentPage;

      print('C U R R E N T   P A G E   I S   $currentPage');
    } else {
      currentPage--;
      // emit(CommentLoadingFailed(
      //     page: currentPage -1 ,
      //     comments: state.comments,
      //     error: response as AppError));
    }
  }

  Future<void> postComment(
      {required String userId,
      required String token,
      required String endpoint,
      required String comment}) async {
    List<Comment> comments = state.comments;
    emit(CommentPosting(comments: comments, page: state.page));

    final response = await PostRepo.postNewComment(userId, token, endpoint, comment);

    if (response is Comment) {
      comments.insert(0, response);
      print("RESPONSE IS $response");
      emit(CommentPosted(page: state.page, comments: comments));
    } else {
      print("RESPONSE IS $response");
      emit(CommentPostingFailed(page: state.page, comments: comments));
    }
  }
}
