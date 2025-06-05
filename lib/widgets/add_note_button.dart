import 'package:flutter/material.dart';

class AddNoteButton extends StatelessWidget {
  final VoidCallback onTap;
  final double screenWidth;
  final double screenHeight;

  const AddNoteButton({
    Key? key,
    required this.onTap,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.4,
      height: screenHeight * 0.05,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Yeni not ekle",
              style: TextStyle(fontSize: screenWidth * 0.035),
            ),
            IconButton(onPressed: onTap, icon: Icon(Icons.add_circle_outline)),
          ],
        ),
      ),
    );
  }
}
