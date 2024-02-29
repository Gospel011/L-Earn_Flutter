import 'package:bloc/bloc.dart';

import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/DataLayer/Models/error_model.dart';
import 'package:l_earn/DataLayer/Models/invoice_model.dart';
import 'package:l_earn/DataLayer/Repositories/payment_repo.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(const PaymentInitial());

  Future<void> generateInvoice(token, contentId) async {
    emit(const GeneratingPaymentInvoice());

    final response = await PaymentRepo.generateInvoice(token, contentId);

    if (response is Invoice) {
      emit(PaymentInvoiceGenerated(invoice: response));
    } else {
      emit(GeneratingPaymentInvoiceFailed(error: response as AppError));
    }
  }

  Future<void> loadPaymentHistory(token, {Map<String, dynamic>? filters}) async {
    emit(LoadingPaymentHistory(invoices: state.invoices));

    final response = await PaymentRepo.loadPaymentHistory(token, filters);

    if (response is List<Invoice>) {
      print("P A Y M E N T   H I S T O R Y   $response");
      emit(PaymentHistoryLoaded(invoices: response));
    } else {
      emit(LoadingPaymentHistoryFailed(error: response as AppError));
    }
  }
}
