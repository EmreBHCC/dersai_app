import 'user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/note_card.dart';
import 'components/add_note_button.dart';
import 'components/bottom_navigation.dart';
import 'components/custom_app_bar.dart';
import 'components/color_picker.dart';
import 'providers/note_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _addNote(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    String input = "";
    String? newNote = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              title: Text('Yeni Not Ekle'),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        autofocus: true,
                        onChanged: (value) {
                          setState(() {
                            input = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Not başlığı girin',
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      ColorPicker(
                        screenWidth: size.width,
                        screenHeight: size.height,
                        note: input.isEmpty ? 'temp' : input,
                      ),
                    ],
                  ),
                ),
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
                      // Check if note with same name exists
                      if (context.read<NoteProvider>().notes.contains(input)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Bu isimde bir not zaten mevcut!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      final tempColor = context
                          .read<NoteProvider>()
                          .getSelectedColor(input.isEmpty ? 'temp' : input);
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
      final noteProvider = context.read<NoteProvider>();
      final selectedColor = noteProvider.selectedColor;
      noteProvider.addNote(newNote);
      if (selectedColor != null) {
        noteProvider.setTempColor(newNote, selectedColor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double screenHeight = size.height;

    // Responsive values
    double titleFontSize = screenWidth * 0.06;
    int crossAxisCount = screenWidth > 600 ? 3 : 2;

    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(
                text: "Ana Sayfa",
                onMenuTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Menüye tıklandı")),
                  );
                },
                onProfileTap: () {
                  Navigator.pushNamed(context, '/user');
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              SizedBox(
                height: screenHeight * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Notlariniz",
                      style: TextStyle(fontSize: titleFontSize),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    AddNoteButton(
                      onTap: () => _addNote(context),
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<NoteProvider>(
                  builder: (context, noteProvider, child) {
                    return GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.02,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: screenWidth * 0.04,
                        mainAxisSpacing: screenHeight * 0.02,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: noteProvider.notes.length,
                      itemBuilder: (context, index) {
                        final note = noteProvider.notes[index];
                        final baseColor = noteProvider.noteColors[note]!;
                        return NoteCard(
                          note: note,
                          baseColor: baseColor,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: screenWidth * 0.18),
            ],
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 20,
            child: BottomNavigation(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
          ),
        ],
      ),
    );
  }
}
