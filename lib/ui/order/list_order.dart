import 'dart:async';
import 'dart:math';

import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/di/components/service_locator.dart';
import 'package:boilerplate/ui/order/detail_order.dart';
import 'package:boilerplate/utils/shared/nav_service.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../models/order/order.dart';
import '../../utils/shared/text_format.dart';
import '../../widgets/order_status_icon_widget.dart';

class ListOrderScreen extends StatefulWidget {
  final Map<String, dynamic>? queryParams;
  final List<Order>? orders;

  const ListOrderScreen({
    Key? key,
    this.queryParams,
    this.orders,
  });

  @override
  State<StatefulWidget> createState() => _ListOrderScreenState();
}

class _ListOrderScreenState extends State<ListOrderScreen> {
  final Repository _repository = getIt<Repository>();
  late PagewiseLoadController<Order> _pagewiseLoadController;
  late String searchKey = "";

  @override
  void initState() {
    super.initState();
    _pagewiseLoadController = PagewiseLoadController<Order>(
        pageSize: 10,
        pageFuture: (pageIndex) => _repository.getOrders2({
              ...{
                "page": (pageIndex ?? 0) + 1,
                "item_per_page": 10,
              },
              ...?widget.queryParams
            }));
    _pagewiseLoadController.addListener(() {
      if (this._pagewiseLoadController.hasMoreItems == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No data!'),
          backgroundColor: AppColors.green[500],
        ));
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgGreyColor,
      height: MediaQuery.of(context).size.height - 323,
      child: _buildMainContent(),
    );
  }

  Widget _buildMainContent() {
    return widget.orders != null && widget.orders?.length != 0
        ? ListView.builder(
            itemCount: widget.orders?.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildListItem(context, widget.orders![index], index);
            },
          )
        : RefreshIndicator(
            onRefresh: () async {
              _pagewiseLoadController.reset();
              await Future.value({});
            },
            child: PagewiseListView<Order>(
              padding: EdgeInsets.only(top: 0),
              itemBuilder: _buildListItem,
              pageLoadController: _pagewiseLoadController,
              errorBuilder: (context, error) {
                print('error: $error');
                return Text('Error: $error');
              },
              showRetry: false,
            ));
  }

  Widget _buildListItem(context, Order order, _) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyLabelWidget(
                      text: "Order Code",
                      style: AppStyles.textStyle16Regular400),
                  MyLabelWidget(
                      text: order.code, style: AppStyles.textStyle18Medium.merge(TextStyle(color: Colors.primaries[Random().nextInt(Colors.primaries.length)])))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyLabelWidget(
                      text: "Total",
                      style: AppStyles.textStyle16Regular400),
                  MyLabelWidget(
                      text: CurrencyFormat.usd(order.price.toString()),
                      style: AppStyles.textStyle18Medium)
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyLabelWidget(
                      text: "Created At",
                      style: AppStyles.textStyle16Regular400
                          .merge(TextStyle(color: AppColors.greyPrice))),
                  MyLabelWidget(
                      text: new DateFormat('HH:mm dd/MM/yyyy').format(
                          DateTime.fromMicrosecondsSinceEpoch(order.createdAt)),
                      style: AppStyles.textStyle16Regular400
                          .merge(TextStyle(color: AppColors.greyPrice)))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyLabelWidget(
                      text: "Status",
                      style: AppStyles.textStyle16Regular400
                          .merge(TextStyle(color: AppColors.greyPrice))),
                  OrderStatusIconWidget(status: order.status),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 10, top: 10),
                height: 97,
                width: MediaQuery.of(context).size.width - 60,
                decoration: BoxDecoration(
                    color: AppColors.bgGreyColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyLabelWidget(
                        text: order.shop.name,
                        style: AppStyles.textStyle16Regular400),
                    SizedBox(
                      height: 5,
                    ),
                    MyLabelWidget(
                        text: order.recvAddress.fullAddress,
                        style: AppStyles.textStyle14Regular
                            .merge(TextStyle(color: AppColors.greyPrice))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        NavigationService.push(
            context,
            DetailOrderScreen(
              orderDetail: order,
            ));
      },
    );
  }
}
