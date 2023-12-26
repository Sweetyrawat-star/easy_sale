import 'dart:math';

import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/models/order/order.dart';
import 'package:boilerplate/models/variant/variant.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/network/constants/endpoints.dart';
import '../../data/repository.dart';
import '../../di/components/service_locator.dart';
import '../../utils/shared/text_format.dart';
import 'order_track_widget.dart';

class DetailOrderScreen extends StatefulWidget {
  final Order orderDetail;

  DetailOrderScreen({Key? key, required this.orderDetail});
  
  @override
  State<StatefulWidget> createState() => _DetailOrderScreenState();
}

class _DetailOrderScreenState extends State<DetailOrderScreen> {
  final Repository _repository = getIt<Repository>();
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 40.0,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: MyLabelWidget(
          text: "Order detail",
          style: AppStyles.textStyle20RegularBold,
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: _buildBody(),
      ),
    ); //MaterialApp
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.only(left: 0, right: 0, top: 15),
      child: Column(
        children: [
          Container(
            height: 77,
            width: MediaQuery.of(context).size.width - 40,
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: AppColors.bgGreyColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyLabelWidget(text: "Order Code", style: AppStyles.textStyle16Regular400),
                    MyLabelWidget(text: widget.orderDetail.code, style: AppStyles.textStyle16Medium.merge(TextStyle(color: Colors.primaries[Random().nextInt(Colors.primaries.length)]))),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyLabelWidget(text: "Created At", style: AppStyles.textStyle14Regular.merge(TextStyle(color: AppColors.textGreyColor))),
                    MyLabelWidget(text: new DateFormat('HH:mm dd/MM/yyyy').format(
                        DateTime.fromMicrosecondsSinceEpoch(widget.orderDetail.createdAt)), style: AppStyles.textStyle14Regular.merge(TextStyle(color: AppColors.textGreyColor))),
                  ],
                ),
              ],
            ),
          ),
          OrderTrackingWidget(orderDetail: widget.orderDetail),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.only(left: 10, top: 10),
            height: 90,
            width: MediaQuery.of(context).size.width - 40,
            decoration: BoxDecoration(
                color: AppColors.bgGreyColor,
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyLabelWidget(text: widget.orderDetail.shop.name, style: AppStyles.textStyle16Regular400),
                SizedBox(height: 5,),
                MyLabelWidget(text: widget.orderDetail.recvAddress.fullAddress, style: AppStyles.textStyle14Regular.merge(TextStyle(color: AppColors.greyPrice))),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Divider(thickness: 7,),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyLabelWidget(text: widget.orderDetail.items.length.toString() + " items", style: AppStyles.textStyle16Regular400.merge(TextStyle(color: AppColors.textGreyColor))),
                MyLabelWidget(text: "Total:", style: AppStyles.textStyle16Regular400),
                MyLabelWidget(text: CurrencyFormat.usd(widget.orderDetail.price.toString()), style: AppStyles.textStyle16Regular400.merge(TextStyle(color: AppColors.redLightColor))),
              ],
            ),
          ),
          Divider(thickness: 1,),
          Container(
            height: 300,
            child: ListView.builder(
              itemCount: widget.orderDetail.items.length,
              itemBuilder: (BuildContext context, int index) => _buildProductItem(index),
              // padding: EdgeInsets.only(top: 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(int index) {
    OrderItem item = widget.orderDetail.items[index];
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: FutureBuilder(
        future: _repository.getProductVariant(item.variantId),
        builder: ((context, AsyncSnapshot<ProductVariant> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Row(
                children: [
                  Container(
                      height: 76,
                      width: 76,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              Endpoints.getDownloadUrl(snapshot.data?.images[0] ?? ""),
                            )),
                        borderRadius: BorderRadius.circular(5),
                      )
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: MediaQuery.of(context).size.width - 106,
                    // height: 76,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyLabelWidget(text: snapshot.data?.name ?? "", style: AppStyles.textStyle16Regular400),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyLabelWidget(text: CurrencyFormat.usd((snapshot.data?.price ?? "").toString()), style: AppStyles.textStyle16Regular400.merge(TextStyle(color: AppColors.textGreyColor))),
                            MyLabelWidget(text: "x" + item.quantity.toString(), style: AppStyles.textStyle16Regular400.merge(TextStyle(color: AppColors.textGreyColor)))
                          ],
                        )
                      ],
                    ),
                  ),

                ],
              );
            } else {
              return SizedBox();
            }
          } else {
            return SizedBox();
          }
        }),
      ),
    );
  }
}
