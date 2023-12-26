import 'package:boilerplate/data/repository.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/styles.dart';
import '../../../di/components/service_locator.dart';
import '../../../widgets/my_label_widget.dart';

typedef void ChannelChangedCallback(String areaId);

class ChannelMultiSelectWidget extends StatefulWidget {
  final ChannelChangedCallback onChannelChanged;
  final ChannelChangedCallback onChannel1Changed;
  final ChannelChangedCallback onChannel2Changed;
  final ChannelChangedCallback onChannel21Changed;
  final ChannelChangedCallback onChannel22Changed;
  final ChannelChangedCallback onBrandChanged;
  final ChannelChangedCallback onBrand1Changed;
  final ChannelChangedCallback onBrand2Changed;

  const ChannelMultiSelectWidget({
    Key? key,
    required this.onChannelChanged,
    required this.onChannel1Changed,
    required this.onChannel2Changed,
    required this.onChannel21Changed,
    required this.onChannel22Changed,
    required this.onBrandChanged,
    required this.onBrand1Changed,
    required this.onBrand2Changed,
  }) : super(key: key);

  @override
  _ChannelMultiSelectWidgetState createState() => _ChannelMultiSelectWidgetState();
}

class _ChannelMultiSelectWidgetState extends State<ChannelMultiSelectWidget> {
  final Repository _repository = getIt<Repository>();
  // ignore: non_constant_identifier_names
  final NAME_KEY = "name";
  // ignore: non_constant_identifier_names
  final ID_KEY = "id";
  List<dynamic> _dataProv = [];
  List<dynamic> _dataDist = [];
  List<dynamic> _dataSubDist = [];
  List<dynamic> _dataBrand = [];
  List<dynamic> _dataSubDist1 = [];
  List<dynamic> _dataBrand1 = [];
  List<dynamic> _dataSubDist2 = [];
  List<dynamic> _dataBrand2 = [];
  late String _getProv = "";
  late String _getDist = "";
  late String _getSubDist = "";
  late String _getBrand = "";
  late String _getSubDist1 = "";
  late String _getBrand1 = "";
  late String _getSubDist2 = "";
  late String _getBrand2 = "";
  late bool disableSubDist = false;
  late bool disableBrand = false;
  late bool disableSubDist1 = false;
  late bool disableBrand1 = false;
  late bool disableSubDist2 = false;
  late bool disableBrand2 = false;

  // get all province
  void getProv() async {
    final listData = await _repository.getCategories("channel");
    setState(() {
      _dataProv = List.from([{ID_KEY: 0, NAME_KEY: "--Select distribution channel--"}])..addAll(listData);
      _getProv = _dataProv[0][ID_KEY].toString();
    });
  }

  // get detail of province that we choose
  void getDetailProv() async {
    // var item = _dataProv.firstWhere((element) => element[ID_KEY].toString() == _getProv);
    // setState(() {
    //   _nameProv = item[NAME_KEY];
    // });
  }

  // get all district base on province
  void getDistrict() async {
    final listData = await _repository.getCategories("channel_1", _getProv);
    setState(() {
      _dataDist = List.from([{ID_KEY: 0, NAME_KEY: "--Select category level 1--"}])..addAll(listData);
      _getDist = _dataDist[0][ID_KEY].toString();
    });
    print("data : $listData");
  }

  // get detail of city/district that we choose
  void getDetailDistrict() async {
    // var item = _dataDist.firstWhere((element) => element[ID_KEY].toString() == _getDist);
    // setState(() {
    //   // _nameDist = item[NAME_KEY];
    // });
  }

  // get all sub-district base on city/district
  void getSubDistrict() async {
    final listData = await _repository.getCategories("channel_2", _getDist);
    setState(() {
      _dataSubDist = List.from([{ID_KEY: 0, NAME_KEY: "--Select category level 2--"}])..addAll(listData);
      _getSubDist = _dataSubDist[0][ID_KEY].toString();
      _dataSubDist1 = List.from([{ID_KEY: 0, NAME_KEY: "--Select category level 2--"}])..addAll(listData);
      _getSubDist1 = _dataSubDist1[0][ID_KEY].toString();
      _dataSubDist2 = List.from([{ID_KEY: 0, NAME_KEY: "--Select category level 2--"}])..addAll(listData);
      _getSubDist2 = _dataSubDist2[0][ID_KEY].toString();
    });
  }

