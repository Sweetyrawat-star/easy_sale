
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/routing/routing_detail.dart';
import 'package:boilerplate/ui/store/checkin_button_widget.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:boilerplate/widgets/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';

import '../../di/components/service_locator.dart';
import '../../widgets/progress_indicator_widget.dart';

class DetailRoutingScreen extends StatefulWidget {
  final String routingId;

  const DetailRoutingScreen({Key? key, required this.routingId});
  @override
  State<StatefulWidget> createState() => _DetailRoutingScreenState();
}

class _DetailRoutingScreenState extends State<DetailRoutingScreen> {
  final Repository _repository = getIt<Repository>();
  RoutingDetail? _routing;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _repository.getRouting(widget.routingId).then((data) {
      setState(() {
        _routing = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: _routing?.routing.title ?? "",
        rightButton: InkWell(
          child: Icon(
            Icons.delete_outline,
            color: Colors.red,
          ),
          onTap: () {},
        ),
      ),
      body: _routing != null
          ? Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyLabelWidget(
                    text: "Stores in this route",
                    style: AppStyles.textStyle16Regular400.merge(
                        TextStyle(color: AppColors.greyPrice, height: 1.375)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 165,
                    child: ListView.builder(
                      itemCount: _routing?.stores.length,
                      itemBuilder: (BuildContext context, int index) {
                        var store = _routing?.stores[index];
                        return Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyLabelWidget(
                                  text: store?.name ?? "",
                                  style: AppStyles.textStyle20RegularBold),
                              SizedBox(
                                height: 5,
                              ),
                              MyLabelWidget(
                                  text: store?.address?.fullAddress ?? "",
                                  style: AppStyles.textStyle16Regular400.merge(
                                      TextStyle(color: AppColors.greyPrice))),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(""),
                                  CheckInButtonWidget(store: store!)
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CustomProgressIndicatorWidget(),
            ),
    );
  }
}
