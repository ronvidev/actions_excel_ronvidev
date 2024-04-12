import 'dart:io';
import 'package:autocells/models/image_slot_model.dart';
import 'package:autocells/providers/excel_template_provider.dart';
import 'package:autocells/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

class SlotCard extends StatefulWidget {
  const SlotCard({
    super.key,
    required this.slot,
    this.onInsertPhoto,
    this.onDeletePhoto,
    this.onChangedNameSlot,
    this.onChangedCells,
  });

  final ImageSlot slot;
  final void Function(String photoPaths)? onInsertPhoto;
  final void Function(String photoPath)? onDeletePhoto;
  final void Function(String value)? onChangedNameSlot;
  final void Function(String value)? onChangedCells;

  @override
  State<SlotCard> createState() => _SlotCardState();
}

class _SlotCardState extends State<SlotCard> {
  void _onDragPhoto(DropDoneDetails details) {
    for (var file in details.files) {
      if (!widget.slot.photos.contains(file.path)) {
        if (widget.onInsertPhoto != null) widget.onInsertPhoto!(file.path);
      }
    }
  }

  void _deleteSlot(BuildContext context) {
    context.read<ExcelTemplateProvider>().deleteSlot(widget.slot);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(8.0),
      child: Column(children: [
        Row(children: [
          Container(
            color: Theme.of(context).primaryColor,
            width: 80.0,
            child: TextEditable(
              initialValue: widget.slot.cells,
              alignment: Alignment.center,
              textAlign: TextAlign.center,
              onChanged: widget.onChangedCells,
            ),
          ),
          Expanded(
            child: TextEditable(
              initialValue: widget.slot.name,
              onChanged: widget.onChangedNameSlot,
            ),
          ),
          IconButton(
            style: const ButtonStyle(
              shape: MaterialStatePropertyAll(LinearBorder.none),
            ),
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => _deleteSlot(context),
          ),
        ]),
        Expanded(
          child: DropTarget(
            onDragDone: _onDragPhoto,
            child: widget.slot.photos.isEmpty
                ? _addPhoto()
                : _photoView(widget.slot.photos),
          ),
        ),
      ]),
    );
  }

  Widget _photoView(List<String> photos) {
    const delegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      mainAxisExtent: 240.0,
    );

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: delegate,
      itemCount: photos.length,
      itemBuilder: (context, indexPhoto) => PhotoCard(
        title: p.basename(photos[indexPhoto]),
        photoPath: photos[indexPhoto],
        onExpand: () => _expandPhoto(photos, indexPhoto),
        onDelete: () => widget.onDeletePhoto?.call(photos[indexPhoto]),
      ),
    );
  }

  Future<void> _expandPhoto(List<String> photos, int indexPhoto) async {
    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                    child: Image.file(
                      File(photos[indexPhoto]),
                      isAntiAlias: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
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
          Text(
            "Arrastre aquí",
            style: TextStyle(color: Theme.of(context).hintColor),
          )
        ],
      ),
    );
  }
}
