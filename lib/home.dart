import 'user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/note_card.dart';
import 'components/add_note_button.dart';
import 'components/bottom_navigation.dart';
import 'components/custom_app_bar.dart';
import 'providers/note_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _addNote(BuildContext context) async {
    String? newNote = await showDialog<String>(
      context: context,
      builder: (context) {
        String input = "";
        return AlertDialog(
          title: Text('Yeni Not Ekle'),
          content: TextField(
            autofocus: true,
            onChanged: (value) => input = value,
            decoration: InputDecoration(hintText: 'Not başlığı girin'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(input),
              child: Text('Ekle'),
            ),
          ],
        );
      },
    );

    if (newNote != null && newNote.isNotEmpty) {
      context.read<NoteProvider>().addNote(newNote);
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
                  Navigator.pushNamed(context, '/user'); // ✅ Doğru yer
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
            left: 0,
            right: 0,
            bottom: 0,
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
