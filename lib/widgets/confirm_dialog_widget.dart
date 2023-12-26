import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:flutter/material.dart';

class ConfirmDialogWidget extends StatelessWidget {
  final String titleText;
  final String contentText;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirmed;
  final VoidCallback? onCanceled;

  const ConfirmDialogWidget({
    Key? key,
    required this.titleText,
    required this.contentText,
    required this.confirmText,
    required this.cancelText,
    this.onConfirmed,
    this.onCanceled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleText),
      content: MyLabelWidget(
        text: contentText,
        style: AppStyles.textStyle16Regular400.merge(TextStyle(height: 1.5)),
      ),
      actions: [
        // The "Yes" button
        TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
            },
            child: Text(cancelText, style: TextStyle(fontSize: 16),)),
        TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
              onConfirmed!();
            },
            child: Text(confirmText, style: TextStyle(fontSize: 16),))
      ],
    );
  }
}
