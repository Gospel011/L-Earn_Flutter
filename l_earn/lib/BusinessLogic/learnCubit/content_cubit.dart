import 'package:bloc/bloc.dart';

import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Repositories/content_repo.dart';

part 'content_state.dart';

class ContentCubit extends Cubit<ContentState> {
  ContentCubit() : super(const ContentInitial(contents: []));
  int currentPage = 0;

  Future<void> loadContents(token) async {
    
    currentPage++;

    final List<Content> contents = state.contents;

    emit(ContentLoading(contents: contents));

    final response = await ContentRepo.loadContents(token, currentPage);

    if (response.isEmpty) {
      currentPage--;
    }

    if (response is List<Content>) {
      emit(ContentLoaded(contents: contents));
    } else {
      emit(ContentLoadingFailed(
          contents: contents, error: response as AppError));
    }
  }
}
