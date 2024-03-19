import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/DataLayer/Repositories/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState(status: ProfileStatus.initial));

  Future<void> getUserById(token, id) async {
    emit(const ProfileState(status: ProfileStatus.loadingUser));

    final response = await ProfileRepo.getUser(token, id);

    if (response is User) {
      emit(ProfileState(
          status: ProfileStatus.userLoaded, profileUser: response));
    } else {
      emit(ProfileState(
          status: ProfileStatus.loadingUserFailed, profileUser: state.profileUser, error: response));
    }
  }
}
