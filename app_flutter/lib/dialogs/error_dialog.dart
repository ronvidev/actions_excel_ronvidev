import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key, required this.msg});

  final String msg;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Material(
          color: Theme.of(context).dialogBackgroundColor,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 600.0,
              maxHeight: 800.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  color: Theme.of(context).hoverColor,
                  child: const Text(
                    'Error',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 8.0,
                      ),
                      child: Text(msg),
                    ),
                  ),
                ),
                Container(
                  height: 36.0,
                  color: Theme.of(context).hoverColor,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    splashFactory: NoSplash.splashFactory,
                    child: const Center(child: Text('Cerrar')),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
