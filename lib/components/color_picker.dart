import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';

class ColorPicker extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String note;

  const ColorPicker({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.note,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Renk Seçin',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Wrap(
              spacing: screenWidth * 0.02,
              runSpacing: screenHeight * 0.02,
              alignment: WrapAlignment.center,
              children:
                  noteProvider.availableColors.map((color) {
                    final isSelected =
                        noteProvider.getSelectedColor(note) == color;
                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          noteProvider.setTempColor(note, null);
                        } else {
                          noteProvider.setTempColor(note, color);
                        }
                      },
                    );
                  }).toList(),
            ),
          ],
        );
      },
    );
  }
}

Future<void> _addNote(BuildContext context) async {
  Size size = MediaQuery.of(context).size;
  String input = "";
  String? newNote = await showDialog<String>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Yeni Not Ekle'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      input = value;
                    });
                  },
                  decoration: InputDecoration(hintText: 'Not başlığı girin'),
                ),
                SizedBox(height: size.height * 0.02),
                ColorPicker(
                  screenWidth: size.width,
                  screenHeight: size.height,
                  note: input,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.read<NoteProvider>().clearTempColors();
                  Navigator.of(context).pop();
                },
                child: Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (input.isNotEmpty) {
                    final tempColor = context
                        .read<NoteProvider>()
                        .getSelectedColor(input);
                    context.read<NoteProvider>().setSelectedColor(tempColor);
                    Navigator.of(context).pop(input);
                  }
                },
                child: Text('Ekle'),
              ),
            ],
          );
        },
      );
    },
  );

  if (newNote != null && newNote.isNotEmpty) {
    context.read<NoteProvider>().addNote(newNote);
  }
}
