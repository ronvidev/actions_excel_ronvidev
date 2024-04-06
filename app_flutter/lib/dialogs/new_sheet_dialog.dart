import 'package:app_flutter/models/sheet_model.dart';
import 'package:app_flutter/providers/insert_image_provider.dart';
import 'package:app_flutter/widgets/action_button.dart';
import 'package:app_flutter/widgets/input_text_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewSheetDialog extends StatefulWidget {
  const NewSheetDialog({super.key});

  @override
  State<NewSheetDialog> createState() => _NewSheetDialogState();
}

class _NewSheetDialogState extends State<NewSheetDialog> {
  void _closeDialog() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    return Center(
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8.0),
        child: SizedBox(
          width: 250.0,
          // height: 300.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                color: Theme.of(context).hoverColor,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Nueva hoja',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputTextBox(
                  title: 'Nombre',
                  controller: nameController,
                ),
              ),
              Container(
                width: double.infinity,
                color: Theme.of(context).hoverColor,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () => _closeDialog(),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: ActionButton(
                        child: const Text('Agregar'),
                        onPressed: () async {
                          await context
                              .read<InsertImageProvider>()
                              .addSheet(Sheet(
                                nameSheet: nameController.text,
                                slots: [],
                              ));

                          _closeDialog();
                        },
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
