
import 'package:boilerplate/data/repository.dart';
import 'package:flutter/material.dart';

import '../di/components/service_locator.dart';

typedef void ProvinceChangedCallback(String areaId, String areaName);
typedef void DistrictChangedCallback(String areaId, String areaName);
typedef void WardChangedCallback(String areaId, String? areaName);

class AddressMultiSelectWidget extends StatefulWidget {
  final ProvinceChangedCallback onProvinceChanged;
  final ProvinceChangedCallback onDistrictChanged;
  final ProvinceChangedCallback onWardChanged;

  const AddressMultiSelectWidget({
    Key? key,
    required this.onProvinceChanged,
    required this.onDistrictChanged,
    required this.onWardChanged,
  }) : super(key: key);

  @override
  _AddressMultiSelectWidgetState createState() => _AddressMultiSelectWidgetState();
}

class _AddressMultiSelectWidgetState extends State<AddressMultiSelectWidget> {
  final Repository _repository = getIt<Repository>();
  // ignore: non_constant_identifier_names
  final NAME_KEY = "name";
  // ignore: non_constant_identifier_names
  final ID_KEY = "id";
  List<dynamic> _dataProv = [];
  List<dynamic> _dataDist = [];
  List<dynamic> _dataSubDist = [];
  late String _getProv = "";
  late String _nameProv = "";
  late String _getDist = "";
  late String _nameDist = "";
  late String _getSubDist = "";
  late String _nameSubDist = "";
  late bool disableSubDist = false; // for enable or disable sub-district's dropdown

  // get all province
  void getProv() async {
    final listData = await _repository.getAreas("PROVINCE");
    setState(() {
      _dataProv = List.from([{ID_KEY: 0, NAME_KEY: "Select Province"}])..addAll(listData);
      _getProv = _dataProv[0][ID_KEY].toString();
    });
  }

  // get detail of province that we choose
  void getDetailProv() async {
    var item = _dataProv.firstWhere((element) => element[ID_KEY].toString() == _getProv);
    setState(() {
      _nameProv = item[NAME_KEY];
    });
  }

  // get all district base on province
  void getDistrict() async {
    final listData = await _repository.getAreas("DISTRICT", _getProv);
    setState(() {
      _dataDist = List.from([{ID_KEY: 0, NAME_KEY: "Select District"}])..addAll(listData);
      _getDist = _dataDist[0][ID_KEY].toString();
    });
    print("data : $listData");
  }

  // get detail of city/district that we choose
  void getDetailDistrict() async {
    var item = _dataDist.firstWhere((element) => element[ID_KEY].toString() == _getDist);
    setState(() {
      _nameDist = item[NAME_KEY];
    });
  }

  // get all sub-district base on city/district
  void getSubDistrict() async {
    final listData = await _repository.getAreas("WARD", _getDist);
    setState(() {
      _dataSubDist = List.from([{ID_KEY: 0, NAME_KEY: "Select Ward"}])..addAll(listData);
      _getSubDist = _dataSubDist[0][ID_KEY].toString();
    });
  }

  // get detail of sub-district that we choose
  void getDetailSubDistrict() async {
    var item = _dataSubDist.firstWhere((element) => element[ID_KEY].toString() == _getSubDist);
    setState(() {
      _nameSubDist = item[NAME_KEY];
    });
  }

  @override
  void initState() {
    super.initState();
    getProv();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _provinsi(),
          SizedBox(height: 18),
          _district(),
          SizedBox(height: 18),
          _subDistrict(disableSubDist),
        ],
      ),
    );
  }

  Widget _provinsi() {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: DropdownButtonHideUnderline(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              hint: Text("Select Province"),
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
                  _nameDist = "";
                  _nameSubDist = "";
                  _getDist = "0";
                  _getSubDist = "0";
                  _getProv = value.toString();
                  getDetailProv();
                  getDistrict();
                });
                widget.onProvinceChanged(value.toString(), _nameProv);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _district() {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: DropdownButtonHideUnderline(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              hint: Text("Select District"),
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
                  _nameSubDist = "";
                  _getSubDist = "0";
                  _getDist = value.toString();
                  getDetailDistrict();
                  getSubDistrict();
                });
                widget.onDistrictChanged(value.toString(), _nameDist);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _subDistrict(enableSubDist) {
    return IgnorePointer(
      ignoring: enableSubDist,
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: DropdownButtonHideUnderline(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5)),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                hint: Text("Select Ward"),
                value: _getSubDist,
                items: _dataSubDist.map((item) {
                  return DropdownMenuItem(
                    child: Text(item[NAME_KEY]),
                    value: item[ID_KEY].toString(),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _getSubDist = value.toString();
                    getDetailSubDistrict();
                  });
                  widget.onWardChanged(value.toString(), _nameSubDist);
                },
                validator: (value) =>
                value == null ? 'Silahkan Pilih Kecamatan' : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}