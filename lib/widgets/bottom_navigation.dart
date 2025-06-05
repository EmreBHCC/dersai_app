import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/note_provider.dart';

class BottomNavigation extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const BottomNavigation({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<NoteProvider>(context, listen: false);
    return Container(
      height: screenHeight * 0.08,
      decoration: BoxDecoration(
        color: Colors.indigo[100],
        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 4, offset: Offset(0, -2)),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/direct_tanima');
        },
        child: Center(
          child: Text(
            'Doğrudan Tanıma',
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
