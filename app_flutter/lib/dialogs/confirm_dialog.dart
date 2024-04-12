import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({super.key, this.onConfirm, this.buttonText});

  final VoidCallback? onConfirm;
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    void closeDialog() => Navigator.pop(context);

    return Center(
      child: Material(
        color: Theme.of(context).dialogBackgroundColor,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8.0),
        child: SizedBox(
          width: 250.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.all(8.0),
                child:const Text(
                  '¿Está seguro?',
                  style:  TextStyle(fontSize: 18.0),
                ),
              ),
              Container(
                width: double.infinity,
                color: Theme.of(context).canvasColor,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => closeDialog(),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          onConfirm?.call();
                          closeDialog();
                        },
                        child: Text(buttonText ?? 'Confirmar'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}