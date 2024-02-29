import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
//? filter parameters
//  'paymentStatus',
// 'dateCreated',
// 'invoiceRef'

class Filter {
  final String? paymentStatus;
  final String? dateCreated;
  final String? invoiceReference;
  Filter({
    this.paymentStatus,
    this.dateCreated,
    this.invoiceReference,
  });
  

  Filter copyWith({
    String? paymentStatus,
    String? dateCreated,
    String? invoiceReference,
  }) {
    return Filter(
      paymentStatus: paymentStatus == 'null' ? null : paymentStatus ?? this.paymentStatus,
      dateCreated: dateCreated == 'null' ? null : dateCreated ?? this.dateCreated,
      invoiceReference: invoiceReference == 'null' ? null : invoiceReference ?? this.invoiceReference,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paymentStatus': paymentStatus,
      'dateCreated': dateCreated,
      'invoiceReference': invoiceReference,
    };
  }

  factory Filter.fromMap(Map<String, dynamic> map) {
    return Filter(
      paymentStatus: map['paymentStatus'] != null ? map['paymentStatus'] as String : null,
      dateCreated: map['dateCreated'] != null ? map['dateCreated'] as String : null,
      invoiceReference: map['invoiceReference'] != null ? map['invoiceReference'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Filter.fromJson(String source) => Filter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Filter(paymentStatus: $paymentStatus, dateCreated: $dateCreated, invoiceReference: $invoiceReference)';

  
}
