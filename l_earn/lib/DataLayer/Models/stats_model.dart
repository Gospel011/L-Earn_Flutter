// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:l_earn/DataLayer/Models/content_model.dart';

class SalesStats {
  final String id;
  final int sales;
  final Content content;
  final double profit;
  SalesStats({
    required this.id,
    required this.sales,
    required this.content,
    required this.profit,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'sales': sales,
      'content': content.toMap(),
      'profit': profit,
    };
  }

  factory SalesStats.fromMap(Map<String, dynamic> map) {
    return SalesStats(
      id: map['_id'] as String,
      sales: map['sales'] as int,
      content: Content.fromMap(map['content'] as Map<String,dynamic>),
      profit: double.parse(map['profit'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory SalesStats.fromJson(String source) => SalesStats.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TutorStat(id: $id, sales: $sales, content: $content, profit: $profit)';
  }

  SalesStats copyWith({
    String? id,
    int? sales,
    Content? content,
    double? profit,
  }) {
    return SalesStats(
      id: id ?? this.id,
      sales: sales ?? this.sales,
      content: content ?? this.content,
      profit: profit ?? this.profit,
    );
  }
}



