// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'payment_cubit.dart';

abstract class PaymentState {
  final Invoice? invoice;
  final Content? content;
  final List<Invoice>? invoices;
  final TutorSalesStats? stats;
  final AppError? error;

  const PaymentState({this.invoice, this.invoices, this.content, this.stats, this.error});
}

/// Initial state when payment cubit is first initialized;
class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class GeneratingPaymentInvoice extends PaymentState {
  const GeneratingPaymentInvoice();
}

class PaymentInvoiceGenerated extends PaymentState {
  const PaymentInvoiceGenerated({required super.invoice});
}

class GeneratingPaymentInvoiceFailed extends PaymentState {
  const GeneratingPaymentInvoiceFailed({required super.error});
}

class LoadingPaymentHistory extends PaymentState {
  const LoadingPaymentHistory({required super.invoices});
}

class PaymentHistoryLoaded extends PaymentState {
  const PaymentHistoryLoaded({required super.invoices});
}

class LoadingPaymentHistoryFailed extends PaymentState {
  const LoadingPaymentHistoryFailed({required super.error});
}

class LoadingTutorStats extends PaymentState {
  const LoadingTutorStats({required super.stats});
}

class TutorStatsLoaded extends PaymentState {
  const TutorStatsLoaded({required super.stats});
}

class LoadingTutorStatsFailed extends PaymentState {
  const LoadingTutorStatsFailed({required super.error, super.stats});
}
