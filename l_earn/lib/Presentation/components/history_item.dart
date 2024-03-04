import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/invoice_model.dart';
import 'package:l_earn/Presentation/components/my_image_loading_placeholder_widget.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/mixins.dart';


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

          Navigator.of(context).pushNamed('/payment-details', arguments: invoice);
        },
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
        title: Text(
          invoice.contentTitle!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme?.copyWith(color: Colors.black),
        ),
        subtitle: Text("Created on ${formatTimestamp(invoice.dateCreated)}",
            style: textTheme?.copyWith(fontSize: 12)),
        trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\u20A6${parsePrice(invoice.amount.toString())}'),
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
