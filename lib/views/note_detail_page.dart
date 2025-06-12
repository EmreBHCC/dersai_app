import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../provider/note_provider.dart';
import '../core/constants/size_config.dart';
import '../services/notification_service.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../widgets/custom_app_bar.dart';
import '../widgets/audio_player_widget.dart';

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
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  List<FileSystemEntity> _audioFiles = [];

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.note.content);
    _loadAudioFiles();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<Directory> _getNoteAudioDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final noteDir = Directory('${dir.path}/note_audio_${widget.note.hashCode}');
    if (!await noteDir.exists()) {
      await noteDir.create(recursive: true);
    }
    return noteDir;
  }

  Future<void> _loadAudioFiles() async {
    final noteDir = await _getNoteAudioDir();
    final files =
        noteDir.listSync().where((f) => f.path.endsWith('.m4a')).toList();
    setState(() {
      _audioFiles = files;
    });
  }

  Future<void> _startOrStopRecording() async {
    if (_isRecording) {
      await _recorder.stop();
      setState(() {
        _isRecording = false;
      });
      await _loadAudioFiles();
    } else {
      bool hasPermission = await _recorder.hasPermission();
      if (hasPermission) {
        final noteDir = await _getNoteAudioDir();
        final now = DateTime.now();
        final safeName =
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}';
        final fileName = '$safeName.m4a';
        final filePath = '${noteDir.path}/$fileName';
        await _recorder.start(
          RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000),
          path: filePath,
        );
        setState(() {
          _isRecording = true;
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Mikrofon izni gerekli!')));
      }
    }
  }

  void _showCurrentReminderDialog(DateTime reminderTime) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.alarm, color: Colors.amber.shade800),
                SizedBox(width: 8),
                Text('Kurulu Alarm'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Kurulu: ${reminderTime.toLocal()}'),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: Icon(Icons.delete),
                  label: Text('Kaldır'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final noteProvider = Provider.of<NoteProvider>(
                      context,
                      listen: false,
                    );
                    final note = noteProvider.notes[widget.noteIndex];
                    final updatedNote = NoteModel(
                      title: note.title,
                      content: note.content,
                      color: note.color,
                      reminderTime: null,
                    );
                    await noteProvider.updateNote(
                      widget.noteIndex,
                      updatedNote,
                    );
                    await NotificationService.cancelNotification(
                      widget.note.hashCode,
                    );
                    setState(() {});
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Alarm/Zamanlayıcı kaldırıldı.')),
                    );
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Kapat'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: CustomAppBar(
        text: widget.note.title,
        onProfileTap: null,
        showLogout: false,
        onLogout: null,
        // You can add more customization if needed
      ),
      body: Column(
        children: [
          if (widget.note.tags.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.screenWidth * 0.06,
                right: SizeConfig.screenWidth * 0.06,
                top: SizeConfig.screenHeight * 0.02,
              ),
              child: SizedBox(
                height: 36,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        widget.note.tags
                            .map(
                              (tag) => Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Chip(
                                  label: Text(
                                    '#$tag',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Colors.indigo.shade400
                                      .withOpacity(0.85),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Özetle butonu en sola
              TextButton.icon(
                onPressed: () {
                  // TODO: Özetle fonksiyonu burada çağrılacak
                },
                icon: Icon(Icons.summarize, color: Colors.indigo),
                label: Text('Özetle', style: TextStyle(color: Colors.indigo)),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                tooltip: _isRecording ? 'Kaydı Durdur' : 'Ses Kaydet',
                onPressed: _startOrStopRecording,
              ),
              IconButton(
                icon: Icon(Icons.alarm),
                tooltip: 'Alarm veya Zamanlayıcı Kur',
                onPressed: () async {
                  final noteProvider = Provider.of<NoteProvider>(
                    context,
                    listen: false,
                  );
                  final note = noteProvider.notes[widget.noteIndex];
                  if (note.reminderTime != null &&
                      note.reminderTime!.isAfter(DateTime.now())) {
                    _showCurrentReminderDialog(note.reminderTime!);
                    return;
                  }
                  final result = await showModalBottomSheet<String>(
                    context: context,
                    builder:
                        (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.alarm),
                              title: Text('Alarm Kur'),
                              onTap: () => Navigator.pop(context, 'alarm'),
                            ),
                            ListTile(
                              leading: Icon(Icons.timer),
                              title: Text('Zamanlayıcı Kur'),
                              onTap: () => Navigator.pop(context, 'timer'),
                            ),
                          ],
                        ),
                  );
                  if (result == 'alarm') {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        final scheduledDate = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        await NotificationService.scheduleNotification(
                          widget.note.hashCode,
                          widget.note.title,
                          widget.note.content,
                          scheduledDate,
                        );
                        final updatedNote = NoteModel(
                          title: note.title,
                          content: note.content,
                          color: note.color,
                          reminderTime: scheduledDate,
                        );
                        await noteProvider.updateNote(
                          widget.noteIndex,
                          updatedNote,
                        );
                        await Future.delayed(Duration(milliseconds: 100));
                        if (!mounted) return;
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/reminders',
                          (route) => route.isFirst,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Alarm kuruldu.')),
                        );
                      }
                    }
                  } else if (result == 'timer') {
                    final duration = await showDialog<Duration>(
                      context: context,
                      builder: (context) {
                        Duration tempDuration = Duration(minutes: 1);
                        return AlertDialog(
                          title: Row(
                            children: [
                              Icon(Icons.timer, color: Colors.amber.shade800),
                              SizedBox(width: 8),
                              Text('Zamanlayıcı Süresi Seç'),
                            ],
                          ),
                          content: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Dakika'),
                            onChanged: (val) {
                              final min = int.tryParse(val) ?? 1;
                              tempDuration = Duration(minutes: min);
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('İptal'),
                            ),
                            TextButton(
                              onPressed:
                                  () => Navigator.pop(context, tempDuration),
                              child: Text('Kur'),
                            ),
                          ],
                        );
                      },
                    );
                    if (duration != null) {
                      final scheduledDate = DateTime.now().add(duration);
                      await NotificationService.scheduleNotification(
                        widget.note.hashCode,
                        widget.note.title,
                        widget.note.content,
                        scheduledDate,
                      );
                      final updatedNote = NoteModel(
                        title: note.title,
                        content: note.content,
                        color: note.color,
                        reminderTime: scheduledDate,
                      );
                      await noteProvider.updateNote(
                        widget.noteIndex,
                        updatedNote,
                      );
                      setState(() {});
                      _showCurrentReminderDialog(scheduledDate);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Zamanlayıcı kuruldu.')),
                      );
                    }
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.save),
                tooltip: 'Notu Kaydet',
                onPressed: () async {
                  final noteProvider = Provider.of<NoteProvider>(
                    context,
                    listen: false,
                  );
                  final updatedNote = NoteModel(
                    title: widget.note.title,
                    content: _contentController.text,
                    color: widget.note.color,
                    reminderTime: widget.note.reminderTime,
                  );
                  await noteProvider.updateNote(widget.noteIndex, updatedNote);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Not kaydedildi.')));
                },
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.screenWidth * 0.06),
              child: Column(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Not İçeriği',
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ses Kayıtları',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child:
                        _audioFiles.isEmpty
                            ? Center(child: Text('Kayıt yok'))
                            : ListView.separated(
                              scrollDirection: Axis.vertical,
                              itemCount: _audioFiles.length,
                              separatorBuilder:
                                  (context, index) => SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final file = _audioFiles[index];
                                return AudioPlayerWidget(
                                  filePath: file.path,
                                  index: index,
                                  onDelete: () async {
                                    await file.delete();
                                    setState(() {
                                      _audioFiles.removeAt(index);
                                    });
                                  },
                                );
                              },
                            ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/direct_tanima');
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Direct Tanıma'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      minimumSize: Size.fromHeight(
                        SizeConfig.screenHeight * 0.06,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
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
