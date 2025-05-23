import 'dart:io';

import 'package:dersai_app/components/custom_app_bar.dart';
import 'package:dersai_app/components/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'components/note_provider.dart';

class DirectTanimaPage extends StatefulWidget {
  const DirectTanimaPage({Key? key}) : super(key: key);

  @override
  State<DirectTanimaPage> createState() => _DirectTanimaPageState();
}

class _DirectTanimaPageState extends State<DirectTanimaPage> {
  final _imagepicker = ImagePicker();

  final List<String> result = [];

  RxString picture = "".obs;

  RxList idList = [].obs;

  late MyImageProvider imageProvider;

  @override
  void initState() {
    super.initState();
    imageProvider = Provider.of<MyImageProvider>(context, listen: false);
  }

  Future<void> pickImage() async {
    result.clear();
    final pickedFile = await _imagepicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );

    if (pickedFile == null) {
      print('user cancelled the image selection');
      return;
    } else {
      await imageProvider.uploadImage(File(pickedFile.path));
    }
  }

  Future<void> speechToText() async {
    result.clear();
    // Implement your speech-to-text functionality here
    await Future.delayed(const Duration(seconds: 2));
    result.add("Simulated speech-to-text result");
    print("Simulated speech-to-text result");
    
  }


  @override
  Widget build(BuildContext context) {
    Provider.of<NoteProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double screenHeight = size.height;

    // Responsive values
    double appBarHeight = screenHeight * 0.12;
    double padding = screenWidth * 0.06;
    double spacing = screenHeight * 0.02;

    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(text: "Tanima"),
          SizedBox(height: appBarHeight * 0.2),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: padding,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _TanimaButton(
                            icon: Icons.camera_alt,
                            label: 'Kamera',
                            onTap: () {
                              pickImage();
                            },
                          ),
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          child: _TanimaButton(
                            icon: Icons.mic,
                            label: 'Konuşarak',
                            onTap: () {
                              speechToText();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacing),
                  Expanded(
                    child: _TanimaButton(
                      icon: Icons.image,
                      label: 'Goruntuden',
                      onTap: () {},
                      wide: true,
                    ),
                  ),
                  SizedBox(height: spacing),
                  Expanded(
                    child: _TanimaButton(
                      icon: Icons.help_outline,
                      label: 'Bize Ulaşin',
                      onTap: () {},
                      wide: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Image.network(
                    
                      imageProvider.decoded_url!,
                    )
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TanimaButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool wide;

  const _TanimaButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    Provider.of<NoteProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double screenHeight = size.height;

    // Responsive values
    double iconSize = screenWidth * 0.08;
    double fontSize = screenWidth * 0.04;
    double borderRadius = screenWidth * 0.04;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: wide ? double.infinity : null,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: Colors.black87),
            SizedBox(height: screenHeight * 0.01),
            Text(
              label,
              style: TextStyle(fontSize: fontSize, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
