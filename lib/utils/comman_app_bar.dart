import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack; // 🔥 NEW

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.onBack, // 🔥 NEW
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 19, 4, 66),
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
              onPressed: () {
                if (onBack != null) {
                  onBack!(); // ✅ custom logic
                } else {
                  Navigator.of(context).maybePop(); // ✅ default
                }
              },
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: actions,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
