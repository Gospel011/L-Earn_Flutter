import 'package:l_earn/DataLayer/DataSources/backend_source.dart';
import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Models/invoice_model.dart';

class PaymentRepo {
  static generateInvoice(token, String contentId) async {
    final endpoint = 'payment/$contentId';

    final response = await BackendSource.makeRequest(
        endpoint: endpoint, token: token, body: {});

    print(
        "G E N E R A T I N G   I N V O I C E   R E S P O N S E   IS   $response");

    if (response['status'] == 'success') {
      print(
          'G E N E R A T E D   I N V O I C E   I S   ${Invoice.fromMap(response['response'])}');
      return Invoice.fromMap(response['response']);
    } else {
      return AppError.errorObject(response);
    }
  }

  static loadPaymentHistory(token, Map<String, dynamic>? filters) async {
    //? filter parameters
    //  'paymentStatus',
    // 'dateCreated',
    // 'invoiceRef'

    String invoiceRef = filters?['invoiceRef'] != null
        ? 'invoiceRef=${filters!['invoiceRef']}'
        : '';
    String paymentStatus = filters?['paymentStatus'] != null
        ? '&paymentStatus=${filters!['paymentStatus']}'
        : '';
    String dateCreated = filters?['dateCreated'] != null
        ? '&sort=${filters!['dateCreated']}'
        : '';

    final endpoint =
        'payment/transactionHistory?$invoiceRef$paymentStatus$dateCreated';

    final response = await BackendSource.makeRequest(
        endpoint: endpoint, method: 'GET', token: token, body: {});

    print(
        "L O A D I N G   P A Y M E N T   H I S T O R Y   R E S P O N S E   IS   $response");

    if (response['status'] == 'success') {
      List<Invoice> invoices = [];

      for (int i = 0; i < response['transactionHistory'].length; i++) {
        final invoiceMap = response['transactionHistory'][i];
        invoiceMap['amount'] = invoiceMap['amountPayable'];
        invoiceMap['invoiceReference'] = invoiceMap['invoiceRef'];
        invoiceMap['invoiceStatus'] = invoiceMap['paymentStatus'];
        invoiceMap['description'] = invoiceMap['paymentDescription'];
        invoiceMap['customerEmail'] = invoiceMap['userId']['email'];
        invoiceMap['customerName'] = '${invoiceMap['userId']['firstName']} ${invoiceMap['userId']['lastName']}';
        invoiceMap['createdOn'] = invoiceMap['dateCreated'];
        invoiceMap['contentThumbnailUrl'] = invoiceMap['contentId']['thumbnailUrl'];
        invoiceMap['contentTitle'] = invoiceMap['contentId']['title'];

        invoices.add(Invoice.fromMap(invoiceMap));
      }
      print('::: Invoices Are ::: $invoices');

      return invoices;
    } else {
      return AppError.errorObject(response);
    }
  }
}
