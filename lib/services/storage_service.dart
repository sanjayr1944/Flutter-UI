import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note_model.dart';

class StorageService
{
  //Created My Local Database Table/Collection.
  static const String _noteCollection = 'user_notes_collection';


  //To Load Collections in My Database.
Future<List<Note>> loadNotes() async
{
  final prefs = await SharedPreferences.getInstance(); //To check the data's Inside My Database
  final String? notesJson = prefs.getString(_noteCollection);

  if(notesJson == null || notesJson.isEmpty)
  {
    return [];
  }

  try
  {
    final List<dynamic> notesMap = json.decode(notesJson);

    return notesMap.map((noteMap) => Note.fromMap(noteMap as Map<String, dynamic>)).toList();
  }
  catch(e)
  {
    return [];
  }
}

//Save Method


Future <bool> saveNotes(List<Note> notes)
async
{
  final prefs = await SharedPreferences.getInstance();
  final List<Map<String,dynamic>> mapList =
      notes.map((note) => note.toMap()).toList();

  final String encoded = json.encode(mapList);
  return await prefs.setString(_noteCollection, encoded);
}

}
