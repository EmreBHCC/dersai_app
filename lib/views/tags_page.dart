import 'package:dersai_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/note_provider.dart';
import 'notes_by_tag_page.dart';

class TagsPage extends StatelessWidget {
  const TagsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NoteProvider>().notes;
    final tags = notes.expand((note) => note.tags).toSet().toList();

    return Scaffold(
      appBar: CustomAppBar(
        text: 'Etiketler',
        onProfileTap: null,
        showLogout: false,
        onLogout: null,
        // You can add more customization if needed
      ),
      body:
          tags.isEmpty
              ? const Center(child: Text('Hiç etiket yok.'))
              : ListView.builder(
                itemCount: tags.length,
                itemBuilder: (context, index) {
                  final tag = tags[index];
                  return ListTile(
                    title: Text(tag),
                    leading: const Icon(Icons.label),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotesByTagPage(tag: tag),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
