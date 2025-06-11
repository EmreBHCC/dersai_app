import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/note_card.dart';
import '../widgets/add_note_button.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/color_picker.dart';
import '../provider/note_provider.dart';
import '../models/note_model.dart';
import '../core/constants/size_config.dart';

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
                      return ColorPicker(note: 'temp');
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
    SizeConfig.init(context);
    double titleFontSize = SizeConfig.screenWidth * 0.06;
    int crossAxisCount = SizeConfig.screenWidth > 600 ? 3 : 2;

    Provider.of<NoteProvider>(context, listen: false);

    return Scaffold(
      appBar: CustomAppBar(
        text: 'DersAI',
        onProfileTap: () {
          Navigator.pushNamed(context, '/user');
        },
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 10,
                  bottom: 0,
                  right: 16,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 0.04,
                    vertical: SizeConfig.screenHeight * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notlarınız',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: titleFontSize,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      AddNoteButton(onTap: () => _addNote(context)),
                    ],
                  ),
                ),
              ), // Üstteki buton için boşluk bırak
              Expanded(
                child: Consumer<NoteProvider>(
                  builder: (context, noteProvider, child) {
                    return GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth * 0.04,
                        vertical: SizeConfig.screenHeight * 0.02,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: SizeConfig.screenWidth * 0.04,
                        mainAxisSpacing: SizeConfig.screenHeight * 0.02,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: noteProvider.notes.length,
                      itemBuilder: (context, index) {
                        final note = noteProvider.notes[index];
                        return NoteCard(note: note);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/direct_tanima');
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text(
                      'Direct Tanıma',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(160, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                  SizedBox(width: SizeConfig.screenWidth * 0.09),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/reminders');
                    },
                    icon: const Icon(Icons.alarm),
                    label: const Text(
                      'Alarmlar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(160, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
