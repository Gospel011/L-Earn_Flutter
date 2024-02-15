import 'package:bloc/bloc.dart';
import 'package:l_earn/DataLayer/Models/article_model.dart';

import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Models/video_model.dart';
import 'package:l_earn/DataLayer/Repositories/content_repo.dart';

part 'content_state.dart';

class ContentCubit extends Cubit<ContentState> {
  ContentCubit() : super(const ContentInitial(contents: []));
  int currentPage = 0;

  Future<void> loadContents(token) async {
    currentPage++;

    List<Content> contents = [...state.contents];

    emit(ContentLoading(contents: contents));

    final response = await ContentRepo.loadContents(token, currentPage);

    print("________CONTENT CUBIT RESOPONSE $response");

    if (response is List<Content>) {
      print("contents____________$contents");
      print("page______$currentPage");
      contents.addAll(response);
      emit(ContentLoaded(contents: contents));
      if (response.isEmpty) {
        currentPage--;
      }
    } else {
      currentPage--;
      emit(ContentLoadingFailed(
          contents: contents, error: response as AppError));
    }
  }

  Future<void> getContentById(token, id) async {
    emit(RequestingContentById(contents: state.contents));

    final response = await ContentRepo.getContentById(token, id);

    print("::: T A R G E T   C O N T E N T   IS   $response");

    if (response is Content) {
      
      emit(ContentFound(
          contents: state.contents,
          type: response is Article ? 'book' : 'video',
          content: response));

    } else {
      
      emit(ContentNotFound(
          contents: state.contents, error: response as AppError));
    }
  }
}
