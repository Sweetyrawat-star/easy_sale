import 'dart:async';

import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/di/components/service_locator.dart';
import 'package:boilerplate/ui/store/detail_store.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:boilerplate/ui/store/widgets/rating_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../models/store/store.dart';
import '../../utils/shared/nav_service.dart';
import '../../widgets/search_header_widget.dart';
import '../routing/create_routing.dart';
import '../visit/visit_screen.dart';
import 'create_store.dart';

const IconData arrow_forward =
    IconData(0xe09c, fontFamily: 'MaterialIcons', matchTextDirection: true);

class StoreChoiceModel {
  Store store;
  bool active;

  StoreChoiceModel({
    required this.store,
    required this.active,
  });
}

class ListStoreScreen extends StatefulWidget {
  final TabController? tabController;

  const ListStoreScreen({Key? key, this.tabController});
  @override
  State<StatefulWidget> createState() => _ListStoreScreenState();
}

class _ListStoreScreenState extends State<ListStoreScreen> {
  final Repository _repository = getIt<Repository>();
  late List<StoreChoiceModel> currentStores = [];
  late PagewiseLoadController<Store> _pagewiseLoadController;
  late String searchKey = "";
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _pagewiseLoadController = PagewiseLoadController<Store>(
        pageSize: 10,
        pageFuture: (pageIndex) => _repository.getStores2({
              "page": (pageIndex ?? 0) + 1,
              "item_per_page": 10,
              "keyword": searchKey
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SearchHeaderWidget(
            hintText: "Search",
            onPlus: () {
              var _selected = currentStores.where((element) => element.active);
              if (_selected.length > 0) {
                NavigationService.push(
                  context,
                  CreateRoutingScreen(
                    shops: List<Store>.from(
                      _selected.map((e) => e.store),
                    ),
                  ),
                ).then((data) {
                });
              } else {
                NavigationService.push(context, CreateStoreScreen())
                    .then((data) {
                  _pagewiseLoadController.reset();
                });
              }
            },
            onSearch: (keyword) {
              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                setState(() {
                  searchKey = keyword;
                });
                _pagewiseLoadController.reset();
              });
            },
            totalSelectedShop:
                currentStores.where((element) => element.active == true).length,
          ),
          Container(
            height: MediaQuery.of(context).size.height - 323,
            child: _buildMainContent(),
          )
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
        onRefresh: () async {
          _pagewiseLoadController.reset();
          await Future.value({});
        },
        child: PagewiseListView<Store>(
          itemBuilder: _buildListItem,
          pageLoadController: _pagewiseLoadController,
          errorBuilder: (context, error) {
            print('error: $error');
            return Text('Error: $error');
          },
          showRetry: false,
        ));
  }

  Widget _buildListItem(context, Store store, int _) {
    var _store = currentStores.where((element) => element.store.id == store.id);
    if (_store.length < 1) {
      currentStores.add(new StoreChoiceModel(store: store, active: false));
    }

    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        height: 122.0,
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
            color: AppColors.bgGreyColor,
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyLabelWidget(
                          text: store.name,
                          style: AppStyles.textStyle18Medium
                              .merge(TextStyle(height: 1.25))),
                      InkWell(
                        child: MyLabelWidget(text: "Checkin", style: AppStyles.textStyle16Regular400
                            .merge(TextStyle(color: AppColors.green[500]))),
                        onTap: () {
                          NavigationService.push(context, VisitScreen(store: store));
                        },
                      ),
                    ],
                  ),
                  RatingWidget(
                    hideRating: true,
                    rating: store.star?.average ?? 0,
                    starSize: 18,
                    textStyle: AppStyles.textStyle16Regular400
                        .merge(TextStyle(color: AppColors.greyPrice)),
                  ),
                ],
              ),
              onTap: () {
                NavigationService.push(
                    context,
                    DetailStoreScreen(
                      storeId: store.id,
                    )).then((value) => {
                      if (value == true) {_pagewiseLoadController.reset()}
                    });
              },
            ),
            InkWell(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      Assets.locationIcon,
                      height: 24,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 2,
                      child: MyLabelWidget(
                          text: store.address?.fullAddress ?? "",
                          style: AppStyles.textStyle16Regular400
                              .merge(TextStyle(color: AppColors.greyPrice))),
                    ),
                    _getStoreChoice(_),
                  ]),
              onTap: () {
                _updateSelectedStore(_);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getStoreChoice(int index) {
    StoreChoiceModel model = currentStores[index];
    return Image.asset(
      model.active ? Assets.checkedIcon : Assets.uncheckIcon,
      height: 22,
    );
  }

  void _updateSelectedStore(int index) {
    var tmp = currentStores;
    StoreChoiceModel model = currentStores[index];
    model.active = !model.active;
    tmp[index] = model;
    setState(() {
      currentStores = tmp;
    });
    // var selectedStores = currentStores.where((element) => element.active == true);
    // if (selectedStores.length > 0) {
    //   CommonDialogWidget.bottomDialog(
    //       context,
    //       '${selectedStores.length} điểm bán đã được chọn',
    //       'Nhấn "Tạo tuyến đường" để tạo tuyến đường với ${selectedStores.length} điểm bán đã chọn',
    //           (p0) => () {});
    // }
  }
}
