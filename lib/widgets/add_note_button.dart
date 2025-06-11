import 'package:flutter/material.dart';
import '../core/constants/size_config.dart';

class AddNoteButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddNoteButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.4,
      height: SizeConfig.screenHeight * 0.05,
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
              style: TextStyle(fontSize: SizeConfig.screenWidth * 0.035),
            ),
            Icon(Icons.add_circle_outline),
          ],
        ),
      ),
    );
  }
}
