import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/note_provider.dart';

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
    Provider.of<NoteProvider>(context, listen: false);
    return AppBar(
      backgroundColor: Colors.indigo[100],
      automaticallyImplyLeading: false,
      title: Text(text, style: const TextStyle(fontSize: 25)),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back),
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
