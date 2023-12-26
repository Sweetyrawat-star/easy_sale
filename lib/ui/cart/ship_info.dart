import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/widgets/app_simple_input_widget.dart';
import 'package:boilerplate/widgets/simple_app_bar_widget.dart';
import 'package:boilerplate/widgets/primary_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repository.dart';
import '../../di/components/service_locator.dart';
import '../../models/store/store.dart';
import '../../stores/cart/cart_store.dart';
import '../../widgets/address_multi_select_widget.dart';
import '../../widgets/common_dialog_widget.dart';
import '../../widgets/flash_message_widget.dart';
import '../../widgets/my_label_widget.dart';
import 'detail_cart.dart';

class ShipInfoScreen extends StatefulWidget {
  final List<CartModel> cartModels;

  ShipInfoScreen({
    required this.cartModels,
  });

  @override
  State<StatefulWidget> createState() => _ShipInfoScreenState();
}

class _ShipInfoScreenState extends State<ShipInfoScreen> {
  final Repository _repository = getIt<Repository>();
  late CartStore _cartStore;
  TextEditingController _storeOwnerNameController = TextEditingController();
  TextEditingController _storeOwnerPhoneController = TextEditingController();
  TextEditingController _storeAddressController = TextEditingController();
  late bool loading = false;
  late String provinceId;
  late String districtId;
  late String wardId;

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
    _storeAddressController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartStore = Provider.of<CartStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(
          title: "Thông tin giao hàng",
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                height: MediaQuery.of(context).size.height - 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyLabelWidget(
                      text: "Địa chỉ nhận hàng",
                      style: AppStyles.textStyle18RegularBold,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    AddressMultiSelectWidget(
                      onProvinceChanged: (id, name) => setState(() {
                        provinceId = id;
                      }),
                      onDistrictChanged: (id, name) => setState(() {
                        districtId = id;
                      }),
                      onWardChanged: (id, name) => setState(() {
                        wardId = id;
                      }),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    AppSimpleInputWidget(
                      "Số nhà, tên đường",
                      textController: _storeAddressController,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    AppSimpleInputWidget(
                      "Tên người nhận",
                      textController: _storeOwnerNameController,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    AppSimpleInputWidget(
                      "Số điện thoại người nhận",
                      textController: _storeOwnerPhoneController,
                    ),
                    Expanded(child: SizedBox()),
                    PrimaryButtonWidget(
                      buttonWidth: MediaQuery.of(context).size.width - 40,
                      buttonText: "Xác nhận & đặt hàng",
                      onPressed: () {
                        if (provinceId == "0" ||
                            districtId == "0" ||
                            wardId == "0" ||
                            _storeOwnerNameController.text.isEmpty ||
                            _storeOwnerPhoneController.text.isEmpty ||
                            _storeAddressController.text.isEmpty) {
                          FlashMessageWidget.flashError(
                              context, "Vui lòng nhập tất cả thông tin");
                        } else {
                          var address = new Address(
                              areaIds: [wardId, districtId, provinceId],
                              detail: _storeAddressController.text);
                          widget.cartModels.forEach((element) {
                            var data = {
                              "shop_id": "sh_caf1smq014mclfhjl17g",
                              "payment_method": "COD",
                              "recv_address": address.toMap(),
                              "items":
                                  List.from(element.items.map((element) => {
                                        "variant_id": element.id,
                                        "amount": element.qty,
                                      }))
                            };
                            _repository.createOrder(data).then((value) {
                              _cartStore.emptyCart();
                              CommonDialogWidget.success(
                                  context,
                                  "Đặt hàng thành công",
                                  (p0) => {
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst)
                                      });
                            }).catchError((e) {
                              print(e);
                            });
                          });
                        }
                      },
                    ),
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
}
