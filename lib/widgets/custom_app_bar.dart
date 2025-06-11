import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/note_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final VoidCallback? onMenuTap;
  final VoidCallback? onProfileTap;
  final bool showLogout;
  final VoidCallback? onLogout;

  const CustomAppBar({
    super.key,
    required this.text,
    this.onMenuTap,
    this.onProfileTap,
    this.showLogout = false,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    Provider.of<NoteProvider>(context, listen: false);
    return AppBar(
      backgroundColor: Colors.indigo,
      automaticallyImplyLeading: false,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white), // Iconlar beyaz
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
      title: Text(text),
      leading: IconButton(
        onPressed:
            showLogout
                ? (onLogout ??
                    () => Navigator.pushReplacementNamed(context, '/login'))
                : () => Navigator.of(context).pop(),
        icon: Icon(showLogout ? Icons.logout : Icons.arrow_back),
        tooltip: showLogout ? 'Çıkış Yap' : 'Geri',
      ),
      actions: [
        IconButton(
          onPressed: onProfileTap,
          icon: const Icon(Icons.account_circle_outlined),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
