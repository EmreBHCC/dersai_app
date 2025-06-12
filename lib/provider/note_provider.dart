import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/note_model.dart';

class NoteProvider with ChangeNotifier {
  List<NoteModel> _notes = [];
  Map<String, Color> _noteColors = {};
  Color? _selectedColor;
  Map<String, Color> _tempColors = {};

  final Color defaultColor = Color.fromARGB(
    255,
    90,
    186,
    255,
  ); // Varsayılan mavi renk

  final List<Color> availableColors = [
    Color.fromARGB(255, 90, 186, 255), // Açık mavi
    Color.fromARGB(255, 172, 120, 255), // Açık mor
    Color.fromARGB(255, 124, 255, 135), // Açık yeşil
    Color.fromARGB(255, 255, 204, 121), // Açık turuncu
    Color.fromARGB(255, 255, 124, 248), // Açık pembe
    Color.fromARGB(255, 121, 239, 255), // Açık turkuaz
    Color.fromARGB(255, 255, 117, 138), // Açık kırmızı
  ];

  List<NoteModel> get notes => _notes;
  Map<String, Color> get noteColors => _noteColors;
  Color? get selectedColor => _selectedColor;

  void setSelectedColor(Color? color) {
    _selectedColor = color;
    notifyListeners();
  }

  Color getRandomColor() {
    return availableColors[DateTime.now().millisecondsSinceEpoch %
        availableColors.length];
  }

  Color darken(Color color, [double amount = .4]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Future<void> loadNotes() async {
    final box = Hive.box<NoteModel>('notes');
    _notes = box.values.toList();
    notifyListeners();
  }

  Future<void> addNote(NoteModel note) async {
    final box = Hive.box<NoteModel>('notes');
    await box.add(note);
    _notes.add(note);
    notifyListeners();
  }

  Future<void> updateNote(int index, NoteModel newNote) async {
    final box = Hive.box<NoteModel>('notes');
    await box.putAt(index, newNote);
    _notes[index] = newNote;
    debugPrint(
      'updateNote: ' +
          _notes
              .map((e) => '${e.title} - ${e.reminderTime} - ${e.tags}')
              .toList()
              .toString(),
    );
    notifyListeners();
  }

  Color getSelectedColor(String note) {
    return _tempColors[note] ?? _noteColors[note] ?? defaultColor;
  }

  void setTempColor(String note, Color? color) {
    if (color == null) {
      _tempColors.remove(note);
    } else {
      _tempColors[note] = color;
    }
    notifyListeners();
  }

  void clearTempColors(String s) {
    _tempColors.clear();
    notifyListeners();
  }
}
