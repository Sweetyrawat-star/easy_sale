import 'dart:io';
import 'package:boilerplate/widgets/image_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/repository.dart';
import '../../di/components/service_locator.dart';
import '../../models/api/api.dart';
import '../../widgets/closepopup_icon_widget.dart';
import '../../widgets/flash_message_widget.dart';
import '../../widgets/progress_indicator_widget.dart';

class ImageModel {
  String name;
  Widget image;
  String path;

  ImageModel({
    required this.name,
    required this.image,
    required this.path,
  });
}

typedef void ImageChangedCallback(List<ImageModel> images);

class ImagesPickerWidget extends StatefulWidget {
  final ImageChangedCallback onImageChange;

  const ImagesPickerWidget({
    Key? key,
    required this.onImageChange,
  });
  @override
  State<StatefulWidget> createState() => _ImagesPickerWidgetState();
}

class _ImagesPickerWidgetState extends State<ImagesPickerWidget> {
  final Repository _repository = getIt<Repository>();
  final ImagePicker _picker = ImagePicker();
  late List<ImageModel> images = [];
  late bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.images.add(new ImageModel(
        path: "",
        name: "init",
        image: ImagePickerWidget(
          width: MediaQuery.of(context).size.width / 3,
          height: 86,
          onTap: () {
            _onImageButtonPressed(ImageSource.camera);
          },
        )));
  }

  @override
  Widget build(BuildContext context) {
    return _buildImagePicker();
  }

  _buildImagePicker() {
    return Container(
      height: 86,
      child: Stack(
        children: [
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: this.images.length,
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: EdgeInsets.only(right: 12),
              child: this.images[this.images.length - 1 - index].image,
            ),
          ),
          Visibility(
            visible: loading,
            child: CustomProgressIndicatorWidget()
          )
        ],
      )
    );
  }

  Future<void> _onImageButtonPressed(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
      );
      setState(() {
        loading = true;
      });
      ApiResponse response = await _repository.uploadImage(pickedFile!);
      setState(() {
        loading = false;
      });
      if (response.isSuccess) {
        var image = _buildImage(pickedFile);
        setState(() {
          images = [
            ...images,
            ...[
              new ImageModel(
                  name: response.data["path"],
                  path: pickedFile.path,
                  image: image)
            ]
          ];
        });
        widget.onImageChange(this.images);
      } else {
        FlashMessageWidget.flashError(
            context, response.errorMessage.toString());
      }
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
    }
  }

  Widget _buildImage(XFile file) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Container(
          width: 173,
          height: 86,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: FileImage(File(file.path))),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 5, right: 5),
          child: ClosePopupIconWidget(
            onTap: () {
              final index =
                  images.indexWhere((element) => element.path == file.path);
              if (index > 0) {
                images.removeAt(index);
                var tmp = [...images];
                setState(() {
                  images = tmp;
                });
              }
            },
          ),
        )
      ],
    );
  }
}
