import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  // ignore: non_constant_identifier_names
  final NAME_KEY = "nama";
  // ignore: non_constant_identifier_names
  final ID_KEY = "id";
  List<dynamic> _dataProv = [];
  List<dynamic> _dataDist = List.from([]);
  List<dynamic> _dataSubDist = List.from([]);
  late String _getProv = "";
  late String _nameProv = "";
  late String _getDist = "";
  late String _nameDist = "";
  late String _getSubDist = "";
  late String _nameSubDist = "";
  late bool disableSubDist = false; // for enable or disable sub-district's dropdown

  // get all province
  void getProv() async {
    final respose = await http.get(
        Uri.parse(
            "https://dev.farizdotid.com/api/daerahindonesia/provinsi"),
        headers: {"Accept": "application/json"});
    var listData = jsonDecode(respose.body)["provinsi"];
    setState(() {
      _dataProv = List.from([{ID_KEY: 0, NAME_KEY: "Chọn Tỉnh/Thành phố"}])..addAll(listData);
      _getProv = _dataProv[0][ID_KEY].toString();
    });
    print("data : $listData");
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
    final respose = await http.get(
        Uri.parse(
            "https://dev.farizdotid.com/api/daerahindonesia/kota?id_provinsi=" +
                _getProv +
                ""),
        headers: {"Accept": "application/json"});
    var listData = jsonDecode(respose.body)["kota_kabupaten"];
    setState(() {
      _dataDist = List.from([{ID_KEY: 0, NAME_KEY: "Chọn Quận/Huyện"}])..addAll(listData);
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
    final respose = await http.get(
        Uri.parse(
            "http://dev.farizdotid.com/api/daerahindonesia/kecamatan?id_kota=" +
                _getDist),
        headers: {"Accept": "application/json"});
    var listData = jsonDecode(respose.body)["kecamatan"];
    setState(() {
      _dataSubDist = List.from([{ID_KEY: 0, NAME_KEY: "Chọn Phường/Xã"}])..addAll(listData);
      _getSubDist = _dataSubDist[0][ID_KEY].toString();
    });
    print("data : $listData");
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Dependent Dropdown'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text('API from https://dev.farizdotid.com'),
              SizedBox(height: 40),
              _provinsi(),
              SizedBox(height: 20),
              _district(),
              SizedBox(height: 20),
              _subDistrict(disableSubDist),
              SizedBox(height: 40),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_nameProv)),
              SizedBox(height: 10),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_nameDist)),
              SizedBox(height: 10),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_nameSubDist)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _provinsi() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
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
              hint: Text("Choose Province"),
              value: _getProv,
              items: _dataProv.map((item) {
                return DropdownMenuItem(
                  child: Text(item['nama']),
                  value: item['id'].toString(),
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
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _district() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
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
              hint: Text("Choose District"),
              value: _getDist,
              items: _dataDist.map((item) {
                return DropdownMenuItem(
                  child: Text(item['nama']),
                  value: item['id'].toString(),
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
        padding: EdgeInsets.only(left: 10, right: 10),
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
                hint: Text("Choose Sub-District"),
                value: _getSubDist,
                items: _dataSubDist.map((item) {
                  return DropdownMenuItem(
                    child: Text(item['nama']),
                    value: item['id'].toString(),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _getSubDist = value.toString();
                    getDetailSubDistrict();
                  });
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