import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/note_card.dart';
import '../widgets/add_note_button.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/color_picker.dart';
import '../provider/note_provider.dart';
import '../models/note_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _addNote(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();
    Color selectedColor = Colors.blue;

    final colorNotifier = ValueNotifier<Color>(selectedColor);

    bool isDuplicate(String title, List<NoteModel> notes) {
      return notes.any((note) => note.title == title);
    }

    final newNote = await showDialog<NoteModel>(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          title: const Text('Yeni Not Ekle'),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: size.height * 0.7),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Not başlığı girin',
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(
                      hintText: 'Not içeriği girin',
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: size.height * 0.02),
                  ValueListenableBuilder<Color>(
                    valueListenable: colorNotifier,
                    builder: (context, value, child) {
                      return ColorPicker(
                        screenWidth: size.width,
                        screenHeight: size.height,
                        note: 'temp',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<NoteProvider>().clearTempColors('temp');
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final content = contentController.text.trim();
                final noteProvider = context.read<NoteProvider>();
                if (title.isEmpty) return;
                if (isDuplicate(title, noteProvider.notes)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bu isimde bir not zaten mevcut!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                final color = noteProvider.getSelectedColor('temp');
                final note = NoteModel(
                  title: title,
                  content: content,
                  color: color.value,
                );
                Navigator.of(context).pop(note);
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );

    if (newNote != null) {
      final noteProvider = context.read<NoteProvider>();
      await noteProvider.addNote(newNote);
      noteProvider.clearTempColors('temp');
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

    Provider.of<NoteProvider>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(
                text: "Ana Sayfa",
                onMenuTap: () {},
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
                      titleController: TextEditingController(),
                      contentController: TextEditingController(),
                      selectedColor: ValueNotifier<Color>(Colors.blue),
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
                        return NoteCard(
                          note: note,
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
