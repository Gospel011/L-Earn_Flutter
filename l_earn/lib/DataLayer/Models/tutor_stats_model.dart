import 'package:l_earn/DataLayer/Models/stats_model.dart';
import 'dart:convert';

class TutorSalesStats {
  final List<SalesStats> stats;
  final int totalSales;
  final double totalProfit;
  final double totalRevenue;

  const TutorSalesStats({
    required this.stats,
    required this.totalSales,
    required this.totalProfit,
    required this.totalRevenue
    });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stats': stats.map((x) => x.toMap()).toList(),
      'totalSales': totalSales,
      'totalProfit': totalProfit,
      'totalRevenue': totalRevenue,
    };
  }

  factory TutorSalesStats.fromMap(Map<String, dynamic> map) {
    return TutorSalesStats(
      stats: map['stats'] as List<SalesStats>,
      totalSales: map['totalSales'] as int,
      totalProfit: map['totalProfit'] as double,
      totalRevenue: map['totalRevenue'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory TutorSalesStats.fromJson(String source) => TutorSalesStats.fromMap(json.decode(source) as Map<String, dynamic>);

  TutorSalesStats copyWith({
    List<SalesStats>? stats,
    int? totalSales,
    double? totalProfit,
    double? totalRevenue,
  }) {
    return TutorSalesStats(
      stats: stats ?? this.stats,
      totalSales: totalSales ?? this.totalSales,
      totalProfit: totalProfit ?? this.totalProfit,
      totalRevenue: totalRevenue ?? this.totalRevenue,
    );
  }

  @override
  String toString() {
    return 'TutorSalesStats(stats: $stats, totalSales: $totalSales, totalProfit: $totalProfit, totalRevenue: $totalRevenue)';
  }
}