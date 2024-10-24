import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotesViewModel extends ChangeNotifier {
  List notes = [];
  int? editingNoteId;
  bool isLoading = false;

  Future<void> fetchNotes() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/notes'));
      if (response.statusCode == 200) {
        notes = json.decode(response.body);
      } else {
        throw Exception('Failed to load notes');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNote(String title, String content) async {
    if (title.isEmpty || content.isEmpty) {
      throw Exception('Title and content must not be empty');
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/notes'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{'title': title, 'content': content}),
    );

    if (response.statusCode == 200) {
      fetchNotes();
    } else {
      throw Exception('Failed to add note');
    }
  }

  Future<void> updateNote(String title, String content) async {
    if (editingNoteId == null) return;

    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/notes/$editingNoteId'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{'title': title, 'content': content}),
    );

    if (response.statusCode == 200) {
      fetchNotes();
      editingNoteId = null;
    } else {
      throw Exception('Failed to update note');
    }
  }

  Future<void> deleteNote(int noteId) async {
    final response = await http.delete(Uri.parse('http://10.0.2.2:8000/notes/$noteId'));
    if (response.statusCode == 200) {
      fetchNotes();
    } else {
      throw Exception('Failed to delete note');
    }
  }

  void clearEditing() {
    editingNoteId = null;
    notifyListeners();
  }
}