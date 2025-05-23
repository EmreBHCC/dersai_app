import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'note_provider.dart';

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
                      child: Container(
                        width: 32,
                        height: 32,
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border:
                              isSelected
                                  ? Border.all(color: Colors.black, width: 3)
                                  : null,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        );
      },
    );
  }
}

