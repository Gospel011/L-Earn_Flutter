import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:l_earn/DataLayer/Models/filter_model.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/Presentation/components/my_text_button.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/mixins.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key, required this.filter});
  final Filter filter;

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> with AppBarMixin {
  late Filter filter;
  List<bool> statusSelected = [false, false, true];
  List<bool> orderSelected = [false, true];

  @override
  void initState() {
    super.initState();
    filter = widget.filter;

    print("Filter is $filter");

    if (widget.filter.paymentStatus == 'PAID') {
      setTrue(statusSelected, 0);
    } else if (widget.filter.paymentStatus == 'PENDING') {
      setTrue(statusSelected, 1);
    }

    if (widget.filter.dateCreated == 'dateCreated') {
      setTrue(orderSelected, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      appBar: buildAppBar(context, title: 'Filter', includeClose: true,
          closeButtonOnpressed: () {
        Navigator.pop(context);
      }),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyTextButton(
                  text: 'Reset filters',
                  textDecoration: TextDecoration.underline,
                  textcolor: Colors.red,
                  onPressed: () {
                    setState(() {
                      statusSelected = [false, false, true];
                      orderSelected = [false, true];

                      filter = filter.copyWith(
                        paymentStatus: 'null',
                        dateCreated: 'null',
                      );
                    });
                  }),
              MyContainerButton(
                  text: "Apply filters",
                  onPressed: () {
                    Navigator.pop(context, filter.toMap());
                  })
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),

          //? filter parameters

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Payment Status',
              style: textTheme?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          //* FILTER BY PAYMENT STATUS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Wrap(
              runSpacing: 8,
              spacing: 10,
              alignment: WrapAlignment.center,
              children: [
                //? PAID
                MyContainerItem(
                  text: 'Paid',
                  selected: statusSelected[0],
                  onPressed: () {
                    setState(() {
                      setTrue(statusSelected, 0);

                      if (statusSelected[0] == true) {
                        filter = filter.copyWith(paymentStatus: 'PAID');
                      } else {
                        filter = filter.copyWith(paymentStatus: 'null');
                      }
                      print('::: Filter Object is $filter :::');
                    });
                  },
                ),

                //? PENDING
                MyContainerItem(
                  text: 'Pending',
                  selected: statusSelected[1],
                  onPressed: () {
                    setState(() {
                      setTrue(statusSelected, 1);
                      if (statusSelected[1] == true) {
                        filter = filter.copyWith(paymentStatus: 'PENDING');
                      } else {
                        filter = filter.copyWith(paymentStatus: 'null');
                      }
                      print('::: Filter Object is $filter :::');
                    });
                  },
                ),

                //? ALL
                MyContainerItem(
                  text: 'All',
                  selected: statusSelected[2],
                  onPressed: () {
                    setState(() {
                      setTrue(statusSelected, 2);
                      if (statusSelected[2] == true) {
                        filter = filter.copyWith(paymentStatus: 'null');
                      } else {
                        filter = filter.copyWith(paymentStatus: 'null');
                      }
                      print('::: Filter Object is $filter :::');
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 32,
          ),

          //* SORT BY DATE CREATED
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Sort by date created in',
              style: textTheme?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Wrap(
              runSpacing: 8,
              spacing: 10,
              alignment: WrapAlignment.center,
              children: [
                //? PAID
                MyContainerItem(
                  text: 'Ascending',
                  selected: orderSelected[0],
                  onPressed: () {
                    setState(() {
                      setTrue(orderSelected, 0);

                      if (orderSelected[0] == true) {
                        filter = filter.copyWith(dateCreated: 'dateCreated');
                      } else {
                        filter = filter.copyWith(dateCreated: 'null');
                      }
                      print('::: Filter Object is $filter :::');
                    });
                  },
                ),

                //? PENDING
                MyContainerItem(
                  text: 'Descending',
                  selected: orderSelected[1],
                  onPressed: () {
                    setState(() {
                      setTrue(orderSelected, 1);
                      if (orderSelected[1] == true) {
                        filter = filter.copyWith(dateCreated: '-dateCreated');
                      } else {
                        filter = filter.copyWith(dateCreated: 'null');
                      }
                      print('::: Filter Object is $filter :::');
                    });
                  },
                ),
              ],
            ),
          ),

          //? PAID
          // 'dateCreated',
          // 'invoiceRef'
        ],
      ),
    );
  }

  setTrue(List<bool> list, int index) {
    for (int i = 0; i < list.length; i++) {
      if (i == index) {
        list[i] = true;
      } else {
        list[i] = false;
      }
    }
  }
}

class MyContainerItem extends StatelessWidget {
  const MyContainerItem({
    super.key,
    required this.text,
    required this.selected,
    required this.onPressed,
    this.selectedButtonColor = Colors.black,
    this.selectedTextColor = Colors.white,
  });

  final String text;
  final bool selected;
  final void Function() onPressed;
  final Color selectedButtonColor;
  final Color selectedTextColor;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: selected == true ? selectedButtonColor : null,
            border: selected == true
                ? Border.all(color: selectedButtonColor)
                : Border.all(color: AppColor.textfieldEnabledBoderColor)),
        child: Text(text,
            style: textStyle?.copyWith(
                color: selected == true ? selectedTextColor : null,
                fontWeight:
                    selected == true ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }
}
