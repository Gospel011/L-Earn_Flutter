import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/DataLayer/Models/invoice_model.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/Presentation/components/my_elevated_button.dart';

import 'package:l_earn/utils/mixins.dart';
import 'package:l_earn/utils/constants.dart';
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
                          text: price,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,)),
                      const TextSpan(
                          text: ' to complete your checkout.')
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
              CopyText(context, state.invoice!.accountNumber, price: parsePrice("\u20A6${state.invoice!.amount}"));
            },
          );
            },
          ),
        )),
        body:
            BlocBuilder<PaymentCubit, PaymentState>(builder: (context, state) {
          final Invoice invoice = state.invoice!;

          return Center(
            //? Container containing the Invoice
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //? Top Spacing incase of limited space
                  const SizedBox(
                    height: 24,
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width - 32,
                    padding: const EdgeInsets.only(
                        left: 8, right: 16, top: 16, bottom: 16),

                    //* Some decoration for the container
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black87,
                              blurRadius: 10,
                              spreadRadius: 3,
                              offset: Offset(offset, offset)),
                          BoxShadow(
                              color: Colors.white,
                              blurRadius: 15,
                              offset: Offset(offset, offset)),
                          BoxShadow(
                              color: Colors.white,
                              blurRadius: 10,
                              offset: Offset(-4, -4)),
                          BoxShadow(
                              color: Colors.white,
                              blurRadius: 20,
                              spreadRadius: 6,
                              offset: Offset(-offset, -offset)),
                        ]),

                    //* Invoice contents
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //? App logo   Invoice
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: 64,
                                  width: 64,
                                  child: AppIcons.appLogo),
                              Text('Invoice',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.bold))
                            ],
                          ),

                          //? P R I C E
                          Text(
                            parsePrice('\u20A6${invoice.amount.toString()}'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                          ),

                          const SizedBox(
                            height: 24,
                          ),

                          //amount
                          // invoiceReference
                          // invoiceStatus
                          //* description
                          // customerEmail
                          // cutomerName
                          // expiryDate
                          // createdOn
                          // checkoutUrl
                          //* accountNumber
                          //* accountName
                          //* bankName
                          // transactionReference

                          //? Product details
                          //* name
                          InvoiceItem(
                              leading: 'Bank name', trailing: invoice.bankName),
                          const SizedBox(
                            height: 8,
                          ),
                          InvoiceItem(
                              leading: 'Account number',
                              trailing: invoice.accountNumber),
                          const SizedBox(
                            height: 8,
                          ),
                          InvoiceItem(
                              leading: 'Account name',
                              trailing: invoice.accountName),
                          const SizedBox(
                            height: 8,
                          ),
                          InvoiceItem(
                              leading: 'Description',
                              trailing: invoice.description),
                          const SizedBox(
                            height: 8,
                          ),
                          InvoiceItem(
                              leading: 'Payment status',
                              trailing: invoice.invoiceStatus.toLowerCase()),
                          const SizedBox(
                            height: 8,
                          ),
                          InvoiceItem(
                              leading: 'Created by',
                              trailing: invoice.cutomerName),

                          const SizedBox(
                            height: 24,
                          ),

                          //? Invoice Reference
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Ref: ${invoice.invoiceReference}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontSize: 14),
                                ),
                              )
                            ],
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          //? Note
                          RichText(
                            text: TextSpan(
                                text: 'Please Note: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                children: [
                                  TextSpan(
                                      text:
                                          'The provided account number is for one-time use and is only valid for ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic)),
                                  TextSpan(
                                      text:
                                          '20 minutes.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic, color: Colors.red)),
                                  TextSpan(
                                      text:
                                          '\n\n Transfers typically takes around ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic)),
                                  TextSpan(
                                      text:
                                          '5 minutes ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic, color: Colors.green)),
                                  TextSpan(
                                      text:
                                          'to reflect.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,))
                                ]),
                          )
                        ]),
                  ),

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

class InvoiceItem extends StatelessWidget {
  const InvoiceItem({
    super.key,
    required this.leading,
    required this.trailing,
  });

  final String leading;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //? Leading text
        Text(
          leading,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
        ),

        const SizedBox(
          width: 10,
        ),

        //? Trailing text
        Expanded(
            child: Text(
          trailing,
          textAlign: TextAlign.right,
        ))
      ],
    );
  }
}
