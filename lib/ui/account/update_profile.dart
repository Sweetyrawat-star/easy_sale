import 'dart:io';
import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/api/api.dart';
import 'package:boilerplate/widgets/app_simple_input_widget.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:boilerplate/widgets/simple_app_bar_widget.dart';
import 'package:boilerplate/widgets/primary_button_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../di/components/service_locator.dart';
import '../../models/user/user.dart';
import '../../stores/user/user_store.dart';
import '../../widgets/flash_message_widget.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen();
  @override
  State<StatefulWidget> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final Repository _repository = getIt<Repository>();
  final ImagePicker _picker = ImagePicker();
  late UserStore _userStore;
  TextEditingController _userFullnameController = TextEditingController();
  TextEditingController _userEmailController = TextEditingController();
  bool _isSelectedImage = false;
  late XFile? _imageFile;
  late String _fileUploadedPath = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userStore = Provider.of<UserStore>(context);
    if (_userFullnameController.text.isEmpty && _userEmailController.text.isEmpty) {
      _userFullnameController = TextEditingController(text: _userStore.currentUserData.fullName);
      _userEmailController = TextEditingController(text: _userStore.currentUserData.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "Update account info",),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 47, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                      radius: 50,
                      backgroundImage: _isSelectedImage ? FileImage(File(_imageFile!.path)) as ImageProvider
                          : CachedNetworkImageProvider(Endpoints.getDownloadUrl(_userStore.currentUserData.avatar))
                  ),
                  SizedBox(width: 15.0,),
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: AppColors.bgLightBlue
                    ),
                    child: _offsetPopup(),
                  )
                ],
              ),
              SizedBox(height: 24,),
              MyLabelWidget(text: "Personalize", style: AppStyles.textStyle16Regular400),
              SizedBox(height: 15,),
              AppSimpleInputWidget("Input full name",
                textController: _userFullnameController,
              ),
              SizedBox(height: 15,),
              AppSimpleInputWidget("Input email",
                textController: _userEmailController,
              ),
              SizedBox(height: 36,),
              PrimaryButtonWidget(
                buttonText: "Update",
                buttonWidth: MediaQuery.of(context).size.width - 40,
                onPressed: () {
                  User user = new User(
                    phone: _userStore.currentUserData.phone,
                    fullName: _userFullnameController.text,
                    email: _userEmailController.text,
                    avatar: _isSelectedImage ? _fileUploadedPath : _userStore.currentUserData.avatar,
                    userId: _userStore.currentUserData.userId,
                    jobRegistered: _userStore.jobRegistered
                  );
                  _userStore.updateProfile(user).then((value) {
                    FlashMessageWidget.flashSuccess(context, "Update success!");
                    // Navigator.pop(context);
                  }).catchError((err) {
                    FlashMessageWidget.flashError(context, err.toString());
                  });
                },
              )
            ],
          ),
        ),
      )
    );
  }

  Widget _offsetPopup() => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: Text(
          "Take a photo",
        ),
        onTap: () {_onImageButtonPressed(ImageSource.camera);},
      ),
      PopupMenuItem(
        value: 2,
        child: Text(
          "Pick from gallery",
        ),
        onTap: () {_onImageButtonPressed(ImageSource.gallery);},
      ),
    ],
    child: Padding(
      padding: EdgeInsets.only(left: 14, right: 14),
      child: Center(child: MyLabelWidget(text: "Change avatar", style: AppStyles.textStyle16Regular400,),
      ),
    ),
    offset: Offset(0, 40),
  );

  Future<void> _onImageButtonPressed(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
      );
      ApiResponse response = await _repository.uploadImage(pickedFile!);
      if (response.isSuccess) {
        setState(() {
          _imageFile = pickedFile;
          _isSelectedImage = true;
          _fileUploadedPath = response.data["path"];
        });
      } else {
        FlashMessageWidget.flashError(context, response.errorMessage.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _userEmailController.dispose();
    _userFullnameController.dispose();
  }
}
