import 'package:flutter/material.dart';

class DirectTanimaPage extends StatelessWidget {
  const DirectTanimaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // App Bar
          Container(
            width: double.infinity,
            height: 98,
            decoration: BoxDecoration(color: Color(0xff02003C)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                    left: 8,
                    right: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.menu, color: Colors.white),
                      ),
                      Text(
                        "Tanıma",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.account_circle_outlined,
                          color: Colors.white,
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                        SizedBox(width: 16),
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
                  SizedBox(height: 16),
                  Expanded(
                    child: _TanimaButton(
                      icon: Icons.image,
                      label: 'Goruntuden',
                      onTap: () {},
                      wide: true,
                    ),
                  ),
                  SizedBox(height: 16),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: wide ? double.infinity : null,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black87),
            SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 18, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
