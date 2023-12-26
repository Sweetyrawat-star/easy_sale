import 'package:boilerplate/widgets/app_simple_input_widget.dart';
import 'package:boilerplate/widgets/simple_app_bar_widget.dart';
import 'package:boilerplate/widgets/primary_button_widget.dart';
import 'package:flutter/material.dart';

import '../../data/repository.dart';
import '../../di/components/service_locator.dart';
import '../../models/note/note.dart';
import '../../widgets/flash_message_widget.dart';
import '../../widgets/common_dialog_widget.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen();
  @override
  State<StatefulWidget> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final Repository _repository = getIt<Repository>();
  late List<Widget> images = [];
  TextEditingController _noteController = TextEditingController();

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
        title: "Create note",
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            AppSimpleInputWidget(
              "Input note",
              textController: _noteController,
              maxLines: 10,
              height: 250,
            ),
            PrimaryButtonWidget(
              buttonWidth: MediaQuery.of(context).size.width - 40,
              buttonText: "Save",
              onPressed: () {
                if (_noteController.text.isEmpty) {
                  FlashMessageWidget.flashError(
                      context, "Pls input your note!");
                } else {
                  _repository.createNote(Note(
                    content: _noteController.text
                  )).then((_) {
                    CommonDialogWidget.success(
                        context,
                        "Create notice success!",
                            (p0) => {
                          Navigator.of(context).pop(true),
                        });
                  }).catchError((err) {
                    FlashMessageWidget.flashError(context, err.toString());
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
