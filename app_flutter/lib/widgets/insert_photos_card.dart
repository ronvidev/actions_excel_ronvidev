import 'dart:io';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

class InsertPhotosCard extends StatelessWidget {
  const InsertPhotosCard({
    super.key,
    required this.slotName,
    required this.cells,
    required this.photos,
    required this.onInsertPhoto,
    required this.onDeletePhoto,
  });

  final String slotName;
  final String cells;
  final List<String> photos;
  final void Function(String photoPaths) onInsertPhoto;
  final void Function(String photoPath) onDeletePhoto;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          color: Colors.grey.withOpacity(0.2),
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(slotName),
              Text(
                cells,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: DropTarget(
            onDragDone: (details) {
              for (var file in details.files) {
                if (!photos.contains(file.path)) {
                  onInsertPhoto(file.path);
                }
              }
            },
            child: photos.isEmpty ? _addPhoto() : _photoView(photos),
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
                width: double.infinity,
                height: double.infinity,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: Image.file(File(photos[indexPhoto])),
              ),
              IconButton(
                onPressed: () => onDeletePhoto(photos[indexPhoto]),
                icon: const Icon(Icons.close, color: Colors.red),
              )
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
