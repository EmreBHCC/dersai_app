import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/note_provider.dart';
import '../models/note_model.dart';
import '../views/note_detail_page.dart';
import '../core/constants/size_config.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final index = noteProvider.notes.indexOf(note);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteDetailPage(noteIndex: index, note: note),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            height: SizeConfig.screenHeight,
            margin: EdgeInsets.only(
              top: SizeConfig.screenHeight * 0.02,
              right: SizeConfig.screenWidth * 0.02,
              left: SizeConfig.screenWidth * 0.02,
            ),
            child: Container(
              margin: EdgeInsets.only(
                top: SizeConfig.screenHeight * 0.01,
                right: SizeConfig.screenWidth * 0.01,
                left: SizeConfig.screenWidth * 0.01,
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 31, 31, 31),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(note.color),
                      noteProvider.darken(Color(note.color), 0.4),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 0,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(SizeConfig.screenWidth * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          note.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 4),
                            ],
                          ),
                        ),
                        if (note.content.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.screenWidth * 0.02,
                            ),
                            child: Text(
                              note.content,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: SizeConfig.screenWidth * 0.035,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        // Alarm button kaldırıldı (home screen'de görünmeyecek)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
