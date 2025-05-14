import 'package:flutter/material.dart';

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
    return Container(
      height: screenHeight * 0.08,
      decoration: BoxDecoration(
        color: Color(0xff02003C),
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
              color: Colors.white,
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
