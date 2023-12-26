import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/stores/visit/visit_store.dart';
import 'package:boilerplate/ui/cart/detail_cart.dart';
import 'package:boilerplate/ui/visit/checkin.dart';
import 'package:boilerplate/utils/shared/nav_service.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:boilerplate/widgets/simple_app_bar_widget.dart';
import 'package:boilerplate/widgets/common_dialog_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../data/network/constants/endpoints.dart';
import '../../data/repository.dart';
import '../../di/components/service_locator.dart';
import '../../models/store/store.dart';
import '../../models/visit/visit.dart';

class VisitScreen extends StatefulWidget {
  final Store? store;

  VisitScreen({
    Key? key,
    this.store,
  });

  @override
  State<StatefulWidget> createState() => _VisitScreenState();
}

class _VisitScreenState extends State<VisitScreen> {
  final Repository _repository = getIt<Repository>();
  late VisitStore _visitStore;
  VisitingShop? _currentShop;
  bool _isCurrentShop = false;

  final _works = [
    {"id": "checkin", "name": "Check in"},
    {"id": "order", "name": "Place Order"},
    {"id": "checkout", "name": "Check out"}
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _visitStore = Provider.of<VisitStore>(context);
    if (_visitStore.checkedIn) {
      setState(() {
        _currentShop = _visitStore.visit?.currentShop;
      });
    } else if (widget.store != null) {
      setState(() {
        _currentShop = VisitingShop(
          id: widget.store?.id ?? "",
          name: widget.store?.name ?? "",
          phone: widget.store?.phone ?? "",
          address: widget.store?.address?.fullAddress ?? "",
          avatar: widget.store?.avatar ?? "",
          shopAddress: widget.store?.address ?? Address.empty(),
        );
      });
    }
    if (widget.store == null || widget.store?.id == _currentShop?.id) {
      setState(() {
        _isCurrentShop = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(
          title: "Check in",
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 20, right: 20),
                height: MediaQuery.of(context).size.height - 111,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyLabelWidget(
                      text: "Current store",
                      style: AppStyles.textStyle24Medium,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    !_isCurrentShop
                        ? Container(
                            height: 50,
                            child: MyLabelWidget(
                              text:
                                  "You are check in another store, pls check out it first!",
                              style: AppStyles.textStyle16Regular400.merge(
                                  TextStyle(color: AppColors.redLightColor)),
                            ),
                          )
                        : SizedBox(),
                    Container(
                      height: 111,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: AppColors.bgGreyColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  Endpoints.getDownloadUrl(
                                      _currentShop?.avatar)),
                              radius: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  MyLabelWidget(
                                      text: _currentShop?.name ?? "",
                                      style: AppStyles.textStyle16Regular400),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  MyLabelWidget(
                                      maxLines: 2,
                                      text: _currentShop?.address ?? "",
                                      style: AppStyles.textStyle16Regular400
                                          .merge(TextStyle(
                                              color: AppColors.greyPrice)))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    MyLabelWidget(
                        text: "List of works need to do",
                        style: AppStyles.textStyle16Medium),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - 350,
                      child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(
                                height: 20,
                              ),
                          itemCount: _works.length,
                          itemBuilder: _buildWorkItem),
                    )
                  ],
                ),
              ),
            ),
            // Observer(
            //   builder: (context) {
            //     return Visibility(
            //       visible: _storeStore.loading || loading,
            //       child: CustomProgressIndicatorWidget(),
            //     );
            //   },
            // )
          ],
        ));
  }

  Widget _buildWorkItem(BuildContext context, int index) {
    var work = _works[index];
    return Observer(builder: (_) {
      Visit? visit = _visitStore.visit;
      bool stepped = visit != null && visit.stepVisited(work["id"] ?? "");
      return Container(
        padding: EdgeInsets.all(20),
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: stepped ? AppColors.lineGreyColor : AppColors.bgLightBlue,
        ),
        child: InkWell(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyLabelWidget(
                          text: work["name"] ?? "",
                          style: AppStyles.textStyle16Regular400)
                    ],
                  )
                ],
              ),
              !stepped
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(Assets.greaterIcon, width: 11.0)
                          ],
                        ),
                      ],
                    )
                  : SizedBox()
            ],
          ),
          onTap: () {
            if (work["id"] == "checkin") {
              if (!stepped) {
                NavigationService.push(
                    context, CheckinScreen(store: _currentShop!));
              }
            } else if (work["id"] == "order") {
              NavigationService.push(context, DetailCartScreen());
            } else if (work["id"] == "checkout") {
              CommonDialogWidget.confirmDialog(
                  context,
                  "Confirmation",
                  "Are you sure you want to CHECK OUT of this store?",
                  "Yes",
                  "No", () {
                _checkout().then((data) {
                  _visitStore.checkout();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                });
              });
            }
          },
        ),
      );
    });
  }

  Future<void> _checkout() async {
    return _repository.addVisitAction({
      "visit_id": _visitStore.visit?.id,
      "type": "CHECKOUT",
    });
  }
}