  void getBrands() async {
    final listData = await _repository.getBrandsByCateId("");
    setState(() {
      _dataBrand = List.from([{ID_KEY: 0, NAME_KEY: "--Select brand--"}])..addAll(listData);
      _getBrand = _dataBrand[0][ID_KEY].toString();
      _dataBrand1 = List.from([{ID_KEY: 0, NAME_KEY: "--Select brand--"}])..addAll(listData);
      _getBrand1 = _dataBrand1[0][ID_KEY].toString();
      _dataBrand2 = List.from([{ID_KEY: 0, NAME_KEY: "--Select brand--"}])..addAll(listData);
      _getBrand2 = _dataBrand2[0][ID_KEY].toString();
    });
    print("data : $listData");
  }

  // get detail of sub-district that we choose
  void getDetailSubDistrict() async {
    // var item = _dataSubDist.firstWhere((element) => element[ID_KEY].toString() == _getSubDist);
    // setState(() {
    //   // _nameSubDist = item[NAME_KEY];
    // });
  }

  @override
  void initState() {
    super.initState();
    getProv();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _provinsi(),
          SizedBox(height: 18),
          _district(),
          SizedBox(height: 18),
          MyLabelWidget(text: "You can choose up to 3 level 2 categories", style: AppStyles.textStyle16Medium),
          SizedBox(height: 18),
          _subDistrict(disableSubDist),
          SizedBox(height: 18),
          _subDistrict1(disableSubDist),
          SizedBox(height: 18),
          _subDistrict2(disableSubDist),
        ],
      ),
    );
  }

  Widget _provinsi() {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyLabelWidget(
              text: "Distribution channel",
              style: AppStyles.textStyle18Medium,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.green[500],
                      shape: BoxShape.circle
                  ),
                  height: 7,
                  width: 7,
                ),
                SizedBox(width: 14,),
                MyLabelWidget(
                    text: "Can be exchanged every 2 months.",
                    style: AppStyles.textStyle14Regular.merge(TextStyle(color: AppColors.textGreyColor)))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButtonHideUnderline(
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                    // color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButtonFormField(
                  decoration: InputDecoration.collapsed(hintText: ''),
                  hint: Text("--Select distribution channel--"),
                  value: _getProv,
                  items: _dataProv.map((item) {
                    return DropdownMenuItem(
                      child: Text(item[NAME_KEY]),
                      value: item[ID_KEY].toString(),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      disableSubDist = true;
                      _getDist = "0";
                      _getSubDist = "0";
                      _getSubDist1 = "0";
                      _getSubDist2 = "0";
                      _getBrand = "0";
                      _getBrand1 = "0";
                      _getBrand2 = "0";
                      _getProv = value.toString();
                      getDetailProv();
                      getDistrict();
                    });
                    widget.onChannelChanged(value.toString());
                  },
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget _district() {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0),
      child: Container(
        alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(10)
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyLabelWidget(
              text: "Category level 1",
              style: AppStyles.textStyle18Medium,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.green[500],
                      shape: BoxShape.circle
                  ),
                  height: 7,
                  width: 7,
                ),
                SizedBox(width: 14,),
                MyLabelWidget(
                    text: "Can be exchanged every 2 months.",
                    style: AppStyles.textStyle14Regular.merge(TextStyle(color: AppColors.textGreyColor)))
              ],
            ),
            SizedBox(height: 10,),
            DropdownButtonHideUnderline(
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                    // color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButtonFormField(
                  decoration: InputDecoration.collapsed(hintText: ''),
                  hint: Text("--Select category level 1--"),
                  value: _getDist,
                  items: _dataDist.map((item) {
                    return DropdownMenuItem(
                      child: Text(item[NAME_KEY]),
                      value: item[ID_KEY].toString(),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      disableSubDist = false;
                      _getSubDist = "0";
                      _getSubDist1 = "0";
                      _getSubDist2 = "0";
                      _getBrand = "0";
                      _getBrand1 = "0";
                      _getBrand2 = "0";
                      _getDist = value.toString();
                      getDetailDistrict();
                      getSubDistrict();
                    });
                    widget.onChannel1Changed(value.toString());
                  },
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget _subDistrict(enableSubDist) {
    return Padding(
      padding: EdgeInsets.only(left: 50, right: 0),
      child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyLabelWidget(
                text: "Category level 2",
                style: AppStyles.textStyle18Medium,
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.green[500],
                        shape: BoxShape.circle
                    ),
                    height: 7,
                    width: 7,
                  ),
                  SizedBox(width: 14,),
                  MyLabelWidget(
                      text: "Can be exchanged every 1 month",
                      style: AppStyles.textStyle14Regular.merge(TextStyle(color: AppColors.textGreyColor)))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              DropdownButtonHideUnderline(
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    // color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration.collapsed(hintText: ''),
                    hint: Text("--Select category level 2--"),
                    value: _getSubDist,
                    items: _dataSubDist.map((item) {
                      return DropdownMenuItem(
                        child: Text(item[NAME_KEY]),
                        value: item[ID_KEY].toString(),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        disableBrand = false;
                        _getSubDist = value.toString();
                        _getBrand = "0";
                        getDetailSubDistrict();
                        getBrands();
                      });
                      widget.onChannel2Changed(value.toString());
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              DropdownButtonHideUnderline(
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    // color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration.collapsed(hintText: ''),
                    hint: Text("--Select brand--"),
                    value: _getBrand,
                    items: _dataBrand.map((item) {
                      return DropdownMenuItem(
                        child: Text(item[NAME_KEY]),
                        value: item[ID_KEY].toString(),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _getBrand = value.toString();
                      });
                      widget.onBrandChanged(value.toString());
                    },
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

  Widget _subDistrict1(enableSubDist) {
    return IgnorePointer(
      ignoring: enableSubDist,
      child: Padding(
        padding: EdgeInsets.only(left: 50, right: 0),
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyLabelWidget(
                  text: "Category level 2",
                  style: AppStyles.textStyle18Medium,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.green[500],
                          shape: BoxShape.circle
                      ),
                      height: 7,
                      width: 7,
                    ),
                    SizedBox(width: 14,),
                    MyLabelWidget(
                        text: "Can be exchanged every 1 month",
                        style: AppStyles.textStyle14Regular.merge(TextStyle(color: AppColors.textGreyColor)))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonHideUnderline(
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      // color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration.collapsed(hintText: ''),
                      hint: Text("--Select category level 2--"),
                      value: _getSubDist1,
                      items: _dataSubDist1.map((item) {
                        return DropdownMenuItem(
                          child: Text(item[NAME_KEY]),
                          value: item[ID_KEY].toString(),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _getSubDist1 = value.toString();
                          getDetailSubDistrict();
                        });
                        widget.onChannel21Changed(value.toString());
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonHideUnderline(
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      // color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration.collapsed(hintText: ''),
                      hint: Text("--Select brand--"),
                      value: _getBrand1,
                      items: _dataBrand1.map((item) {
                        return DropdownMenuItem(
                          child: Text(item[NAME_KEY]),
                          value: item[ID_KEY].toString(),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _getBrand1 = value.toString();
                        });
                        widget.onBrand1Changed(value.toString());
                      },
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }

  Widget _subDistrict2(enableSubDist) {
    return IgnorePointer(
      ignoring: enableSubDist,
      child: Padding(
        padding: EdgeInsets.only(left: 50, right: 0),
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyLabelWidget(
                  text: "Category level 2",
                  style: AppStyles.textStyle18Medium,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.green[500],
                          shape: BoxShape.circle
                      ),
                      height: 7,
                      width: 7,
                    ),
                    SizedBox(width: 14,),
                    MyLabelWidget(
                        text: "Can be exchanged every 1 month",
                        style: AppStyles.textStyle14Regular.merge(TextStyle(color: AppColors.textGreyColor)))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonHideUnderline(
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      // color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration.collapsed(hintText: ''),
                      hint: Text("--Select category level 2--"),
                      value: _getSubDist2,
                      items: _dataSubDist2.map((item) {
                        return DropdownMenuItem(
                          child: Text(item[NAME_KEY]),
                          value: item[ID_KEY].toString(),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _getSubDist2 = value.toString();
                        });
                        widget.onChannel22Changed(value.toString());
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonHideUnderline(
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      // color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration.collapsed(hintText: ''),
                      hint: Text("--Select brand--"),
                      value: _getBrand2,
                      items: _dataBrand2.map((item) {
                        return DropdownMenuItem(
                          child: Text(item[NAME_KEY]),
                          value: item[ID_KEY].toString(),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _getBrand2 = value.toString();
                        });
                        widget.onBrand2Changed(value.toString());
                      },
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}