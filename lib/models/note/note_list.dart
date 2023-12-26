import 'note.dart';

class NoteList {
  final List<Note> stores;

  NoteList({
    required this.stores,
  });

  factory NoteList.fromJson(List<dynamic> json) {
    List<Note> stores = <Note>[];
    stores = json.map((store) => Note.fromMap(store)).toList();

    return NoteList(
      stores: stores,
    );
  }
}
