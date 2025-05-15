import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final VoidCallback? onMenuTap;
  final VoidCallback? onProfileTap;

  const CustomAppBar({
    super.key,
    required this.text,
    this.onMenuTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    return AppBar(
      backgroundColor: const Color(0xff02003C),
      automaticallyImplyLeading: false,
      title: Text(text, style: const TextStyle(fontSize: 25)),
      centerTitle: true,
      leading: IconButton(onPressed: onMenuTap, icon: const Icon(Icons.menu)),
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
