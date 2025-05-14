import 'package:dersai_app/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double screenHeight = size.height;

    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(text: "Profiliniz"),
          Container(
            width: screenWidth * .8,
            height: screenHeight * .3,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.account_circle_outlined,
                  size: screenWidth * .7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
