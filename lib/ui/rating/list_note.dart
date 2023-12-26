import 'dart:async';

import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/di/components/service_locator.dart';
import 'package:boilerplate/models/rating/rating.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../data/network/constants/endpoints.dart';
import '../../widgets/simple_app_bar_widget.dart';
import '../store/widgets/rating_widget.dart';

class ListRatingScreen extends StatefulWidget {
  const ListRatingScreen();
  @override
  State<StatefulWidget> createState() => _ListRatingScreenState();
}

class _ListRatingScreenState extends State<ListRatingScreen> {
  final Repository _repository = getIt<Repository>();
  late PagewiseLoadController<Rating> _pagewiseLoadController;

  @override
  void initState() {
    super.initState();
    _pagewiseLoadController = PagewiseLoadController<Rating>(
        pageSize: 10,
        pageFuture: (pageIndex) => _repository.getRatings({
              "page": (pageIndex ?? 0) + 1,
              "item_per_page": 10,
            }));
    _pagewiseLoadController.addListener(() {
      if (this._pagewiseLoadController.hasMoreItems == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No More Items!'),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: "Recently reviews",
      ),
      body: Container(child: _buildMainContent()),
    );
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
        onRefresh: () async {
          _pagewiseLoadController.reset();
          await Future.value({});
        },
        child: PagewiseListView<Rating>(
          itemBuilder: _buildListItem,
          pageLoadController: _pagewiseLoadController,
          errorBuilder: (context, error) {
            print('error: $error');
            return Text('Error: $error');
          },
          showRetry: false,
          shrinkWrap: true,
        ));
  }

  Widget _buildListItem(context, Rating rating, _) {
    return Padding(
      padding: EdgeInsets.only(top: 0, bottom: 00, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      Endpoints.getDownloadUrl(rating.storeAvatar)),
                  // radius: 70,
                ),
              ),
              Expanded(
                child: MyLabelWidget(
                    text: rating.storeName ?? "",
                    style: AppStyles.textStyle14Medium,),
                flex: 3,
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Image.asset(
                  Assets.quoteIcon,
                  height: 20,
                  width: 20,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 40),
            child: Text(
              rating.comment,
              textAlign: TextAlign.left,
              style: TextStyle(height: 1.28),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RatingWidget(
                  rating: rating.star / 1,
                  starSize: 18,
                  hideRating: true,
                ),
                MyLabelWidget(
                    text: rating.userName ?? "",
                    style: AppStyles.textStyle14Regular),
              ],
            ),
          ),
          Divider(height: 7, color: AppColors.textGreyColor,)
        ],
      ),
    );
  }
}
