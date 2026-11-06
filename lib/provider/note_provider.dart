import 'package:flutter/material.dart';

import '../models/note_model.dart';
import '../services/storage_service.dart';

class NoteProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<Note> _notes = [];
  bool _isLoading = true;
  String _searchQuery = '';

  List<Note> get notes {
    if (_searchQuery.trim().isEmpty) {
      return _notes;
    }

    return _notes
        .where(
          (note) =>
              note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              note.content.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  //Method to Load Notes
  Future<void> fetchAndSetNotes() async {
    _isLoading = true;
    notifyListeners();

    final List<Note> loadedNotes = await _storageService.loadNotes();
    _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNote(String title, String content) async {
    final newNote = Note(
      id: DateTime.now().toString(),
      title: title.trim().isEmpty ? 'Untitled' : title.trim(),
      content: content.trim(),
      updatedAt: DateTime.now(),
    );

    _notes.insert(0, newNote);
    notifyListeners();
    await _storageService.saveNotes(_notes);
  }

  //UPDATE -  Update and Remove
  Future<void> updateNote(String id, String newTitle, String newContent) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index].title = newTitle.trim().isEmpty
          ? 'Untitled'
          : newTitle.trim();
      _notes[index].content = newContent.trim();
      _notes[index].updatedAt = DateTime.now();

      //Remove

      final updatedNote = _notes.removeAt(index);
      _notes.insert(0, updatedNote);

      notifyListeners();
      await _storageService.saveNotes(_notes);
    }
  }

  //Delete
Future<void> deleteNote(String id) async
{
  _notes.removeWhere((note) => note.id == id);
  notifyListeners();
  await _storageService.saveNotes(_notes);
}

//SEARCH
void setSearchQuery(String query)
{
  _searchQuery = query;
  notifyListeners();
}
}
