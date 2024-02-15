import 'package:bloc/bloc.dart';

part 'tab_state.dart';

class TabCubit extends Cubit<TabState> {
  TabCubit() : super(CurrentTabState(index: 0));

  void setTabIndex(index) {
    emit(CurrentTabState(index: index));
  }
}
