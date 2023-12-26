import 'dart:async';
import 'dart:convert';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/models/api/api.dart';
import 'package:boilerplate/models/job/job.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../models/user/user.dart';

class UserApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  UserApi(this._dioClient);

  /// Returns list of post in response
  Future<User> login(username, password) async {
    try {
      final res = await _dioClient.post(Endpoints.login, data: jsonEncode({
        "phone": username,
        "password": password
      }));
      if (!res.isSuccess) {
        throw res.errorMessage.toString();
      }
      return User.fromMap(res.data);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<User> loginSocial(type, token) async {
    try {
      final res = await _dioClient.post(Endpoints.login, data: jsonEncode({
        "type_login": type,
        "access_token": token
      }));
      if (!res.isSuccess) {
        throw res.errorMessage.toString();
      }
      return User.fromMap(res.data);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> register(fullName, username, password) async {
    try {
      final res = await _dioClient.post(Endpoints.register, data: jsonEncode({
        "fullname": fullName,
        "phone": username,
        "password": password
      }));
      if (!res.isSuccess) {
        throw res.errorMessage.toString();
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> logout() async {
    try {
      final res = await _dioClient.post(Endpoints.logout);
      if (!res.isSuccess) {
        throw res.errorMessage.toString();
      }
      return true;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<ApiResponse> uploadImage(XFile file) async {
    return await _dioClient.uploadImage(file);
  }

  Future<User> updateProfile(User user) async {
    try {
      final res = await _dioClient.post(Endpoints.updateProfile, data: user.toMap());
      if (!res.isSuccess) {
        throw res.errorMessage.toString();
      }
      return User.fromMap2(res.data);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> changePass(String old, String nPass) async {
    try {
      final res = await _dioClient.post(Endpoints.changePass, data: jsonEncode({
        "password_old": old,
        "password_new": nPass
      }));
      if (!res.isSuccess) {
        throw res.errorMessage.toString();
      }
      return true;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<MyJob> getJob() async {
    try {
      final res = await _dioClient.get(Endpoints.getJob);
      if (!res.isSuccess) {
        throw res.errorMessage.toString();
      }
      return MyJob.fromMap(res.data);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> registerJob(Map<String, dynamic> data) async {
    try {
      final res = await _dioClient.post(Endpoints.registerJob, data: data);
      if (!res.isSuccess) {
        throw res.errorMessage.toString();
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> updateJob(Map<String, dynamic> data) async {
    try {
      final res = await _dioClient.post(Endpoints.updateJob, data: data);
      if (!res.isSuccess) {
        throw res.errorMessage.toString();
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

}
