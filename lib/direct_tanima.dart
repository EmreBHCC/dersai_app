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

  @override
  void initState() {
    super.initState();
  }

  Future<void> pickImage(BuildContext context) async {
    result.clear();
    final pickedFile = await _imagepicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );

    if (pickedFile == null) {
      print('user cancelled the image selection');
      return;
    } else {
      final imageProvider = Provider.of<MyImageProvider>(context, listen: false);
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
    final imageProviderWatch = Provider.of<MyImageProvider>(context);
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
                              pickImage(context);
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
                  SizedBox(height: spacing),
                  // Görsel için daha fazla alan ayır ve height parametresini kaldır
                  Expanded(
                    flex: 3,
                    child: (imageProviderWatch.decoded_url != null &&
                            imageProviderWatch.decoded_url!.isNotEmpty)
                        ? Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Image.network(
                              imageProviderWatch.decoded_url!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              // height: MediaQuery.of(context).size.height * 0.25, // kaldırıldı
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.broken_image, size: 48),
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
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
