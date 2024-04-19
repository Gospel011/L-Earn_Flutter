import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:l_earn/DataLayer/Models/drafts_model.dart';
import 'dart:convert';

part 'drafts_state.dart';

class DraftsCubit extends HydratedCubit<DraftsState> {
  DraftsCubit() : super(DraftsInitial(drafts: []));

  /// This method takes a draft object and inserts it into the drafts list.
  /// If the draft exist, it replaces the old draft with the one provided.
  void put(Drafts draft) {
    List<Drafts> drafts = state.drafts;

    int? index = drafts.indexOf(draft);

    if (index >= 0) {
      drafts[index] = draft;
    } else {
      drafts.add(draft);
    }
  }

  void clearAll() {
    state.drafts.clear();
  }

  @override
  DraftsState? fromJson(Map<String, dynamic> json) {
    return DraftsState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(DraftsState state) {
    return state.toMap();
  }
}
