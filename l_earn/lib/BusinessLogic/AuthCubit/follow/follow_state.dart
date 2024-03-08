// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'follow_cubit.dart';

class FollowState {
  final bool? followed;
  final AppError? error;

  const FollowState({this.followed, this.error});

  @override
  String toString() => 'FollowState(followed: $followed)';

  FollowState copyWith({
    bool? followed,
  }) {
    return FollowState(
      followed: followed ?? this.followed,
    );
  }
}

class FollowInitial extends FollowState {
  const FollowInitial();
}

/// state when a follow request is being processed by the server
class FollowingUser extends FollowState {
  FollowingUser({required super.followed});
}

/// state when a follow request has been proccessed
class UserFollowed extends FollowState {
  UserFollowed({required super.followed});
}

// state when a follow request failed
class FollowingUserFailed extends FollowState {
  FollowingUserFailed({required super.followed, required super.error});
}

/// state when a follow request is being processed by the server
class GettingFollowStatus extends FollowState {
  GettingFollowStatus({required super.followed});
}

/// state when a follow request has been proccessed
class FollowStatus extends FollowState {
  FollowStatus({required super.followed});
}

// state when a follow request failed
class GettingFollowStatusFailed extends FollowState {
  GettingFollowStatusFailed({required super.followed, required super.error});
}
