import 'package:flutter/material.dart';

import '../../models/order/order.dart';
import '../../widgets/my_stepper_widget.dart';

class OrderTrackingWidget extends StatelessWidget {
  final Order orderDetail;

  OrderTrackingWidget({
    Key? key,
    required this.orderDetail,
  });


  @override
  Widget build(BuildContext context) {
    bool isConfirmed = ["verified", "shipped", "delivered"].contains(orderDetail.status);
    bool isShipping = ["shipped", "delivered"].contains(orderDetail.status);
    bool isSuccess = ["delivered", ].contains(orderDetail.status);
    bool isFailed = ["canceled", "returned"].contains(orderDetail.status);

    final List<Step> steps = [
      Step(
        title: Text('Waiting for confirmation'),
        content: Text(''),
        state: StepState.complete,
        isActive: true,
      ),
    ];

    if (["canceled", "returned"].contains(orderDetail.status)) {
      steps.add(Step(
        title: Text('Canceled/Returned'),
        content: Text(''),
        state: isFailed ? StepState.complete : StepState.disabled,
        isActive: isFailed,
      ));
    } else {
      steps.addAll([
        Step(
          title: Text('Confirmed'),
          content: Text(''),
          state: isConfirmed ? StepState.complete : StepState.disabled,
          isActive: isConfirmed,
        ),
        Step(
          title: Text('Shipped'),
          content: Text(''),
          state: isShipping ? StepState.complete : StepState.disabled,
          isActive: isShipping,
        ),
        Step(
          title: Text('Delivery successful'),
          content: Text('fsdfsd'),
          state: isSuccess ? StepState.complete : StepState.disabled,
          isActive: isSuccess,
        ),
      ]);
    }

    return Container(
        child: MyStepper(
          currentStep: ["canceled", "returned"].contains(orderDetail.status) ? 1 : 3,
          steps: steps,
          type: StepperType.vertical,
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Container(
              color: Colors.red
            );
          },
        ),
      );
  }
}