import 'package:flutter/material.dart';

class NoteProvider with ChangeNotifier {
  List<String> _notes = [];
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

  List<String> get notes => _notes;
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

  Future<void> addNote(String note) async {
    if (note.isNotEmpty) {
      _notes.add(note);
      _noteColors[note] = _selectedColor ?? defaultColor;
      _selectedColor = null; // Seçili rengi sıfırla
      notifyListeners();
    }
  }

  void deleteNote(String note) {
    _notes.remove(note);
    _noteColors.remove(note);
    notifyListeners();
  }

  void updateNote(String oldNote, String newNote) {
    final index = _notes.indexOf(oldNote);
    if (index != -1) {
      _notes[index] = newNote;
      final color = _noteColors[oldNote];
      _noteColors.remove(oldNote);
      _noteColors[newNote] = color!;
      notifyListeners();
    }
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

  void clearTempColors() {
    _tempColors.clear();
    notifyListeners();
  }
}
