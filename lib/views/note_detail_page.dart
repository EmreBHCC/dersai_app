import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../provider/note_provider.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteIndex;
  final NoteModel note;
  const NoteDetailPage({Key? key, required this.noteIndex, required this.note})
    : super(key: key);

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _saveContent() async {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final updatedNote = NoteModel(
      title: widget.note.title,
      content: _contentController.text,
      color: widget.note.color,
    );
    await noteProvider.updateNote(widget.noteIndex, updatedNote);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note.title),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveContent,
            tooltip: 'Kaydet',
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final noteProvider = Provider.of<NoteProvider>(
                context,
                listen: false,
              );
              await noteProvider.deleteNote(widget.noteIndex);
              Navigator.pop(context);
            },
            tooltip: 'Sil',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _contentController,
          maxLines: null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Not İçeriği',
          ),
        ),
      ),
    );
  }
}
