import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String filePath;
  final int index;
  final VoidCallback? onDelete;
  const AudioPlayerWidget({
    required this.filePath,
    required this.index,
    this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _player;
  bool _isPlaying = false;
  bool _isReady = false;
  double _progress = 0.0;
  double _duration = 1.0;
  double _speed = 1.0;
  String? _customName;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudio();
    final file = File(widget.filePath);
    final base = file.uri.pathSegments.last.replaceAll('.m4a', '');
    final nameMatch = RegExp(r'^(.*?)_(\d{13})?$').firstMatch(base);
    if (nameMatch != null) {
      _customName = nameMatch.group(1)!.isNotEmpty ? nameMatch.group(1) : null;
    } else {
      _customName = base;
    }
    _player.playerStateStream.listen((state) {
      if (state.playing != _isPlaying) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
          _progress = 0.0;
        });
      }
    });
    _player.positionStream.listen((pos) {
      if (_isReady && _duration > 0) {
        final progress = pos.inMilliseconds / (_duration * 1000);
        setState(() {
          _progress = progress.clamp(0.0, 1.0);
        });
      }
    });
  }

  Future<void> _editName() async {
    String tempName = _customName ?? '';
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Kayıt İsmini Düzenle'),
          content: TextField(
            autofocus: true,
            controller: TextEditingController(text: tempName),
            decoration: InputDecoration(hintText: 'Kayıt adı'),
            onChanged: (val) => tempName = val.trim(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, tempName),
              child: Text('Kaydet'),
            ),
          ],
        );
      },
    );
    if (result != null && result.isNotEmpty && result != _customName) {
      final file = File(widget.filePath);
      final dir = file.parent;
      final newName =
          result.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_') + '.m4a';
      final newPath = dir.path + '/' + newName;
      await file.rename(newPath);
      setState(() {
        _customName = result;
      });
      if (widget.onDelete != null) {
        widget.onDelete!();
      }
    }
  }

  Future<void> _initAudio() async {
    try {
      await _player.setFilePath(widget.filePath);
      final dur = _player.duration?.inSeconds.toDouble() ?? 0.0;
      setState(() {
        _duration = dur > 0 ? dur : 1.0;
        _isReady = dur > 0;
        _progress = 0.0;
      });
    } catch (_) {
      setState(() {
        _isReady = false;
        _duration = 1.0;
        _progress = 0.0;
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _stopAudio() async {
    await _player.stop();
    await _player.seek(Duration.zero);
    setState(() {
      _isPlaying = false;
      _progress = 0.0;
    });
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      final duration = _player.duration ?? Duration.zero;
      final position = _player.position;
      if (duration.inMilliseconds > 0 &&
          (position >= duration - Duration(milliseconds: 500) ||
              position == Duration.zero)) {
        await _player.seek(Duration.zero);
      }
      await _player.setSpeed(_speed);
      await _player.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _toggleSpeed() async {
    if (_speed == 1.0) {
      _speed = 2.0;
    } else {
      _speed = 1.0;
    }
    await _player.setSpeed(_speed);
    setState(() {});
  }

  void _seekTo(double value) async {
    final position = Duration(milliseconds: (value * _duration * 1000).toInt());
    await _player.seek(position);
    setState(() {
      _progress = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          (_customName?.isNotEmpty == true
                              ? _customName!
                              : File(
                                widget.filePath,
                              ).uri.pathSegments.last.replaceAll('.m4a', '')),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, size: 18, color: Colors.indigo),
                        tooltip: 'Kayıt İsmini Düzenle',
                        onPressed: _editName,
                      ),
                    ],
                  ),
                ),
                if (widget.onDelete != null)
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Kaydı Sil',
                    onPressed: widget.onDelete,
                  ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: _isReady ? _togglePlayPause : null,
                ),
                IconButton(
                  icon: Icon(Icons.stop),
                  onPressed: _isReady ? _stopAudio : null,
                ),
                IconButton(
                  icon: Text(
                    '${_speed.toStringAsFixed(0)}x',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: _isReady ? _toggleSpeed : null,
                ),
                Expanded(
                  child: Slider(
                    value: _progress.clamp(0.0, 1.0),
                    onChanged: (_isReady && _duration > 0) ? _seekTo : null,
                    min: 0.0,
                    max: 1.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
