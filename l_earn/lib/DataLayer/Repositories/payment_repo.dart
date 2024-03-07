import 'package:l_earn/DataLayer/DataSources/backend_source.dart';
import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Models/invoice_model.dart';
import 'package:l_earn/DataLayer/Models/stats_model.dart';
import 'package:l_earn/DataLayer/Models/tutor_stats_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';

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
        invoiceMap['customerName'] =
            '${invoiceMap['userId']['firstName']} ${invoiceMap['userId']['lastName']}';
        invoiceMap['createdOn'] = invoiceMap['dateCreated'];
        invoiceMap['contentThumbnailUrl'] =
            invoiceMap['contentId']['thumbnailUrl'];
        invoiceMap['contentTitle'] = invoiceMap['contentId']['title'];

        invoices.add(Invoice.fromMap(invoiceMap));
      }
      print('::: Invoices Are ::: $invoices');

      return invoices;
    } else {
      return AppError.errorObject(response);
    }
  }

  static loadTutorStats(User user) async {
    final endpoint = 'payment';

    final response = await BackendSource.makeGETRequest(user.token!, endpoint);

    print("Response ::: $response");

    if (response['status'] == 'success') {
      List<SalesStats> stats = [];
      int totalSales = 0;
      double totalProfit = 0;
      double totalRevenue = 0;

      List aggregatedPayments = response['aggregatedPayments'];

      for (int i = 0; i < aggregatedPayments.length; i++) {
        var stat = aggregatedPayments[i];
        var content = stat['content'];

        totalSales += stat['sales'] as int;
        totalProfit += double.parse(stat['profit'].toString());
        totalRevenue += double.parse(content['price'].toString());

        content['articles'] = content['articles'].length;
        content['videos'] = content['videos'].length;
        content['students'] = content['students'].length;
        content['authorId'] = user.toMap();

        stat['content'] = content;

        // final Content content = Content.fromMap(contentMaps[i]);

        stats.add(SalesStats.fromMap(stat));
      }

      var tutorStatsMap = {
        'stats': stats,
        'totalSales': totalSales,
        'totalProfit': totalProfit,
        'totalRevenue': totalRevenue
      };
      return TutorSalesStats.fromMap(tutorStatsMap);
    } else {
      return AppError.errorObject(response);
    }
  }
}
