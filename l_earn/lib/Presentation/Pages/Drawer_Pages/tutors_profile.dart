// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/paymentCubit/payment_cubit.dart';

import 'package:l_earn/DataLayer/Models/stats_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/sale_item.dart';
import 'package:l_earn/Presentation/components/sales_card.dart';
import 'package:l_earn/Presentation/components/tutor_mini_profile.dart';

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
    loadStats();
  }

  void loadStats() {
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
                                "This is the total price of books sold during this period",
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
                itemCount:
                    state is TutorStatsLoaded ? state.stats!.stats.length : 1,
                itemBuilder: (context, index) {
                  // return Text(
                  //     "Title: ${stat.content.title}, sales: ${stat.sales}");

                  print("Sales state $state");

                  if (state is TutorStatsLoaded) {
                    final SalesStats stat = state.stats!.stats[index];

                    return state.stats!.stats.isEmpty
                        ? const Text("You have not made any sale yet")
                        : Padding(
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


