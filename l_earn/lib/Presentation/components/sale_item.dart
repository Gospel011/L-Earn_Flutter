import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/stats_model.dart';
import 'package:l_earn/utils/mixins.dart';


class SaleItem extends StatelessWidget with PriceParserMixin {
  const SaleItem({super.key, required this.stat});

  final SalesStats stat;

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
          print("Navigate to a more detailed page with book sales stats");
        },
        leading: ClipRRect(
            // borderRadius: BorderRadius.circular(48),
            child: SizedBox(
                width: 48,
                height: 48,
                child: Image.network(stat.content.thumbnailUrl))),
        title: Text(
          stat.content.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme?.copyWith(color: Colors.black),
        ),
        subtitle: Text(
            stat.sales == 1 ? "${stat.sales} sale" : "${stat.sales} sales",
            style: textTheme?.copyWith(fontSize: 14)),
        trailing: Text(
            '\u20A6${parsePrice((stat.content.price * stat.sales).toString())}'),
      ),
    );
  }
}
