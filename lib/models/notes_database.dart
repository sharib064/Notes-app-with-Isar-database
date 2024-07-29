import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notesapp/models/notes.dart';
import 'package:path_provider/path_provider.dart';

class NotesDatabase extends ChangeNotifier {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NotesSchema], directory: dir.path);
  }

  final List<Notes> currentNotes = [];

  Future<void> addNote(String text) async {
    final newNote = Notes()..text = text;
    await isar.writeTxn(() => isar.notes.put(newNote));
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    List<Notes> fetchNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchNotes);
    notifyListeners();
  }

  Future<void> updateNotes(Id id, String text) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = text;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  Future<void> deleteNote(Id id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}
