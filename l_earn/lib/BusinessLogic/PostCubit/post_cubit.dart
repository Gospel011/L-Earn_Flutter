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
  PostCubit() : super(const NewPostsLoading(page: 0, newPosts: []));
  int currentPage = 0;

  Future<void> getNewPosts(userId, token, {int? page}) async {
    currentPage++;
    if(page != null) currentPage = page;

    List<Post> newPosts = [...state.newPosts];

    emit(NewPostsLoading(page: currentPage, newPosts: newPosts));

    print("::: R E Q U E S T I N G   F O R   P A G E   $currentPage");

    final response = await PostRepo.loadNewPosts(
        page: currentPage, userId: userId, token: token);

    if (response is List<Post>) {
      print(
          "E M I T T I N G   N E W   S T A T E ${newPosts.length}, RESPONSE LENGTH: ${response.length}");

      if ( page == null ) newPosts.addAll(response);

      print("E M I T T I N G   N E W   S T A T E ${newPosts.length}");
      emit(NewPostsLoaded(page: currentPage, newPosts: page != null ? response : newPosts));

      if (response.isEmpty) {
        print("decreasing page count to ${currentPage - 1}");
        currentPage--;
      }

      print(
          'C U R R E N T   P A G E   I S   $currentPage, response is Empty: ${response.isEmpty}, currentPage == state.page! + 1: ${currentPage == state.page! + 1}, state.page: ${state.page}');
    } else {
      currentPage--;
      emit(NewPostsFailed(
          page: currentPage - 1,
          newPosts: newPosts,
          error: response as AppError));
    }
  }

  Future<void> createNewPosts(
      String userId, String token, Map<String, dynamic> post) async {
    final List<Post> newPosts = state.newPosts;

    emit(CreatingNewPost(newPosts: newPosts));

    final response = await PostRepo.createNewPost(userId, token, post);

    if (response is Post) {
      print("E M I T T I N G   N E W   S T A T E");
      // newPosts.add(response);
      newPosts.insert(0, response);
      emit(NewPostCreated(newPosts: newPosts));
    } else {
      print("Emitting Failed");
      emit(NewPostsFailed(newPosts: newPosts, error: response as AppError));
    }
  }

  void emitNewPostsFailed({required String title, required String content}) {
    emit(NewPostsFailed(
        newPosts: state.newPosts,
        error: AppError(title: title, content: content)));
  }
}
