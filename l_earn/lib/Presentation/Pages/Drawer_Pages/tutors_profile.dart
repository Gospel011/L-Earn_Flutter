// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/paymentCubit/payment_cubit.dart';
import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/DataLayer/Models/stats_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/Presentation/components/render_user_name.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/enums.dart';
import 'package:l_earn/utils/mixins.dart';

class TutorsProfilePage extends StatefulWidget
    with AppBarMixin, PriceParserMixin {
  const TutorsProfilePage({super.key});

  @override
  State<TutorsProfilePage> createState() => _TutorsProfilePageState();
}

class _TutorsProfilePageState extends State<TutorsProfilePage> {
  @override
  void initState() {
    super.initState();

    print("Loading tutors Stats");
    context
        .read<PaymentCubit>()
        .loadTutorStats(context.read<AuthCubit>().state.user!);
  }

  bool _profitVisible = true;

  @override
  Widget build(BuildContext context) {
    final User user = context.read<AuthCubit>().state.user!;
    final BoxDecoration decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(16), color: Colors.white);
    const EdgeInsets padding = EdgeInsets.all(8);
    const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 16);

    return Scaffold(
      appBar: widget.buildAppBar(context, title: 'Tutor\'s Dashboard'),
      backgroundColor: Colors.grey.shade100,
      body: Center(
          child: CustomScrollView(
        slivers: [
          //? TOP DECRIPTION
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),

                //? TUTORS MINI PROFILE
                Padding(
                  padding: screenPadding,
                  child: TutorMiniProfile(user: user),
                ),

                const SizedBox(
                  height: 8,
                ),

                //? PROFIT || REVENUE
                const Padding(
                  padding: screenPadding,
                  child: Row(
                    children: [
                      Expanded(
                        child: SalesCard(
                            title: 'Sales Profit',
                            tip:
                                "This is the amount that would be paid into your account at the end of the month",
                            useVisibility: false,
                            type: SaleCardType.profit),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: SalesCard(
                            title: 'Revenue',
                            tip:
                                "This is the total price of books sold that has not been disbursed yet",
                            useVisibility: false,
                            type: SaleCardType.revenue),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),

                //? TOP PAYING CONTENTS
                BlocBuilder<PaymentCubit, PaymentState>(
                    builder: (context, state) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Sales (${state.stats?.totalSales ?? 0})",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold)));
                }),

                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),

          //? SCROLLABLE LIST OF SALEITEM
          BlocBuilder<PaymentCubit, PaymentState>(builder: (context, state) {
            return SliverList.builder(
                itemCount: state is TutorStatsLoaded
                    ? state.stats!.stats.length
                    : 1,
                itemBuilder: (context, index) {
                  // return Text(
                  //     "Title: ${stat.content.title}, sales: ${stat.sales}");

                  print("Sales state $state");

                  if (state is TutorStatsLoaded) {
                    final SalesStats stat = state.stats!.stats[index];

                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, left: 16, right: 16),
                      child: SaleItem(stat: stat),
                    );
                  } else {
                    return const Center(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child:
                            CircularProgressIndicator(color: Colors.blueGrey),
                      ),
                    );
                  }
                });
          })
        ],
      )),
    );
  }
}

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
        subtitle: Text(stat.sales == 1 ? "${stat.sales} sale" : "${stat.sales} sales",
            style: textTheme?.copyWith(fontSize: 14)),
        trailing: Text('\u20A6${parsePrice(stat.content.price.toString())}'),
      ),
    );
  }
}

class TutorMiniProfile extends StatelessWidget {
  const TutorMiniProfile({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    final BoxDecoration decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(16), color: Colors.white);
    const EdgeInsets padding = EdgeInsets.all(8);

    return Container(
      decoration: decoration,
      padding: padding,
      child: SizedBox(
        height: 98,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyProfilePicture(
                user: user,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${user.firstName} ${user.lastName}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    Text("${user.followers}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const Text('Followers')
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
