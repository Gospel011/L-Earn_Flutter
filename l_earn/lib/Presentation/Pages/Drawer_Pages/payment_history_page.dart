import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/paymentCubit/payment_cubit.dart';
import 'package:l_earn/DataLayer/Models/filter_model.dart';
import 'package:l_earn/DataLayer/Models/invoice_model.dart';
import 'package:l_earn/Presentation/Pages/Drawer_Pages/filter_page.dart';
import 'package:l_earn/Presentation/components/history_item.dart';

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

    loadHistory();
  }

  Future<void> loadHistory() async {
    await context.read<PaymentCubit>().loadPaymentHistory(
        context.read<AuthCubit>().state.user?.token,
        filters: filter.toMap());
  }

  @override
  Widget build(BuildContext context) {
    print("Build method called ::: \n");

    final textTheme = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      appBar: widget.buildAppBar(context, title: 'Payment History', automaticallyImplyLeading: Platform.isWindows, actions: [
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
          
          finalWidget = const Center(
              child: ListTile(
            title: Center(
              child: CircularProgressIndicator(
                color: Colors.blueGrey,
              ),
            )            
          ));

        } else if (state.invoices != null && state.invoices!.isEmpty) {
          finalWidget = const Center(
            child: Text("No invoice found"),
          );
        } else {
          finalWidget = Column(
            children: [
              Expanded(
                  child: RefreshIndicator(
                      color: Colors.black,
                      onRefresh: () async {
                        await loadHistory();
                      },
                      child: buidTransactionHistory(context, state))),
            ],
          );
        }

        return finalWidget;
      }),
    );
  }

  //* WIDGET METHODS

  Widget buidTransactionHistory(BuildContext context, PaymentState state) {
    if (state.invoices == null || state.invoices!.isEmpty) {
      return const Text('You haven\'t made any purchases yet.');
    } else {

      //? Listview of history items
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
