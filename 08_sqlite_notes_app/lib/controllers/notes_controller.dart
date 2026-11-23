import '../helpers/notes_db_helper.dart';
import '../models/note_model.dart';

/// NoteController managing operations between UI and DatabaseHelper (MVC pattern)
class NoteController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Note>> fetchNotes() async {
    return await _dbHelper.getNotes();
  }

  Future<int> addNote(Note note) async {
    return await _dbHelper.insertNote(note);
  }

  Future<int> updateNote(Note note) async {
    return await _dbHelper.updateNote(note);
  }

  Future<int> deleteNote(int id) async {
    return await _dbHelper.deleteNote(id);
  }
}
