// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'tab_cubit.dart';

abstract class TabState {
  final int index;
  TabState({
    required this.index,
  });
  
}

final class CurrentTabState extends TabState {
  CurrentTabState({required super.index});
}
