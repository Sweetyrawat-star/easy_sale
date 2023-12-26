import 'package:boilerplate/constants/assets.dart';
import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/rating/rating.dart';
import 'package:boilerplate/ui/comment/review_comment.dart';
import 'package:boilerplate/ui/store/checkin_button_widget.dart';
import 'package:boilerplate/ui/store/widgets/address_view_widget.dart';
import 'package:boilerplate/ui/store/widgets/phone_view_widget.dart';
import 'package:boilerplate/utils/shared/nav_service.dart';
import 'package:boilerplate/widgets/closepopup_icon_widget.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:boilerplate/ui/store/widgets/rating_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../data/network/constants/endpoints.dart';
import '../../di/components/service_locator.dart';
import '../../models/rating/rating_list.dart';
import '../../models/store/store.dart';
import '../../widgets/gallery_photo_view_item_widget.dart';
import '../../widgets/gallery_photo_view_widget.dart';
import '../../widgets/progress_indicator_widget.dart';

class DetailStoreScreen extends StatefulWidget {
  final String storeId;

  DetailStoreScreen({required this.storeId});

  @override
  State<StatefulWidget> createState() => _DetailStoreScreenState();
}

class _DetailStoreScreenState extends State<DetailStoreScreen> {
  final Repository _repository = getIt<Repository>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          FutureBuilder(
            future: _repository.getStore(widget.storeId),
            builder:
            ((context, AsyncSnapshot<Store> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.done) {
                  var _store = snapshot.data;
                  return Column(
                    children: [
                      InkWell(
                        child: Container(
                          height: 252,
                          width: MediaQuery.of(context).size.width,
                          child: CachedNetworkImage(
                            imageUrl: Endpoints.getDownloadUrl(_store?.avatar),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        onTap: () {
                          NavigationService.push(
                              context,
                              GalleryPhotoViewWrapper(
                                galleryItems: _buildImageGallery(_store!),
                                backgroundDecoration: const BoxDecoration(
                                  color: Colors.black,
                                ),
                                initialIndex: 0,
                                scrollDirection: Axis.horizontal,
                              ));
                        },
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyLabelWidget(
                                text: _store?.name ?? "",
                                style: AppStyles.textStyle18Medium
                                    .merge(TextStyle(height: 1.333))),
                            SizedBox(
                              height: 15,
                            ),
                            AddressViewWidget(
                                addressText: _store?.address?.fullAddress ?? ""),
                            SizedBox(
                              height: 5,
                            ),
                            PhoneViewWidget(
                                phoneText: _store?.phone ?? ""),
                            SizedBox(
                              height: 15,
                            ),
                            MyLabelWidget(
                                text: _store?.desc ?? "",
                                style: AppStyles.textStyle14Regular
                                    .merge(TextStyle(height: 1.43))),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(""),
                                CheckInButtonWidget(store: _store!)
                              ],
                            )
                          ],
                        ),
                      ),
                      Divider(thickness: 7.0, color: AppColors.bgGreyColor),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      RatingWidget(
                                        rating: _store.star?.average ?? 0,
                                        starSize: 18,
                                        textStyle: AppStyles.textStyle14Medium.merge(
                                            TextStyle(color: AppColors.textGreyColor)),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      MyLabelWidget(
                                          text:
                                          '(${_store.star?.total ?? 0} reviews)',
                                          style: AppStyles.textStyle14Medium.merge(
                                              TextStyle(
                                                  color: AppColors.textGreyColor)))
                                    ],
                                  ),
                                  Image.asset(
                                    Assets.greaterIcon,
                                    height: 18,
                                  )
                                ],
                              ),
                              onTap: () {
                                _showRating(_store);
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height - 573,
                              child: FutureBuilder(
                                future: _repository.getFeedbacks({
                                  "page": 1,
                                  "item_per_page": 5,
                                  "shop_id": _store.id
                                }),
                                builder:
                                ((context, AsyncSnapshot<RatingList> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return (snapshot.data?.ratings.length == 0)
                                          ? Center(
                                        child: MyLabelWidget(
                                          text: "No reviews yet!",
                                          style: AppStyles.textStyle14Regular
                                              .merge(TextStyle(
                                              color:
                                              AppColors.greyPrice)),
                                        ),
                                      )
                                          : ListView.builder(
                                        itemCount:
                                        snapshot.data?.ratings.length ??
                                            0 + 1,
                                        itemBuilder: ((context, index) =>
                                            _itemBuilder(
                                              list: snapshot.data?.ratings,
                                              index: index,
                                            )),
                                        padding: EdgeInsets.only(top: 0),
                                      );
                                    } else {
                                      return CustomProgressIndicatorWidget();
                                    }
                                  } else {
                                    return CustomProgressIndicatorWidget();
                                  }
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return CustomProgressIndicatorWidget();
                }
              } else {
                return CustomProgressIndicatorWidget();
              }
            }),
          ),
          Container(
            padding: EdgeInsets.only(
                top: 50, left: MediaQuery.of(context).size.width - 50),
            child: ClosePopupIconWidget(
              onTap: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _itemBuilder({List<Rating>? list, required int index}) {
    Rating _rating = list![index];
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 0, top: 10, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.bgGreyColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
                radius: 25,
                backgroundImage: CachedNetworkImageProvider(
                  Endpoints.getDownloadUrl(_rating.userAvatar),
                )),
            SizedBox(
              width: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: MyLabelWidget(
                          text: _rating.userName ?? "",
                          style: AppStyles.textStyle16Medium
                              .merge(TextStyle(height: 1.57))
                      ), flex: 2,),
                      MyLabelWidget(
                          text: _rating.createdAt != null ? new DateFormat('HH:mm dd/MM/yyyy').format(
                              DateTime.fromMicrosecondsSinceEpoch(_rating.createdAt!)) : "",
                          style: AppStyles.textStyle14Medium
                              .merge(TextStyle(height: 1.57, color: AppColors.textGreyColor))//
                      ),
                    ],
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width - 110,
                      child: MyLabelWidget(
                        text: _rating.comment,
                        style: AppStyles.textStyle14Regular.merge(TextStyle(
                            height: 1.43, color: AppColors.textGreyColor)),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showRating(Store store) {
    NavigationService.push(
        context,
        ReviewAndCommentScreen(store: store)
    );
  }

  _buildImageGallery(Store store) {
    List<GalleryExampleItem> list = [];
    var total = store.images.length;
    for (var i = 0; i < total; i++) {
      list.add(GalleryExampleItem(
        id: "img" + i.toString(),
        resource: Endpoints.getDownloadUrl(store.images[i]),
      ));
    }
    return list;
  }
}
