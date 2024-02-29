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

  void loadHistory() {
    context.read<PaymentCubit>().loadPaymentHistory(
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
        IconButton(
            tooltip: 'Refresh',
            onPressed: loadHistory,
            icon: const Icon(Icons.refresh_rounded)),

        //? FILTER BUTTON
        IconButton(
            tooltip: 'Filter',
            onPressed: () async {
              final Map<String, dynamic>? response = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterPage(filter: filter)));

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
      body: BlocBuilder<PaymentCubit, PaymentState>(builder: (context, state) {
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
            child: Text("You have not purchased any books"),
          );
        } else {
          finalWidget = CustomScrollView(
            slivers: [
              const SliverPadding(padding: EdgeInsets.all(8)),
              buidTransactionHistory(context, state),
              const SliverPadding(padding: EdgeInsets.all(24)),
            ],
          );
        }

        return finalWidget;
      }),
    );
  }

  Widget buidTransactionHistory(BuildContext context, PaymentState state) {
    if (state.invoices == null || state.invoices!.isEmpty) {
      return const Text('You haven\'t made any purchases yet.');
    } else {
      return SliverList.builder(
        itemCount: state.invoices!.length,
        itemBuilder: (BuildContext context, int index) {
          final Invoice currentInvoice = state.invoices![index];

          final textTheme =
              Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14);
          const double offset = 2;

          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 2,
                        // spreadRadius: 1,
                        offset: Offset(offset, offset)),
                    BoxShadow(
                        color: Colors.white,
                        blurRadius: 2,
                        offset: Offset(-offset, -offset)),
                  ]),
              child: ListTile(
                onTap: () {
                  print(
                      "Navigate to PaymentDetails page with payment details: $currentInvoice");
                },

                //? PURCHASED BOOK IMAGE
                leading: ClipRRect(
                    borderRadius: BorderRadius.circular(48),
                    child: currentInvoice.contentThumbnailUrl != null
                        ? SizedBox(
                            width: 48,
                            height: 48,
                            child: Image.network(
                                currentInvoice.contentThumbnailUrl!))
                        : const ImageLoadingPlaceHolderWidget(
                            width: 48,
                            height: 48,
                          )),

                //? TITLE OF BOOK
                title: Text(
                  currentInvoice.contentTitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme?.copyWith(color: Colors.black),
                ),

                //? DATE BOUGHT
                subtitle: Text(
                    "Created on ${formatJsTimestamp(currentInvoice.dateCreated)}",
                    style: textTheme?.copyWith(fontSize: 12)),

                //? AMOUNT AND STATUS
                trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //* AMOUNT
                      Text(
                          '\u20A6${widget.parsePrice(currentInvoice.amount.toString())}'),

                      //* STATUS
                      Text(
                        currentInvoice.invoiceStatus.toLowerCase(),
                        style: textTheme?.copyWith(
                            fontSize: 12,
                            color: currentInvoice.invoiceStatus == 'PENDING'
                                ? AppColor.priceTagGold
                                : currentInvoice.invoiceStatus == 'PAID'
                                    ? Colors.green
                                    : Colors.red),
                      ),
                    ]),
              ),
            ),
          );
        },
      );
    }
  }

  String formatJsTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);

    dateTime = dateTime.toLocal();

    String formattedDate = DateFormat('MMM d, y. h:mm a').format(dateTime);

    return formattedDate;
  }
}
