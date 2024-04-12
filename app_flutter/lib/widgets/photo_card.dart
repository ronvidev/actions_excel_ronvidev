import 'dart:io';

import 'package:flutter/material.dart';

class PhotoCard extends StatelessWidget {
  const PhotoCard({
    super.key,
    this.title,
    this.onExpand,
    this.onDelete,
    required this.photoPath,
  });

  final String? title;
  final String photoPath;
  final VoidCallback? onExpand;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: Theme.of(context).hoverColor,
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: decoration,
      child: Column(
        children: [
          _bar(context),
          Expanded(child: Image.file(File(photoPath))),
        ],
      ),
    );
  }

  Widget _bar(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            ),
          ),
          _actionButtonPhoto(
            iconData: Icons.open_in_full,
            color: Theme.of(context).dividerColor.withOpacity(0.3),
            onPressed: onExpand,
          ),
          _actionButtonPhoto(
            iconData: Icons.close,
            color: Colors.red.withOpacity(0.7),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  Widget _actionButtonPhoto({
    IconData? iconData,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return IconButton(
      iconSize: 16.0,
      onPressed: onPressed,
      icon: Icon(iconData, color: color),
      style: const ButtonStyle(
        shape: MaterialStatePropertyAll(LinearBorder.none),
        backgroundColor: MaterialStatePropertyAll(Colors.transparent),
        minimumSize: MaterialStatePropertyAll(Size.zero),
        padding: MaterialStatePropertyAll(
          EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        ),
      ),
    );
  }
}
