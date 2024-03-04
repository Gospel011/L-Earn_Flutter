import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/invoice_model.dart';
import 'package:l_earn/Presentation/components/my_invoice_card.dart';
import 'package:l_earn/utils/mixins.dart';

class PaymentDetailsPage extends StatelessWidget with AppBarMixin {
  const PaymentDetailsPage({super.key, required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: 'Payment Details'),
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 24,),
            InvoiceCard(invoice: invoice, showShadow: true)
          ],
        ),
      ),
    );
  }
}
