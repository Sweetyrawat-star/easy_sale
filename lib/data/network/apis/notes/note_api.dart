import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/models/routing/routing_list.dart';

import '../../../../models/note/note.dart';
import '../../../../models/note/note_list.dart';
import '../../../../models/routing/routing.dart';
import '../../../../models/routing/routing_detail.dart';

class NoteApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  NoteApi(this._dioClient);

  /// Returns list of post in response
  Future<NoteList> getNotes(Map<String, dynamic> params) async {
    try {
      final res = await _dioClient.get(Endpoints.getNotes, queryParameters: params);
      return NoteList.fromJson(res.data["data"]);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Note> createNote(Note note) async {
    try {
      final res = await _dioClient.post(Endpoints.createNote, data: note.toMap());
      return Note.fromMap(res.data);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<RoutingList> getRoutings(Map<String, dynamic> params) async {
    try {
      final res = await _dioClient.get(Endpoints.getRoutings, queryParameters: params);
      return RoutingList.fromJson(res.data["data"]);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<RoutingDetail> getRouting(String routingId) async {
    try {
      final res = await _dioClient.get(Endpoints.getRouting, queryParameters: {"id": routingId});
      if (!res.isSuccess) {
        throw res.errorMessage.toString();
      }
      return RoutingDetail.fromMap(res.data);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Routing> createRouting(Map<String, dynamic> params) async {
    try {
      final res = await _dioClient.post(Endpoints.createRouting, data: params);
      return Routing.fromMap(res.data);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
