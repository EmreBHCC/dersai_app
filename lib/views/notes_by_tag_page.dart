import 'package:dersai_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/note_provider.dart';
import 'note_detail_page.dart';

class NotesByTagPage extends StatelessWidget {
  final String tag;
  const NotesByTagPage({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NoteProvider>().notes;
    final filteredNotes =
        notes.where((note) => note.tags.contains(tag)).toList();

    return Scaffold(
      appBar: CustomAppBar(
        text: 'Etiket: $tag',
        onProfileTap: null,
        showLogout: false,
        onLogout: null,
        // You can add more customization if needed
      ),
      body:
          filteredNotes.isEmpty
              ? const Center(child: Text('Bu etikete ait not yok.'))
              : ListView.builder(
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = filteredNotes[index];
                  return ListTile(
                    title: Text(note.title),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: const Icon(Icons.note),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => NoteDetailPage(
                                noteIndex: notes.indexOf(note),
                                note: note,
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
