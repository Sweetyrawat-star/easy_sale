import 'dart:io';
import 'package:boilerplate/stores/store/store_store.dart';
import 'package:boilerplate/widgets/app_simple_input_widget.dart';
import 'package:boilerplate/widgets/app_simple_label_widget.dart';
import 'package:boilerplate/widgets/image_picker_widget.dart';
import 'package:boilerplate/widgets/simple_app_bar_widget.dart';
import 'package:boilerplate/widgets/common_dialog_widget.dart';
import 'package:boilerplate/widgets/primary_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../data/repository.dart';
import '../../di/components/service_locator.dart';
import '../../models/api/api.dart';
import '../../models/store/store.dart';
import '../../widgets/address_multi_select_widget.dart';
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

class CreateStoreScreen extends StatefulWidget {
  const CreateStoreScreen();
  @override
  State<StatefulWidget> createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateStoreScreen> {
  final Repository _repository = getIt<Repository>();
  final ImagePicker _picker = ImagePicker();
  late StoreStore _storeStore;
  late List<ImageModel> images = [];
  TextEditingController _storeNameController = TextEditingController();
  TextEditingController _storePhoneController = TextEditingController();
  TextEditingController _storeDescController = TextEditingController();
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
    _storeNameController.dispose();
    _storePhoneController.dispose();
    _storeDescController.dispose();
    _storeAddressController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._storeStore = Provider.of<StoreStore>(context);
    if (this.images.length == 0) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(
          title: "Tạo cửa hàng",
        ),
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: ListView(
                children: [
                  AppSimpleLabelWidget("Tên cửa hàng"),
                  SizedBox(
                    height: 18,
                  ),
                  AppSimpleInputWidget(
                    "Nhập tên cửa hàng",
                    textController: _storeNameController,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  AppSimpleInputWidget(
                    "Nhập SĐT cửa hàng",
                    textController: _storePhoneController,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  AppSimpleInputWidget(
                    "Nhập mô tả cửa hàng",
                    textController: _storeDescController,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  AppSimpleLabelWidget("Hình ảnh cửa hàng"),
                  SizedBox(
                    height: 18,
                  ),
                  _buildImagePicker(),
                  SizedBox(
                    height: 18,
                  ),
                  AppSimpleLabelWidget("Địa chỉ"),
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
                  SizedBox(height: 20,),
                ],
              ),
            ),
            Observer(
              builder: (context) {
                return Visibility(
                  visible: _storeStore.loading || loading,
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
      padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
      child: PrimaryButtonWidget(
        buttonWidth: MediaQuery.of(context).size.width - 40,
        buttonText: "Tạo cửa hàng",
        onPressed: () {
          if (provinceId == "0" ||
              districtId == "0" ||
              wardId == "0" ||
              _storeNameController.text.isEmpty ||
              _storePhoneController.text.isEmpty ||
              _storeAddressController.text.isEmpty ||
              images.length < 1) {
            FlashMessageWidget.flashError(
                context, "Vui lòng nhập tất cả thông tin");
          } else {
            var address = new Address(
                areaIds: [provinceId, districtId, wardId],
                detail: _storeAddressController.text);
            _storeStore
                .createStore(new Store(
                phone: _storePhoneController.text,
                name: _storeNameController.text,
                desc: _storeDescController.text,
                avatar: images[1].name,
                images: List.from(images.map((e) => e.name))
                    .sublist(1, images.length),
                address: address))
                .then((data) {
              CommonDialogWidget.success(
                  context,
                  "Tạo điểm bán mới thành công",
                      (p0) => {Navigator.of(context).pop()});
            }).catchError((e) {
              FlashMessageWidget.flashError(
                  context, e.toString());
            });
          }
        },
      ),
    );
  }

  _buildImagePicker() {
    return Container(
      height: 86,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: this.images.length,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsets.only(right: 12),
          child: this.images[this.images.length - 1 - index].image,
        ),
      ),
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
