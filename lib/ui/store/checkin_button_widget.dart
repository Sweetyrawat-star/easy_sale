import 'package:boilerplate/models/store/store.dart';
import 'package:boilerplate/stores/visit/visit_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../models/visit/visit.dart';
import '../../utils/shared/nav_service.dart';
import '../../widgets/rounded_button_widget.dart';
import '../visit/visit_screen.dart';

class CheckInButtonWidget extends StatelessWidget {
  final Store store;

  const CheckInButtonWidget({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VisitStore _visitStore = Provider.of<VisitStore>(context);
    Visit? visit = _visitStore.visit;
    bool sameShop = _visitStore.checkedIn && visit?.currentShop.id == store.id;
    return sameShop ? RoundedButtonWidget(
      buttonWidth: 110,
      buttonHeight: 30,
      buttonText: "Đang Visit",
      linearGradient: LinearGradient(
          colors: [AppColors.btnBuyNowColor, AppColors.btnBuyNowColor]),
      onPressed: () {
        NavigationService.push(context, VisitScreen(store: store));
      },
    ) : RoundedButtonWidget(
      buttonWidth: 100,
      buttonHeight: 30,
      buttonText: "Check In",
      onPressed: () {
        NavigationService.push(context, VisitScreen(store: store));
      },
    );
  }
}
