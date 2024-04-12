import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final windowInstance = WindowManager.instance;

    Future<void> maxButtonAction() async {
      if (await windowInstance.isMaximized()) {
        await windowInstance.restore();
      } else {
        await windowInstance.maximize();
      }
    }

    return Material(
      child: Column(
        children: [
          Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            height: 36.0,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/app_icon.ico"),
                ),
                Expanded(
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) =>
                        windowInstance.startDragging(),
                    onVerticalDragUpdate: (details) =>
                        windowInstance.startDragging(),
                    onDoubleTap: () => maxButtonAction(),
                    child: Container(
                      color: Colors.transparent,
                      constraints: const BoxConstraints.expand(),
                      alignment: Alignment.centerLeft,
                      child: const Text("AutoCell"),
                    ),
                  ),
                ),
                _button(Icons.minimize, () => windowInstance.minimize()),
                const SizedBox(width: 4.0),
                _button(Icons.rectangle_outlined, maxButtonAction),
                const SizedBox(width: 4.0),
                _button(Icons.close, () => windowInstance.close()),
                const SizedBox(width: 4.0),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _button(IconData iconData, VoidCallback onPressed) {
    return IconButton(
      style: ButtonStyle(
          minimumSize: const MaterialStatePropertyAll(Size.zero),
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
          padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 12.0,
          ))),
      iconSize: 16.0,
      onPressed: onPressed,
      icon: Icon(iconData),
    );
  }
}
