import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:l_earn/DataLayer/Models/invoice_model.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/Presentation/components/my_invoice_item.dart';
import 'package:l_earn/utils/constants.dart';
import 'package:l_earn/utils/mixins.dart';

class InvoiceCard extends StatelessWidget with PriceParserMixin {
  const InvoiceCard({super.key, required this.invoice, this.showShadow = true});

  final Invoice invoice;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    const double offset = 2;
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      padding: const EdgeInsets.only(left: 8, right: 16, top: 16, bottom: 16),

      //* Some decoration for the container
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: showShadow == false ? null : const [
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
                color: Colors.white, blurRadius: 10, offset: Offset(-4, -4)),
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
                SizedBox(height: 64, width: 64, child: AppIcons.appLogo),
                Text('Invoice',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold))
              ],
            ),

            //? P R I C E
            Text(
              "\u20A6${parsePrice(invoice.amount.toString())}",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 24, color: invoice.invoiceStatus == 'PAID' ? Colors.green : null),
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
            InvoiceItem(leading: 'Bank name', trailing: invoice.bankName),
            const SizedBox(
              height: 8,
            ),
            InvoiceItem(
                leading: 'Account number', trailing: invoice.accountNumber),
            const SizedBox(
              height: 8,
            ),
            InvoiceItem(leading: 'Account name', trailing: invoice.accountName),
            const SizedBox(
              height: 8,
            ),
            InvoiceItem(leading: 'Description', trailing: invoice.description),
            const SizedBox(
              height: 8,
            ),
            InvoiceItem(
                leading: 'Payment status',
                trailing: invoice.invoiceStatus.toLowerCase()),
            const SizedBox(
              height: 8,
            ),
            InvoiceItem(leading: 'Created by', trailing: invoice.cutomerName),

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
                ),
                IconButton(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: invoice.invoiceReference));

                      showDialog(
                          context: context,
                          builder: (context) {
                            return const MyDialog(
                                title: "Ref Copied",
                                content:
                                    'Your invoice reference has been copied successfully');
                          });
                    },
                    icon: const Icon(
                      Icons.copy_rounded,
                      size: 18,
                    ))
              ],
            ),

            const SizedBox(
              height: 8,
            ),

            //? Note
            RichText(
              text: TextSpan(
                  text: 'Please Note: ',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                  children: [
                    TextSpan(
                        text:
                            'The provided account number is for one-time use and is only valid for ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14, fontStyle: FontStyle.italic)),
                    TextSpan(
                        text: '20 minutes.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.red)),
                    TextSpan(
                        text: '\n\n Transfers typically takes around ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14, fontStyle: FontStyle.italic)),
                    TextSpan(
                        text: '5 minutes ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.green)),
                    TextSpan(
                        text: 'to reflect.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ))
                  ]),
            )
          ]),
    );
  }
}
