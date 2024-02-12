import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:l_earn/DataLayer/DataSources/post_source.dart';
import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Models/post_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/DataLayer/Repositories/auth_repo.dart';
import 'package:l_earn/DataLayer/Repositories/post_repo.dart';
import 'package:l_earn/Helpers/auth_helper.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(const NewPostsLoading(page: 1));

  Future<void> getNewPosts( userId, token ) async {
    int currentPage = state.page ?? 1;
    final List<Post> newPosts = state.newPosts ?? [];

    emit(NewPostsLoading(page: currentPage));

    final response =
        await PostRepo.loadNewPosts(page: ++currentPage, userId: userId, token: token);

    if (response is List<Post>) {
      print("E M I T T I N G   N E W   S T A T E");
      emit(NewPostsLoaded(page: currentPage, newPosts: response));
    } else {
      emit(NewPostsFailed(
          page: --currentPage,
          newPosts: newPosts,
          error: response as AppError));
    }
  }

  Future<void> createNewPosts(String token, Map<String, dynamic> post) async {
    final List<Post> newPosts = state.newPosts ?? [];

    emit(CreatingNewPost(newPosts: newPosts));

    final response = await PostRepo.createNewPost(token, post);

    if (response is Post) {
      print("E M I T T I N G   N E W   S T A T E");
      newPosts.add(response);
      emit(NewPostCreated(newPosts: newPosts));

    } else {
      emit(NewPostsFailed(
          newPosts: newPosts,
          error: response as AppError));
    }
  }
}
