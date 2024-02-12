import 'package:bloc/bloc.dart';
import 'package:l_earn/DataLayer/DataSources/post_source.dart';

import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Models/like_model.dart';
import 'package:l_earn/DataLayer/Repositories/post_repo.dart';

part 'like_state.dart';

class LikeCubit extends Cubit<LikeState> {
  LikeCubit(int likes, bool liked)
      : super(LikeInitial(likes: likes, liked: liked));

  Future<void> like(token, postId, resource) async {
    print("E M I T T I N G   L I K I N G");

    emit(Liking(
        likes: state.liked ? state.likes - 1 : state.likes + 1,
        liked: !state.liked));

    final response = await PostRepo.likePost(token, postId, resource);

    if (response is Like) {
      emit(Liked(likes: response.likes, liked: response.liked));
    } else {
      emit(LikingFailed(
          likes: state.liked ? state.likes - 1 : state.likes + 1,
          liked: !state.liked));
    }
  }
}
