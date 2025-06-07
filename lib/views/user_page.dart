import 'package:dersai_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/note_provider.dart';
import '../core/constants/size_config.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    Provider.of<NoteProvider>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(text: "Profiliniz"),
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight * .3,
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
                      size: SizeConfig.screenWidth * .5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.01),
              Text(
                "emre bahceci",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: SizeConfig.screenWidth * .1,
                ),
              ),
              Divider(
                height: SizeConfig.screenHeight * 0.01,
                color: Colors.black,
                thickness: 3,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.01),
              Text(
                "eposta@bbclub.space",
                style: TextStyle(fontSize: SizeConfig.screenWidth * .05),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
