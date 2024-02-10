import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// "option": "Tmothy Eberechukwu",
// "votes": 0,
//! "voters": [],
// "_id": "65c66a76bb1264b2e80167f5"

class Poll {
  final String option;
  final int votes;
  final String id;

  const Poll(
      {required this.option,
      required this.votes,
      required this.id});

  Poll copyWith({
    String? option,
    int? votes,
  }) {
    return Poll(
      option: this.option,
      votes: votes ?? this.votes,
      id: id
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'option': option,
      'votes': votes,
      '_id': id,
    };
  }

  factory Poll.fromMap(Map<String, dynamic> map) {
    return Poll(
      option: map['option'] as String,
      votes: map['votes'] as int,
      id: map['_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Poll.fromJson(String source) => Poll.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Poll(option: $option, votes: $votes, id: $id)';
}
