import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/note_provider.dart';
import '../widgets/custom_app_bar.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<NoteProvider>(context).notes;
    debugPrint(
      'RemindersPage notes: ' +
          notes
              .map((e) => '${e.title} - ${e.reminderTime}')
              .toList()
              .toString(),
    );
    final reminders =
        notes
            .where(
              (n) =>
                  n.reminderTime != null &&
                  n.reminderTime!.isAfter(DateTime.now()),
            )
            .toList();
    reminders.sort((a, b) => a.reminderTime!.compareTo(b.reminderTime!));
    return Scaffold(
      appBar: CustomAppBar(
        text: 'Kurulu Alarmlar',
        onProfileTap: null,
        showLogout: false,
        onLogout: null,
      ),
      body:
          reminders.isEmpty
              ? Center(
                child: Text(
                  'Hiç kurulu alarm yok.',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: reminders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, i) {
                  final note = reminders[i];
                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.indigo.shade50,
                    child: ListTile(
                      leading: Icon(
                        Icons.alarm,
                        color: Colors.indigo,
                        size: 32,
                      ),
                      title: Text(
                        note.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (note.content.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                note.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 18,
                                  color: Colors.indigo.shade400,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '${note.reminderTime!.toLocal()}'.split(
                                    '.',
                                  )[0],
                                  style: TextStyle(
                                    color: Colors.indigo.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
