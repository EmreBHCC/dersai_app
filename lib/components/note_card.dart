import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'note_provider.dart';

class NoteCard extends StatelessWidget {
  final String note;
  final Color baseColor;
  final double screenWidth;
  final double screenHeight;

  const NoteCard({
    super.key,
    required this.note,
    required this.baseColor,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    return Container(
      height: screenHeight,
      margin: EdgeInsets.only(
        top: screenHeight * 0.02,
        right: screenWidth * 0.02,
        left: screenWidth * 0.02,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 65, 65, 65),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Container(
        margin: EdgeInsets.only(
          top: screenHeight * 0.01,
          right: screenWidth * 0.01,
          left: screenWidth * 0.01,
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
              colors: [baseColor, noteProvider.darken(baseColor, 0.4)],
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
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Text(
                note,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
