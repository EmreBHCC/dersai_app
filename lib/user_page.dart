import 'package:dersai_app/components/custom_app_bar.dart';
import 'package:dersai_app/components/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/note_provider.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double screenHeight = size.height;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(text: "Profiliniz"),
              Container(
                width: screenWidth,
                height: screenHeight * .3,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.account_circle_outlined,
                      size: screenWidth * .5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                "emre bahceci",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * .1,
                ),
              ),
              Divider(
                height: screenHeight * 0.01,
                color: Colors.black,
                thickness: 3,
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                "eposta@bbclub.space",
                style: TextStyle(fontSize: screenWidth * .05),
              ),
            ],
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 20,
            child: BottomNavigation(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
          ),
        ],
      ),
    );
  }
}
