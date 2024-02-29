import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Invoice {
  final int amount;
  final int? amountPaid;
  final String invoiceReference;
  final String invoiceStatus;
  final String description;
  final String customerEmail;
  final String cutomerName;
  final String? expiryDate;
  final String createdOn;
  final String? checkoutUrl;
  final String? contentThumbnailUrl;
  final String? contentTitle;
  final String accountNumber;
  final String accountName;
  final String bankName;
  final String? transactionReference;
  final String dateCreated;

  Invoice({
    required this.amount,
    this.amountPaid,
    required this.invoiceReference,
    required this.invoiceStatus,
    required this.description,
    required this.customerEmail,
    required this.cutomerName,
    this.expiryDate,
    required this.createdOn,
    this.checkoutUrl,
    this.contentThumbnailUrl,
    this.contentTitle,
    required this.accountNumber,
    required this.accountName,
    required this.bankName,
    this.transactionReference,
    required this.dateCreated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'amountPaid': amountPaid,
      'invoiceReference': invoiceReference,
      'invoiceStatus': invoiceStatus,
      'description': description,
      'customerEmail': customerEmail,
      'cutomerName': cutomerName,
      'expiryDate': expiryDate,
      'createdOn': createdOn,
      'checkoutUrl': checkoutUrl,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'bankName': bankName,
      'contentThumbnailUrl': contentThumbnailUrl,
      'contentTitle': contentTitle,
      '_id': transactionReference,
      'dateCreated': dateCreated,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      amount: map['amount'] as int,
      amountPaid: map['amountPaid'] != null ? map['amountPaid'] as int : null,
      invoiceReference: map['invoiceReference'] as String,
      invoiceStatus: map['invoiceStatus'] as String,
      description: map['description'] as String,
      customerEmail: map['customerEmail'] as String,
      cutomerName: map['customerName'] as String,
      expiryDate:
          map['expiryDate'] != null ? map['expiryDate'] as String : null,
      createdOn: map['createdOn'] as String,
      checkoutUrl:
          map['checkoutUrl'] != null ? map['checkoutUrl'] as String : null,
      contentThumbnailUrl: map['contentThumbnailUrl'] != null
          ? map['contentThumbnailUrl'] as String
          : null,
      contentTitle:
          map['contentTitle'] != null ? map['contentTitle'] as String : null,
      accountNumber: map['accountNumber'] as String,
      accountName: map['accountName'] as String,
      bankName: map['bankName'] as String,
      transactionReference: map['_id'] != null ? map['_id'] as String : null,
      dateCreated: map['dateCreated'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Invoice.fromJson(String source) =>
      Invoice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Invoice(amount: $amount, amountPaid: $amountPaid, invoiceReference: $invoiceReference, invoiceStatus: $invoiceStatus, description: $description, customerEmail: $customerEmail, cutomerName: $cutomerName, expiryDate: $expiryDate, createdOn: $createdOn, checkoutUrl: $checkoutUrl, contentThumbnailUrl: $contentThumbnailUrl, contentTitle: $contentTitle, accountNumber: $accountNumber, accountName: $accountName, bankName: $bankName, transactionReference: $transactionReference, dateCreated: $dateCreated)';
  }
}
