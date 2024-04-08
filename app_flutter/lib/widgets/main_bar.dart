import 'package:flutter/material.dart';

PreferredSizeWidget mainBar({
  required BuildContext context,
  Widget? leading,
  String? title,
}) {
  return AppBar(
    leading: leading != null
        ? Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: leading,
          )
        : null,
    title: Text(
      title ?? '',
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        // color: Colors.white,
      ),
    ),
  );
}
