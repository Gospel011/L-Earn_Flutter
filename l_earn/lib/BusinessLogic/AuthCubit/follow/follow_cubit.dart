import 'package:bloc/bloc.dart';
import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Repositories/auth_repo.dart';
import 'package:l_earn/utils/enums.dart';

part 'follow_state.dart';

class FollowCubit extends Cubit<FollowState> {
  FollowCubit() : super(const FollowInitial());

  Future<void> followUser(token, String userId) async {
    final bool followState = !state.followed!;

    emit(GettingFollowStatus(followed: followState));
    emit(UserFollowed(followed: followState));

    final response = await AuthRepo.followUser(token, userId);

    if (response is bool) {
      // emit(UserFollowed(followed: response));
    } else {
      emit(FollowingUserFailed(
          followed: state.followed, error: response as AppError));
    }
  }

  Future<void> getFollowStatus(token, String userId) async {
    emit(GettingFollowStatus(followed: false));

    final response = await AuthRepo.getFollowStatus(token, userId);

    if (response is bool) {
      emit(FollowStatus(followed: response));
    } else {
      emit(GettingFollowStatusFailed(
          followed: false, error: response as AppError));
    }
  }
}
