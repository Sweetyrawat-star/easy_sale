import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/stores/visit/visit_store.dart';
import 'package:boilerplate/ui/store/images_picker_widget.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:boilerplate/widgets/simple_app_bar_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../data/network/constants/endpoints.dart';
import '../../data/repository.dart';
import '../../di/components/service_locator.dart';
import '../../models/visit/visit.dart';
import '../../widgets/flash_message_widget.dart';
import '../../widgets/common_dialog_widget.dart';
import '../../widgets/primary_button_widget.dart';

class CheckinScreen extends StatefulWidget {
  final VisitingShop store;

  CheckinScreen({
    Key? key,
    required this.store,
  });

  @override
  State<StatefulWidget> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  final Repository _repository = getIt<Repository>();
  late VisitStore _visitStore;
  List<String> images = [];

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
                height: MediaQuery.of(context).size.height - 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyLabelWidget(
                      text: "Check in to store",
                      style: AppStyles.textStyle24Medium,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Container(
                      height: 111,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: AppColors.bgGreyColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  Endpoints.getDownloadUrl(
                                      widget.store.avatar)),
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
                                      text: widget.store.name,
                                      style: AppStyles.textStyle16Regular400),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  MyLabelWidget(
                                      maxLines: 2,
                                      text: widget.store.address,
                                      style: AppStyles.textStyle16Regular400
                                          .merge(TextStyle(
                                              color: AppColors.greyPrice)))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    MyLabelWidget(
                        text: "Upload store's images",
                        style: AppStyles.textStyle16Regular400),
                    SizedBox(
                      height: 20,
                    ),
                    ImagesPickerWidget(
                      onImageChange: (imgs) {
                        setState(() {
                          images =
                              List.from(imgs.sublist(1).map((e) => e.name));
                        });
                        print("images: " + images.join(", "));
                      },
                    ),
                    Expanded(
                      child: SizedBox(),
                      flex: 1,
                    ),
                    PrimaryButtonWidget(
                      buttonWidth: MediaQuery.of(context).size.width - 40,
                      buttonText: "Submit",
                      onPressed: () {
                        if (images.length < 1) {
                          FlashMessageWidget.flashError(
                              context, "Pls take at least one picture");
                        } else {
                          _createCheckinData(context);
                        }
                      },
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

  Future<void> _createCheckinData(BuildContext context) async {
    try {
      var visitCreated = await _repository.createVisit({"shop_id": widget.store.id});
      await _repository.addVisitAction({
        "visit_id": visitCreated["id"],
        "type": "CHECKIN",
        "data": images
      });
      _visitStore.visit = new Visit(
        id: visitCreated["id"],
        checkinImgs: images,
        currentShop: widget.store,
      );
      CommonDialogWidget.success(
        context,
        "Check in successful",
            (p0) => {Navigator.pop(context)},
      );
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
