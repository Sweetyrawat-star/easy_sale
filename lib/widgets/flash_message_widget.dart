import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class FlashMessageWidget extends StatelessWidget {
  FlashMessageWidget.flashError(BuildContext context, String message) {
    MotionToast.error(
        description:  Text(message)
    ).show(context);
  }

  FlashMessageWidget.flashSuccess(BuildContext context, String message) {
    MotionToast.success(
        description:  Text(message),
    ).show(context);
  }

  FlashMessageWidget.flashSuccessFromTop(BuildContext context, String message) {
    MotionToast.success(
      description:  Text(message),
      position:  MOTION_TOAST_POSITION.top,
      animationType: ANIMATION.fromTop,
    ).show(context);
  }

  FlashMessageWidget.flashInfo(BuildContext context, String message) {
    MotionToast.info(
        description:  Text(message)
    ).show(context);
  }

  FlashMessageWidget.flashWarning(BuildContext context, String message) {
    MotionToast.warning(
        description:  Text(message)
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
