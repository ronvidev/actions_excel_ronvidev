import 'dart:io';
import 'package:app_flutter/models/slot_model.dart';
import 'package:app_flutter/providers/insert_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:app_flutter/widgets/action_button.dart';
import 'package:app_flutter/widgets/text_editable.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:provider/provider.dart';

class InsertPhotosCard extends StatelessWidget {
  const InsertPhotosCard({
    super.key,
    required this.slot,
    this.onInsertPhoto,
    this.onDeletePhoto,
    this.onChangedNameSlot,
    this.onChangedCells,
  });

  final Slot slot;
  final void Function(String photoPaths)? onInsertPhoto;
  final void Function(String photoPath)? onDeletePhoto;
  final void Function(String value)? onChangedNameSlot;
  final void Function(String value)? onChangedCells;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).hoverColor,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(8.0),
      child: Column(children: [
        Stack(
          children: [
            Positioned(
              top: 0.0,
              bottom: 0.0,
              child: Container(
                alignment: Alignment.centerLeft,
                color: Theme.of(context).hoverColor,
                width: 80.0,
                child: TextEditable(
                  initialValue: slot.cells,
                  onChanged: onChangedCells,
                ),
              ),
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(width: 80.0),
              Expanded(
                child: TextEditable(
                  maxLines: null,
                  initialValue: slot.name,
                  onChanged: onChangedNameSlot,
                ),
              ),
              const SizedBox(width: 44.0),
            ]),
            Positioned(
              top: 0.0,
              bottom: 0.0,
              right: 0.0,
              child: ActionButton(
                child: const Icon(Icons.close, color: Colors.red,),
                onPressed: () => context.read<InsertImageProvider>().deleteSlot(slot),
              ),
            )
          ],
        ),
        Expanded(
          child: DropTarget(
            onDragDone: (details) {
              for (var file in details.files) {
                if (!slot.photos.contains(file.path)) {
                  if (onInsertPhoto != null) onInsertPhoto!(file.path);
                }
              }
            },
            child: slot.photos.isEmpty ? _addPhoto() : _photoView(slot.photos),
          ),
        ),
      ]),
    );
  }

  Widget _photoView(List<String> photos) {
    const delegate = SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 200.0,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      mainAxisExtent: 250.0,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: delegate,
        itemCount: photos.length,
        itemBuilder: (context, indexPhoto) {
          return Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                constraints: const BoxConstraints.expand(),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).hoverColor,
                ),
                child: Image.file(File(photos[indexPhoto]), isAntiAlias: true),
              ),
              Column(
                children: [
                  ActionButton(
                    color: Colors.transparent,
                    onPressed: onDeletePhoto != null
                        ? () => onDeletePhoto!(photos[indexPhoto])
                        : null,
                    child: Icon(
                      Icons.close,
                      color: Colors.red.withOpacity(0.7),
                    ),
                  ),
                  ActionButton(
                    color: Colors.transparent,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: InteractiveViewer(
                          scaleFactor: 1000,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 24.0,
                                horizontal: 48.0,
                              ),
                              child: Material(
                                clipBehavior: Clip.antiAlias,
                                borderRadius: BorderRadius.circular(8.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Image.file(File(photos[indexPhoto]),
                                      isAntiAlias: true),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.open_in_full,
                      color: Theme.of(context).hintColor.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _addPhoto() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo,
            color: Colors.grey.withOpacity(0.3),
          ),
          const SizedBox(height: 8.0),
          const Text("Arrastre aquí")
        ],
      ),
    );
  }
}
