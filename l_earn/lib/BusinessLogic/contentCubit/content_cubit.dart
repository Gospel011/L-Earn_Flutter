import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:l_earn/DataLayer/Models/article_model.dart';

import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Models/video_model.dart';
import 'package:l_earn/DataLayer/Repositories/content_repo.dart';

part 'content_state.dart';

class ContentCubit extends Cubit<ContentState> {
  ContentCubit() : super(const ContentInitial(contents: []));
  int currentPage = 0;

  Future<void> loadContents(token, {int? page}) async {
    currentPage++;
    if (page != null) currentPage = page;

    List<Content> contents = [...state.contents];

    emit(ContentLoading(contents: contents));

    final response = await ContentRepo.loadContents(token, currentPage);

    print("________CONTENT CUBIT RESOPONSE $response");

    if (response is List<Content>) {
      print("contents____________$contents");
      print("page______$currentPage");

      if (page == null) contents.addAll(response);

      emit(ContentLoaded(contents: page != null ? response : contents));
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

  Future<void> getChapterById(
      {required token,
      required chapterId,
      required contentId,
      required type}) async {
    emit(RequestingChapterById(
        contents: state.contents, content: state.content));

    print("T O K E N   I S   $token");

    final response = await ContentRepo.getChapterById(
        token: token, chapterId: chapterId, contentId: contentId, type: type);

    print(
        "R E S P O N S E   F R O M   C O N T E N T   C U B I T   I S   $response");

    if (response is Article) {
      print("::::: E M I T T I N G   S T A T E");
      emit(ChapterFound(
          contents: state.contents,
          content: state.content,
          type: type,
          article: response));
    } else if (response is Video) {
      emit(ChapterFound(
          contents: state.contents,
          content: state.content,
          type: type,
          video: response));
    }
  }
}
