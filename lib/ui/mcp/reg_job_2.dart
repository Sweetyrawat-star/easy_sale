import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:boilerplate/widgets/plus_button_widget.dart';
import 'package:boilerplate/widgets/simple_app_bar_widget.dart';
import 'package:boilerplate/widgets/common_dialog_widget.dart';
import 'package:boilerplate/widgets/primary_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../di/components/service_locator.dart';
import '../../stores/user/user_store.dart';
import '../../widgets/address_multi_select_widget.dart';
import '../../widgets/flash_message_widget.dart';

class RegisterJob2Screen extends StatefulWidget {
  final String channelId;
  final String categoryId;
  final List<dynamic> productBrandIds;

  const RegisterJob2Screen({
    Key? key,
    required this.channelId,
    required this.categoryId,
    required this.productBrandIds,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RegisterJob2ScreenState();
}

class LocationModel {
  List<String> ids;
  String name;

  LocationModel({
    required this.ids,
    required this.name,
  });

  static empty() {
    return LocationModel(ids: [], name: "");
  }
}

class _RegisterJob2ScreenState extends State<RegisterJob2Screen> {
  final Repository _repository = getIt<Repository>();
  late UserStore _userStore;
  late bool loading = false;
  late String provinceId = "0";
  late String districtId = "0";
  late String wardId = "0";
  late String provinceName = "";
  late String districtName = "";
  late String wardName = "";
  late List<LocationModel> _selectedLocations = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._userStore = Provider.of<UserStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(
          title: "Setup work areas",
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              height: MediaQuery.of(context).size.height -
                  AppDimens.primaryAppBarHeight -
                  50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyLabelWidget(
                    text:
                        'Select the area you will work in, you can add more (select and press "+" to add an area)',
                    style: AppStyles.textStyle16Regular400.merge(
                        TextStyle(color: AppColors.greyPrice, height: 1.375)),
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  AddressMultiSelectWidget(
                    onProvinceChanged: (id, name) => setState(() {
                      provinceId = id;
                      provinceName = name;
                      districtId = "";
                      districtName = "";
                    }),
                    onDistrictChanged: (id, name) => setState(() {
                      districtId = id;
                      districtName = name;
                      wardId = "0";
                      wardName = "";
                    }),
                    onWardChanged: (id, name) => setState(() {
                      wardId = id;
                      wardName = name;
                    }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PlusButtonWidget(onPressed: () {
                        if (provinceId == "0" || districtId == "0") {
                          FlashMessageWidget.flashError(context,
                              "Please select a Province and at least 1 District");
                        } else {
                          _addLocation();
                        }
                      })
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.only(top: 0, bottom: 10),
                        itemCount: _selectedLocations.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _locationItem(
                              _selectedLocations.length - index - 1);
                        }),
                  ),
                  PrimaryButtonWidget(
                    buttonWidth: MediaQuery.of(context).size.width - 40,
                    buttonText: "Submit",
                    onPressed: () {
                      if (_selectedLocations.length < 1) {
                        FlashMessageWidget.flashError(
                            context, "Pls select at least 1 work area");
                      } else {
                        var fn = _repository.registerJob;
                        if (_userStore.jobRegistered) {
                          fn = _repository.updateJob;
                        }
                        fn({
                          "channel": widget.channelId,
                          "channel_1": widget.categoryId,
                          "product_channel": widget.productBrandIds,
                          "area_ids": List.from(
                              _selectedLocations.map((elem) => elem.ids))
                        }).then((data) {
                          _userStore.jobRegistered = true;
                          CommonDialogWidget.success(
                              context,
                              "Register job successful",
                              (p0) => {
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst)
                                  });
                        }).catchError((err) {
                          FlashMessageWidget.flashError(
                              context, err.toString());
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            // Observer(
            //   builder: (context) {
            //     return Visibility(
            //       visible: _userStore.loading || loading,
            //       child: CustomProgressIndicatorWidget(),
            //     );
            //   },
            // )
          ],
        ));
  }

  Widget _locationItem(int index) {
    LocationModel model = _selectedLocations[index];
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      trailing: IconButton(
        icon: Icon(
          Icons.delete_outline,
          color: Colors.red,
        ),
        onPressed: () {
          _selectedLocations.remove(model);
          setState(() {
            _selectedLocations = [..._selectedLocations];
          });
        },
      ),
      title: Text('${_selectedLocations.length - index}. ' + model.name),
    );
  }

  dynamic _addLocation() {
    Iterable<LocationModel> districtDuplicateds = _selectedLocations.where(
        (element) =>
            element.ids.contains(provinceId) &&
            element.ids.contains(districtId) &&
            element.ids.length == 2);
    Iterable<LocationModel> districtDuplicateds2 = _selectedLocations.where(
        (element) =>
            element.ids.contains(provinceId) &&
            element.ids.contains(districtId) &&
            element.ids.length == 3);

    if (districtDuplicateds.length > 0) {
      return FlashMessageWidget.flashError(
          context, "Duplicate District or Ward, pls check again");
    }
    if (districtDuplicateds2.length > 0) {
      Iterable<LocationModel> wardDuplicateds =
          districtDuplicateds2.where((element) => element.ids.contains(wardId));
      if (wardDuplicateds.length > 0 || wardId == "0") {
        return FlashMessageWidget.flashError(
            context, "Duplicate District or Ward, pls check again");
      }
    }

    var ids = [provinceId, districtId];
    String locationText = '$districtName, $provinceName';
    if (wardId != "0") {
      ids.add(wardId);
      locationText = wardName + ', ' + locationText;
    }
    setState(() {
      _selectedLocations = [
        ..._selectedLocations,
        ...[LocationModel(ids: ids, name: locationText)]
      ];
    });
  }
}
