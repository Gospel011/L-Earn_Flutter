import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/DataLayer/Models/invoice_model.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/Presentation/components/my_elevated_button.dart';
import 'package:l_earn/Presentation/components/my_invoice_card.dart';

import 'package:l_earn/utils/mixins.dart';

import 'package:l_earn/BusinessLogic/paymentCubit/payment_cubit.dart';
import 'package:flutter/services.dart';

class PaymentPage extends StatelessWidget with AppBarMixin, PriceParserMixin {
  const PaymentPage({super.key, required Content content}) : _content = content;

  final Content _content;

  void CopyText(BuildContext context, text, {required String price}) async {
    Clipboard.setData(ClipboardData(text: text));

    showDialog(
        context: context,
        builder: (context) {
          return MyDialog(
              title: "Account Number Copied",
              content: RichText(
                text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    text: 'You may now proceed to make a bank transfer of ',
                    children: [
                      TextSpan(
                          text: "\u20A6${price}",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  )),
                      const TextSpan(text: ' to complete your checkout.')
                    ]),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    const double offset = 2;

    return Scaffold(
        appBar: buildAppBar(context, title: 'Checkout'),
        backgroundColor: Colors.grey.shade100,
        bottomNavigationBar: BottomAppBar(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<PaymentCubit, PaymentState>(
            builder: (context, state) {
              //? "COPY ACCOUNT NUMBER" BUTTON
              return MyElevatedButton(
                text: 'Copy Account Number',
                onPressed: () {
                  CopyText(context, state.invoice!.accountNumber,
                      price: parsePrice("${state.invoice!.amount}"));
                },
              );
            },
          ),
        )),
        body:
            BlocBuilder<PaymentCubit, PaymentState>(builder: (context, state) {
          final Invoice invoice = state.invoice!;

          print("INVOICE AMOUNT ${invoice.amount}");

          return Center(
            //? Container containing the Invoice
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //? Top Spacing incase of limited space
                  const SizedBox(
                    height: 24,
                  ),

                  InvoiceCard(invoice: invoice),

                  //? Bottom Spacing incase of limited space
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
