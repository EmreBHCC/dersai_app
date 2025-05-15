import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/note_provider.dart';

class DirectTanimaPage extends StatelessWidget {
  const DirectTanimaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double screenHeight = size.height;

    // Responsive values
    double appBarHeight = screenHeight * 0.12;
    double titleFontSize = screenWidth * 0.06;
    double iconSize = screenWidth * 0.06;
    double padding = screenWidth * 0.06;
    double spacing = screenHeight * 0.02;

    return Scaffold(
      body: Column(
        children: [
          // App Bar
          Container(
            width: double.infinity,
            height: appBarHeight,
            decoration: BoxDecoration(color: Color(0xff02003C)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: screenHeight * 0.01,
                    left: screenWidth * 0.02,
                    right: screenWidth * 0.02,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: iconSize,
                        ),
                      ),
                      Text(
                        "Tanıma",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleFontSize,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.account_circle_outlined,
                          color: Colors.white,
                          size: iconSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                            onTap: () {},
                          ),
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          child: _TanimaButton(
                            icon: Icons.mic,
                            label: 'Konuşarak',
                            onTap: () {},
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
                      label: 'Bize Ulaşın',
                      onTap: () {},
                      wide: true,
                    ),
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
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
