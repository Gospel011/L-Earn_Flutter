// ignore_for_file: public_member_api_docs, sort_constructors_first


part of 'drafts_cubit.dart';

class DraftsState {
  final List<Drafts> drafts;
  DraftsState({
    required this.drafts,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'drafts': drafts?.map((x) => x.toMap()).toList(),
    };
  }

  factory DraftsState.fromMap(Map<String, dynamic> map) {
    return DraftsState(
      drafts: map['drafts'] != null ? List<Drafts>.from((map['drafts'] as List<int>).map<Drafts?>((x) => Drafts.fromMap(x as Map<String,dynamic>),),) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory DraftsState.fromJson(String source) => DraftsState.fromMap(json.decode(source) as Map<String, dynamic>);
}



class DraftsInitial extends DraftsState {
  DraftsInitial({required super.drafts});
}

class SavedToDrafs extends DraftsState {
  SavedToDrafs({required super.drafts});
}

class DeletedFromDrafts extends DraftsState {
  DeletedFromDrafts({required super.drafts});
}
