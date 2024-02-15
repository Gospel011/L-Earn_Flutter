import 'package:flutter/material.dart';
import 'package:l_earn/utils/colors.dart';

class MyPriceContainer extends StatelessWidget {
  const MyPriceContainer({super.key, required this.price});

  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: AppColor.priceTagGold,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Text('\u20A6$price',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
        ));
  }
}
