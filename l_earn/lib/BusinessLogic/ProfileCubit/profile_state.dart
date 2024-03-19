// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_cubit.dart';

enum ProfileStatus {
  initial,

  //?
  loadingUser,
  userLoaded,
  loadingUserFailed,
}

class ProfileState {
  final User? profileUser;
  final ProfileStatus status;
  final AppError? error;

  const ProfileState({this.profileUser, required this.status, this.error});

  @override
  String toString() => 'ProfileState(profileUser: $profileUser, status: $status, error: $error)';

  ProfileState copyWith({
    User? profileUser,
    ProfileStatus? status,
    AppError? error,
  }) {
    return ProfileState(
      profileUser: profileUser ?? this.profileUser,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
