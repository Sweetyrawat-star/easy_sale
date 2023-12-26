import 'package:boilerplate/models/store/store.dart';
import 'package:boilerplate/widgets/app_simple_input_widget.dart';
import 'package:boilerplate/widgets/app_simple_label_widget.dart';
import 'package:boilerplate/widgets/simple_app_bar_widget.dart';
import 'package:boilerplate/widgets/primary_button_widget.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../../data/repository.dart';
import '../../di/components/service_locator.dart';
import '../../widgets/flash_message_widget.dart';
import '../../widgets/my_label_widget.dart';
import '../../widgets/common_dialog_widget.dart';

class CreateRoutingScreen extends StatefulWidget {
  final List<Store> shops;

  const CreateRoutingScreen({Key? key, required this.shops});

  @override
  State<StatefulWidget> createState() => _CreateRoutingScreenState();
}

class _CreateRoutingScreenState extends State<CreateRoutingScreen> {
  final Repository _repository = getIt<Repository>();
  TextEditingController _routingController = TextEditingController();
  late List<Store> _currentShops;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _currentShops = widget.shops;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Create routing",
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSimpleLabelWidget("Route name"),
            SizedBox(
              height: 10,
            ),
            AppSimpleInputWidget("Input route name",
                textController: _routingController),
            SizedBox(
              height: 10,
            ),
            AppSimpleLabelWidget("Store list"),
            SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 349,
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: 20,
                ),
                itemCount: _currentShops.length,
                itemBuilder: (BuildContext context, int index) {
                  var store = _currentShops[index];
                  return ListTile(
                    contentPadding: EdgeInsets.all(0),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _currentShops.remove(store);
                        setState(() {
                          _currentShops = [..._currentShops];
                        });
                      },
                    ),
                    title: MyLabelWidget(
                        text: store.name,
                        style: AppStyles.textStyle20RegularBold),
                    subtitle: MyLabelWidget(
                        text: store.address?.fullAddress ?? "",
                        style: AppStyles.textStyle16Regular400
                            .merge(TextStyle(color: AppColors.greyPrice))),
                  );
                },
              ),
            ),
            PrimaryButtonWidget(
              buttonWidth: MediaQuery.of(context).size.width - 40,
              buttonText: "Save",
              onPressed: () {
                if (_routingController.text.isEmpty) {
                  FlashMessageWidget.flashError(
                      context, "Pls input route name!");
                } else {
                  _repository.createRouting({
                    "name": _routingController.text,
                    "shop_ids": List<String>.from(_currentShops.map((e) => e.id))
                  }).then((_) {
                    CommonDialogWidget.success(
                        context,
                        "Create routing success!",
                        (p0) => {
                              Navigator.of(context).pop(true),
                            });
                  }).catchError((err) {
                    FlashMessageWidget.flashError(context, err.toString());
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
