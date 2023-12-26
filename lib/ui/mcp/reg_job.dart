import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/ui/mcp/reg_job_2.dart';
import 'package:boilerplate/ui/mcp/widgets/channel_multi_select_widget.dart';
import 'package:boilerplate/utils/shared/nav_service.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:boilerplate/widgets/simple_app_bar_widget.dart';
import 'package:boilerplate/widgets/primary_button_widget.dart';
import 'package:flutter/material.dart';

import '../../widgets/flash_message_widget.dart';
import '../../widgets/progress_indicator_widget.dart';

class RegisterJobScreen extends StatefulWidget {
  const RegisterJobScreen();
  @override
  State<StatefulWidget> createState() => _RegisterJobScreenState();
}

class _RegisterJobScreenState extends State<RegisterJobScreen> {
  late bool loading = false;
  late String channel = "0";
  late String channel1 = "0";
  late String channel2 = "0";
  late String channel21 = "0";
  late String channel22 = "0";
  late String brand = "0";
  late String brand1 = "0";
  late String brand2 = "0";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(
          title: "Job registration",
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                height: MediaQuery.of(context).size.height -
                    AppDimens.primaryAppBarHeight -
                    50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyLabelWidget(
                      text:
                          "Select information about the goods you are in charge of to register the job profile.",
                      style: AppStyles.textStyle16Regular400.merge(
                          TextStyle(color: AppColors.greyPrice, height: 1.375)),
                    ),
                    SizedBox(
                      height: 21,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height -
                          AppDimens.primaryAppBarHeight - 181,
                      child: ChannelMultiSelectWidget(
                        onChannelChanged: (id) => setState(() {
                          channel = id;
                        }),
                        onChannel1Changed: (id) => setState(() {
                          channel1 = id;
                        }),
                        onChannel2Changed: (id) => setState(() {
                          channel2 = id;
                        }),
                        onChannel21Changed: (id) => setState(() {
                          channel21 = id;
                        }),
                        onChannel22Changed: (id) => setState(() {
                          channel22 = id;
                        }),
                        onBrandChanged: (id) => setState(() {
                          brand = id;
                        }),
                        onBrand1Changed: (id) => setState(() {
                          brand1 = id;
                        }),
                        onBrand2Changed: (id) => setState(() {
                          brand2 = id;
                        }),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Expanded(child: SizedBox()),
                    PrimaryButtonWidget(
                      buttonWidth: MediaQuery.of(context).size.width - 40,
                      buttonText: "Next step",
                      onPressed: () {
                        if (channel == "0" || channel1 == "0") {
                          FlashMessageWidget.flashError(
                              context, "Pls select distribution channel and category level 1");
                        } else if ((channel2 != "0" && brand != "0")
                            || (channel21 != "0" && brand1 != "0")
                            || (channel22 != "0" && brand2 != "0")) {
                          _choiceLocation();
                        } else {
                          FlashMessageWidget.flashError(
                              context, "Pls select at least 1 category and 2 brands");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
                  visible: loading,
                  child: CustomProgressIndicatorWidget(),
                )
          ],
        ));
  }

  void _choiceLocation() {
    var tmp = [];
    if (channel2 != "0" && brand != "0") {
      tmp.add({
        "channel_2": channel2,
        "brand": List<String>.from([brand])
      });
    }
    if (channel21 != "0" && brand1 != "0") {
      tmp.add({
        "channel_2": channel21,
        "brand": List<String>.from([brand1])
      });
    }
    if (channel22 != "0" && brand2 != "0") {
      tmp.add({
        "channel_2": channel22,
        "brand": List<String>.from([brand2])
      });
    }
    NavigationService.push(context, RegisterJob2Screen(
      channelId: channel,
      categoryId: channel1,
      productBrandIds: tmp,
    ));
  }
}
