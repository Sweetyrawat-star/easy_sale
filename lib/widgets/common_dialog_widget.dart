import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

import '../constants/assets.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';
import 'confirm_dialog_widget.dart';

class CommonDialogWidget extends StatelessWidget {
  final String titleText;
  final TextStyle titleStyle;
  final Color headerColor;
  final Color backgroundColor;
  final children;

  const CommonDialogWidget({
    Key? key,
    required this.titleText,
    required this.titleStyle,
    required this.headerColor,
    required this.backgroundColor,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialDialog(
      borderRadius: 5.0,
      enableFullWidth: true,
      title: Text(
        this.titleText,
        style: this.titleStyle,
      ),
      headerColor: this.headerColor,
      backgroundColor: this.backgroundColor,
      closeButtonColor: Colors.white,
      enableCloseButton: true,
      enableBackButton: false,
      onCloseButtonClicked: () {
        Navigator.of(context).pop();
      },
      children: this.children,
    );
  }

  static success(
      BuildContext context, String message, Function(dynamic) onClose) {
    Dialogs.materialDialog(
        color: Colors.white,
        title: 'Success',
        lottieBuilder: Lottie.asset(
          'assets/jsons/cong_example.json',
          fit: BoxFit.contain,
        ),
        context: context,
        actions: [
          IconsButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            text: 'OK',
            // iconData: Icons.done,
            color: AppColors.green[500],
            textStyle: AppStyles.textStyle16Medium
                .merge(TextStyle(color: Colors.white)),
            iconColor: Colors.white,
          ),
        ],
        titleStyle: AppStyles.textStyle24Bold
            .merge(TextStyle(color: AppColors.green[500])),
        msg: message,
        useRootNavigator: true,
        useSafeArea: true,
        onClose: onClose,
        msgStyle: AppStyles.textStyle16Medium);
  }

  static bottomDialog(BuildContext context, String title, String message,
      Function(dynamic) onClose) {
    return Dialogs.bottomMaterialDialog(
      msg: message,
      title: title,
      context: context,
      customView: Container(
        padding: EdgeInsets.only(top: 20),
        child: Image.asset(Assets.storeCheckpointIcon, height: 54,),
      ),
      actions: [
        IconsButton(
          onPressed: () {},
          text: 'Create routing',
          iconData: Icons.add,
          color: AppColors.green[500],
          textStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
      titleStyle: AppStyles.textStyle18Medium,
      msgStyle: AppStyles.textStyle16Regular400.merge(TextStyle(color: AppColors.textGreyColor)),
    );
  }

  static confirmDialog(BuildContext context, String titleText, String contentText, String confirmText, String cancelText, VoidCallback onConfirmed) {
    showDialog(
        context: context,
        builder: (_) => ConfirmDialogWidget(
          titleText: titleText,
          contentText: contentText,
          confirmText: confirmText,
          cancelText: cancelText,
          onConfirmed: onConfirmed,
        ));
  }
}
