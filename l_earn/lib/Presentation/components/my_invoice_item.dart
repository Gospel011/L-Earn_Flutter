import 'package:flutter/material.dart';


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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15),
        ))
      ],
    );
  }
}
