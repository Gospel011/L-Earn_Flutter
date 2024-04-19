import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:l_earn/DataLayer/Models/drafts_model.dart';
import 'dart:convert';

part 'drafts_state.dart';

class DraftsCubit extends HydratedCubit<DraftsState> {
  DraftsCubit() : super(DraftsInitial(drafts: []));

  void put(Drafts oldDraft, Drafts newDraft) {
    List<Drafts> drafts = state.drafts;

    int? index = drafts.indexOf(oldDraft);

    if (index >= 0) {
      drafts[index] = newDraft;
    } else {
      drafts.add(newDraft);
    }
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
