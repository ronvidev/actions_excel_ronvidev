import 'package:flutter/material.dart';

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Material(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            constraints: const BoxConstraints(
              maxWidth: 500.0,
              maxHeight: 200.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Actualización',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Divider(),
                const LinearProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
