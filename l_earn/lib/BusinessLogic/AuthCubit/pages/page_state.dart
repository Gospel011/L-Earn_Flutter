// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'page_cubit.dart';

abstract class PageState {
  final int pageNo;

  const PageState({required this.pageNo});

  @override
  String toString() => 'PageState(pageNo: $pageNo)';
}

final class Page extends PageState {
  const Page({required super.pageNo});
}
