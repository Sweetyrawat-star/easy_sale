import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/models/order/order.dart';
import 'package:boilerplate/ui/cart/place_order_result.dart';
import 'package:boilerplate/widgets/app_simple_input_widget.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:boilerplate/widgets/simple_app_bar_widget.dart';
import 'package:boilerplate/widgets/primary_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../data/repository.dart';
import '../../di/components/service_locator.dart';
import '../../stores/visit/visit_store.dart';
import '../../utils/shared/nav_service.dart';
import '../../widgets/flash_message_widget.dart';
import '../../widgets/progress_indicator_widget.dart';
import '../order/man_order.dart';
import 'detail_cart.dart';

class ShipInfoScreen2 extends StatefulWidget {
  final List<CartModel> cartModels;

  ShipInfoScreen2({
    required this.cartModels,
  });

  @override
  State<StatefulWidget> createState() => _ShipInfoScreen2State();
}

class _ShipInfoScreen2State extends State<ShipInfoScreen2> {
  final Repository _repository = getIt<Repository>();
  late VisitStore _visitStore;
  TextEditingController _storeOwnerNameController = TextEditingController();
  TextEditingController _storeOwnerPhoneController = TextEditingController();
  late bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _storeOwnerNameController.dispose();
    _storeOwnerPhoneController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _visitStore = Provider.of<VisitStore>(context);
    if (_storeOwnerNameController.text.isEmpty && _storeOwnerPhoneController.text.isEmpty) {
      _storeOwnerNameController = TextEditingController(text: _visitStore.visit?.currentShop.name);
      _storeOwnerPhoneController = TextEditingController(text: _visitStore.visit?.currentShop.phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(
          title: "Shipping info",
          onBack: () {
            if (loading) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ManageOrderScreen()));
            } else {
              Navigator.pop(context);
            }
          },
        ),
        body: Stack(
          children: [
            _buildCheckedInBlock(),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 90),
                height: MediaQuery.of(context).size.height - 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyLabelWidget(
                      text: "Ship info",
                      style: AppStyles.textStyle18RegularBold,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    AppSimpleInputWidget(
                      "Receiver name",
                      textController: _storeOwnerNameController,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    AppSimpleInputWidget(
                      "Receiver phone",
                      textController: _storeOwnerPhoneController,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    MyLabelWidget(
                      text: "Receiver address(default and constraint is current checked in store)",
                      style: AppStyles.textStyle16Regular400,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    MyLabelWidget(
                      text: _visitStore.visit?.currentShop.shopAddress.fullAddress ?? "",
                      style: AppStyles.textStyle18RegularBold,
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
            Observer(
              builder: (context) {
                return Visibility(
                  visible: loading,
                  child: CustomProgressIndicatorWidget(),
                );
              },
            )
          ],
        ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  _buildBottomNavigationBar() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: PrimaryButtonWidget(
        buttonWidth: MediaQuery.of(context).size.width - 40,
        buttonText: "Confirm & Place Order",
        onPressed: () {
          if (
          _storeOwnerNameController.text.isEmpty ||
              _storeOwnerPhoneController.text.isEmpty) {
            FlashMessageWidget.flashError(
                context, "Pls input all fields!");
          } else {
            setState(() {
              loading = true;
            });
            Iterable<Future<Order>> orders = widget.cartModels.map((element) {
              var data = {
                "provider_id": element.providerId,
                "shop_id": _visitStore.visit?.currentShop.id,
                "payment_method": "COD",
                "recv_address": _visitStore.visit?.currentShop.shopAddress.toMap(),
                "items":
                List.from(element.items.map((element) => {
                  "variant_id": element.id,
                  "amount": element.qty,
                }))
              };
              return _repository.createOrder(data);
            });
            Future.wait(orders).then((value) {
              _placeOrder(List.from(value.map((e) => e.id)));
              setState(() {
                loading = false;
              });
              NavigationService.push(context, PlaceOrderResultScreen(orders: value));
            });
          }
        },
      ),
    );
  }

  void _placeOrder(List<String> orderIds) async {
    await _repository.addVisitAction({
      "visit_id": _visitStore.visit?.id,
      "type": "ORDER",
      "data": orderIds
    });
  }

  Widget _buildCheckedInBlock() {
    return Observer(builder: (_) =>
    _visitStore.checkedIn ? Container(
        height: 70,
        color: AppColors.checkedInBlockColor,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Image.asset(
                Assets.checkpointIcon,
                height: 30,
                width: 30,
              ),
              SizedBox(width: 10,),
              Expanded(
                child: MyLabelWidget(
                  text: "Current checked in store: " +
                      (_visitStore.visit?.currentShop.name ?? ""),
                  style: AppStyles.textStyle16Regular400,
                  maxLines: 2,
                ),
              )
            ],
          ),
        )) : SizedBox()
    );
  }
}
