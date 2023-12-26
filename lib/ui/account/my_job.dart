
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/job/job.dart';
import 'package:boilerplate/ui/mcp/reg_job.dart';
import 'package:boilerplate/utils/shared/nav_service.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:boilerplate/widgets/simple_app_bar_widget.dart';
import 'package:boilerplate/widgets/register_required_screen_widget.dart';
import 'package:flutter/material.dart';

import '../../di/components/service_locator.dart';
import '../../widgets/progress_indicator_widget.dart';

class MyJobScreen extends StatefulWidget {
  const MyJobScreen();
  @override
  State<StatefulWidget> createState() => _MyJobScreenState();
}

class _MyJobScreenState extends State<MyJobScreen> {
  final Repository _repository = getIt<Repository>();
  MyJob? _myJob;
  bool _noJob = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _repository.getJob().then((data) {
      setState(() {
        _myJob = data;
      });
    }).catchError((err){
      print(err);
      setState(() {
        _noJob = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Job information",
        rightButton: _myJob != null ? InkWell(
          child: Icon(Icons.edit, color: Theme.of(context).primaryColor,),
          onTap: () {
            Navigator.pop(context);
            NavigationService.push(context, RegisterJobScreen());
          },
        ) : null,
      ),
      body: _myJob != null
          ? SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: _mainData(),
              ),
            )
          : Center(
              child: !_noJob ? CustomProgressIndicatorWidget() : RegisterRequiredScreenWidget(
                height: MediaQuery.of(context).size.height - AppDimens.primaryAppBarHeight,
                width: MediaQuery.of(context).size.width,
                onPressed: () {
                  NavigationService.push(context, RegisterJobScreen());
                },
              ),
            ),
    );
  }

  Widget _mainData() {
    return Column(
      children: [
        MyLabelWidget(
          text: "Distribution channel",
          style: AppStyles.textStyle16Regular400,
        ),
        SizedBox(height: 10),
        MyLabelWidget(
          text: _myJob!.channel.name,
          style: AppStyles.textStyle20RegularBold,
        ),
        SizedBox(height: 20),
        MyLabelWidget(
          text: "Category level 1",
          style: AppStyles.textStyle16Regular400,
        ),
        SizedBox(height: 10),
        MyLabelWidget(
          text: _myJob!.channel1.name,
          style: AppStyles.textStyle20RegularBold,
        ),
        SizedBox(height: 20),
        _getProductChannel(),
        SizedBox(height: 20),
        MyLabelWidget(
          text: "Work areas",
          style: AppStyles.textStyle16Regular400,
        ),
        SizedBox(height: 10),
        _getLocation()
      ],
    );
  }

  Widget _getProductChannel() {
    return Container(
      height: _myJob!.productChannel.length * 150 + 10,
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        itemCount: _myJob!.productChannel.length,
        itemBuilder: (BuildContext context, int index) {
          var channel = _myJob!.productChannel[index].channel2;
          var brand = _myJob!.productChannel[index].brands[0];
          return Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                MyLabelWidget(
                  text: "Category level 2",
                  style: AppStyles.textStyle16Regular400,
                ),
                SizedBox(height: 10),
                MyLabelWidget(
                  text: channel.name,
                  style: AppStyles.textStyle20RegularBold,
                  maxLines: 2,
                ),
                SizedBox(height: 10),
                MyLabelWidget(
                  text: "Brand in charge",
                  style: AppStyles.textStyle16Regular400,
                ),
                SizedBox(height: 10),
                MyLabelWidget(
                  text: brand.name,
                  style: AppStyles.textStyle20RegularBold,
                  maxLines: 2,
                )
              ],
            ),
          );
        }, separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 20,); },
      ),
    );
  }

  Widget _getLocation() {
    return Container(
      height: _myJob!.areas.length * 80,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: _myJob!.areas.length,
        itemBuilder: (BuildContext context, int index) {
          var area = _myJob!.areas[index];
          var province = area.firstWhere((element) => element.type == "province");
          var district = area.firstWhere((element) => element.type == "district");
          var ward = area.firstWhere((element) => element.type == "ward", orElse: () => JobArea(name: "", type: ""));
          var str = district.name + ', ' + province.name;
          if (ward.name != "") {
            str = ward.name + ', ' + str;
          }
          return Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyLabelWidget(
                  text: (index+1).toString() + '. ' + str,
                  style: AppStyles.textStyle16Medium,
                  maxLines: 3,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
