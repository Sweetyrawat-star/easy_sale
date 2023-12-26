import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/ui/order/list_order.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:flutter/material.dart';

class ManageOrderScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 5,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                backgroundColor: AppColors.green[200],
                floating: true,
                pinned: true,
                title: MyLabelWidget(text: "Manage orders", style: AppStyles.textStyle18RegularBold, ),
                bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: Theme.of(context).primaryColor,
                  tabs: [
                    Tab(
                      child: MyLabelWidget(
                        text: 'ALL',
                        style: AppStyles.textStyle15Regular,
                      ),
                    ),
                    Tab(
                      child: MyLabelWidget(
                        text: 'New',
                        style: AppStyles.textStyle15Regular,
                      ),
                    ),Tab(
                      child: MyLabelWidget(
                        text: 'Processing',
                        style: AppStyles.textStyle15Regular,
                      ),
                    ),Tab(
                      child: MyLabelWidget(
                        text: 'Success',
                        style: AppStyles.textStyle15Regular,
                      ),
                    ),Tab(
                      child: MyLabelWidget(
                        text: 'Failed',
                        style: AppStyles.textStyle15Regular,
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              ListOrderScreen(queryParams: {}),
              ListOrderScreen(queryParams: {"status": "created"}),
              ListOrderScreen(queryParams: {"status": "shipped,verified"}),
              ListOrderScreen(queryParams: {"status": "delivered"}),
              ListOrderScreen(queryParams: {"status": "canceled,returned"}),
            ],
          ),
        ),
      ),
    ); //MaterialApp
  }
}
