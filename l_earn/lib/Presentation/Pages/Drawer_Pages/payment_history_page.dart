import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/paymentCubit/payment_cubit.dart';
import 'package:l_earn/DataLayer/Models/filter_model.dart';
import 'package:l_earn/DataLayer/Models/invoice_model.dart';
import 'package:l_earn/Presentation/Pages/Drawer_Pages/filter_page.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/Presentation/components/my_image_loading_placeholder_widget.dart';
import 'package:intl/intl.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/mixins.dart';

class PaymentHistoryPage extends StatefulWidget
    with AppBarMixin, PriceParserMixin {
  const PaymentHistoryPage({super.key});

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  Filter filter = Filter();

  @override
  void initState() {
    super.initState();

    //? START LOADING PAYMENT HISTORY
    loadHistory();
  }

  Future<void> loadHistory() async {
    await context.read<PaymentCubit>().loadPaymentHistory(
        context.read<AuthCubit>().state.user?.token,
        filters: filter.toMap());
  }

  @override
  Widget build(BuildContext context) {
    //? filter parameters
    //  'paymentStatus',
    // 'dateCreated',
    // 'invoiceRef'

    print("Build method called ::: \n");

    final textTheme = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      appBar: widget.buildAppBar(context, title: 'Payment History', actions: [
        //? REFRESH BUTTON
        BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, state) {
            return IconButton(
                tooltip: 'Refresh',
                onPressed: () {
                  if (state is LoadingPaymentHistory) {
                    return;
                  }
                  loadHistory();
                },
                icon: state is LoadingPaymentHistory
                    ? const Center(
                        child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                color: Colors.blueGrey)))
                    : const Icon(Icons.refresh_rounded));
          },
        ),

        //? FILTER BUTTON
        IconButton(
            tooltip: 'Filter',
            onPressed: () async {
              final Map<String, dynamic>? response = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FilterPage(filter: filter)));

              print(
                  "R E S P O N S E   F R O M   F I L T E R   P A G E   I S   $response");
              if (response != null) {
                filter = Filter.fromMap(response);
                loadHistory();

                print('Filter Object is $filter');
              }
            },
            icon: const Icon(Icons.filter_alt)),
      ]),
      backgroundColor: Colors.grey.shade100,
      body: BlocBuilder<PaymentCubit, PaymentState>(
          buildWhen: (previous, current) {
        return current is PaymentHistoryLoaded;
      }, builder: (context, state) {
        late Widget finalWidget;
        print(state.invoices);

        if (state is LoadingPaymentHistory) {
          finalWidget = Center(
              child: ListTile(
            title: const Center(
              child: CircularProgressIndicator(
                color: Colors.blueGrey,
              ),
            ),
            subtitle: Text("Loading transaction history...",
                style: Theme.of(context).textTheme.bodyMedium),
          ));
        } else if (state.invoices != null && state.invoices!.isEmpty) {
          finalWidget = const Center(
            child: Text("No invoice found"),
          );
        } else {
          finalWidget = Column(
            children: [
              // const SliverPadding(padding: EdgeInsets.all(8)),
              Expanded(
                  child: RefreshIndicator(
                      onRefresh: () async {
                        await loadHistory();
                      },
                      child: buidTransactionHistory(context, state))),
              // const SliverPadding(padding: EdgeInsets.all(24)),
            ],
          );

          // finalWidget = RefreshIndicator(
          //   onRefresh: () async {
          //     await Future.delayed(const Duration(seconds: 10));
          //   },
          //   child: ListView.builder(
          //     itemBuilder: (context, index) {
          //       Text(state.invoices![index].description);
          //     },
          //   ),
          // );
        }

        return finalWidget;
      }),
    );
  }

  Widget buidTransactionHistory(BuildContext context, PaymentState state) {
    if (state.invoices == null || state.invoices!.isEmpty) {
      return const Text('You haven\'t made any purchases yet.');
    } else {
      return ListView.separated(
        itemCount: state.invoices!.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 8);
        },
        itemBuilder: (BuildContext context, int index) {
          final Invoice currentInvoice = state.invoices![index];

          if (index == 0) {
            return Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8,
                  ),
                  child: HistoryItem(invoice: currentInvoice),
                )
              ],
            );
          }

          return Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8,
            ),
            child: HistoryItem(invoice: currentInvoice),
          );
        },
      );
    }
  }
}

class HistoryItem extends StatelessWidget
    with TimeParserMixin, PriceParserMixin {
  const HistoryItem({super.key, required this.invoice});
  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final textTheme =
        Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14);
    const double offset = 2;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 2,
                // spreadRadius: 1,
                offset: const Offset(offset, offset)),
            const BoxShadow(
                color: Colors.white,
                blurRadius: 2,
                offset: Offset(-offset, -offset)),
          ]),
      child: ListTile(
        onTap: () {
          print(
              "Navigate to PaymentDetails page with payment details: $invoice");
        },

        //? PURCHASED BOOK IMAGE
        leading: ClipRRect(
            borderRadius: BorderRadius.circular(48),
            child: invoice.contentThumbnailUrl != null
                ? SizedBox(
                    width: 48,
                    height: 48,
                    child: Image.network(invoice.contentThumbnailUrl!))
                : const ImageLoadingPlaceHolderWidget(
                    width: 48,
                    height: 48,
                  )),

        //? TITLE OF BOOK
        title: Text(
          invoice.contentTitle!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme?.copyWith(color: Colors.black),
        ),

        //? DATE BOUGHT
        subtitle: Text("Created on ${formatTimestamp(invoice.dateCreated)}",
            style: textTheme?.copyWith(fontSize: 12)),

        //? AMOUNT AND STATUS
        trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //* AMOUNT
              Text('\u20A6${parsePrice(invoice.amount.toString())}'),

              //* STATUS
              Text(
                invoice.invoiceStatus.toLowerCase(),
                style: textTheme?.copyWith(
                    fontSize: 14,
                    color: invoice.invoiceStatus == 'PENDING'
                        ? AppColor.priceTagGold
                        : invoice.invoiceStatus == 'PAID'
                            ? Colors.green
                            : Colors.red),
              ),
            ]),
      ),
    );
  }
}
