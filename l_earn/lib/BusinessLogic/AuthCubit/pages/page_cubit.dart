import 'package:bloc/bloc.dart';

part 'page_state.dart';

class PageCubit extends Cubit<PageState> {
  PageCubit() : super(const Page(pageNo: 0));

  void goToPage(int pageNo) {
    emit(Page(pageNo: pageNo));
  }
}
