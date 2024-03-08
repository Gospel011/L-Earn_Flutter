import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/paymentCubit/payment_cubit.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/enums.dart';
import 'package:l_earn/utils/mixins.dart';

class SalesCard extends StatefulWidget with PriceParserMixin {
  const SalesCard({
    super.key,
    required this.title,
    this.tip,
    required this.useVisibility,
    required this.type,
  });

  final String title;
  final String? tip;
  final bool useVisibility;
  final SaleCardType type;

  @override
  State<SalesCard> createState() => _SalesCardState();
}

class _SalesCardState extends State<SalesCard> {
  bool _profitVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: Colors.white),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              //? PROFIT
              Text(widget.title),

              //? HELP
              widget.tip == null
                  ? const SizedBox()
                  : PopupMenuButton(
                      tooltip: 'more info',
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Icon(
                        Icons.question_mark_rounded,
                        color: AppColor.textfieldEnabledBoderColor,
                        size: 16,
                      ),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                              child: Container(
                            child: Text(
                              widget.tip!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontSize: 14),
                            ),
                          ))
                        ];
                      }),

              // const SizedBox(
              //   width: 16,
              // ),

              widget.useVisibility == false
                  ? const SizedBox()
                  : IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        setState(() {
                          _profitVisible = !_profitVisible;
                        });
                      },
                      icon: _profitVisible == true
                          ? const Icon(
                              Icons.visibility_off_rounded,
                              color: AppColor.textColor,
                            )
                          : const Icon(Icons.visibility_rounded,
                              color: AppColor.textColor))
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          BlocBuilder<PaymentCubit, PaymentState>(builder: (context, state) {
            print("C U R R E N T   S T A T E   I S   $state");
            // return Text(widget.parsePrice(state.stats!.totalProfit.toString()));
            return Text(
              state is TutorStatsLoaded
                  ? "\u20A6${_profitVisible == true ? widget.parsePrice('${widget.type == SaleCardType.profit ? state.stats?.totalProfit ?? 0 : state.stats?.totalRevenue ?? 0}') : "****"}"
                  : "\u20A6____",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.green),
            );
          })
        ],
      ),
    );
  }
}