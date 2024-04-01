import 'dart:io';
import 'dart:convert';
import 'package:app_flutter/models/data_model.dart';
import 'package:app_flutter/providers/insert_image_provider.dart';
import 'package:app_flutter/widgets/horizontal_view.dart';
import 'package:flutter/material.dart';
import 'package:app_flutter/constants.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:provider/provider.dart';

class InsertImages extends StatefulWidget {
  const InsertImages({super.key});

  @override
  State<InsertImages> createState() => _InsertImagesState();
}

class _InsertImagesState extends State<InsertImages> {
  late Data data;
  bool isReady = false;

  Future<void> _saveJson() async {
    final dataJson = data.toJson();
    final jsonString = const JsonEncoder.withIndent('  ').convert(dataJson);
    await File(jsonData).writeAsString(jsonString);
  }

  Future<void> _loadJson() async {
    final file = File(jsonData);
    if (file.existsSync()) {
      final jsonString = await file.readAsString();
      final dataMap = json.decode(jsonString);
      data = Data.fromJson(dataMap);
    }
  }

  @override
  void initState() {
    _loadJson().whenComplete(() => setState(() => isReady = true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _actionButton(),
      body: isReady
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _sheetView()),
                  _sheetButtons(),
                ],
              ),
            )
          : null,
    );
  }

  Widget _sheetView() {
    final insertImageProvider = context.read<InsertImageProvider>();

    const gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      mainAxisExtent: 350.0,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      childAspectRatio: 1 / 2,
      crossAxisCount: 2,
    );

    return PageView.builder(
      controller: insertImageProvider.pageController,
      itemCount: data.sheets.length,
      itemBuilder: (context, indexPage) {
        final slots = data.sheets[indexPage].slots;

        return GridView.builder(
          gridDelegate: gridDelegate,
          itemCount: slots.length,
          itemBuilder: (contet, index) {
            final slotName = slots[index].name;
            final slotCell = slots[index].cells;
            final photos = slots[index].photos;

            return _photosCard(index, slotName, slotCell, photos);
          },
        );
      },
    );
  }

  Container _photosCard(
    int index,
    String slotName,
    String slotCells,
    List<String> photos,
  ) {
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
                slotCells,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: DropTarget(
            onDragDone: (details) {
              final insertImageProvider = context.read<InsertImageProvider>();
              final indexPage = insertImageProvider.sheetSelected;

              for (var file in details.files) {
                if (!photos.contains(file.path)) {
                  data.sheets[indexPage].slots[index].photos.add(file.path);
                }
              }
              setState(() {});
              _saveJson();
            },
            child: photos.isEmpty ? _addPhoto() : _photoView(index, photos),
          ),
        ),
      ]),
    );
  }

  Widget _sheetButtons() {
    final insertImageProvider = context.watch<InsertImageProvider>();
    final sheetSelected = insertImageProvider.sheetSelected;

    return HorizontalView(
      child: Row(
        children: List.generate(data.sheets.length, (index) {
          final isSelected = index == sheetSelected;
          return InkWell(
            onTap: () => insertImageProvider.setSheetSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Text(
                data.sheets[index].nameSheet,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : null,
                  fontSize: 16.0,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _photoView(int indexSlot, List<String> photos) {
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
        itemBuilder: (context, index) {
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
                child: Image.file(File(photos[index])),
              ),
              IconButton(
                onPressed: () {
                  final insertImageProvider =
                      context.read<InsertImageProvider>();
                  final indexPage = insertImageProvider.sheetSelected;
                  data.sheets[indexPage].slots[indexSlot].photos
                      .remove(photos[index]);
                  setState(() {});
                  _saveJson();
                },
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

  Widget _actionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      child: const Icon(Icons.play_arrow, color: Colors.white),
      onPressed: () async {
        final args = [
          "${Directory.current.path}/$imgToExcelPy",
          "${Directory.current.path}/$jsonData",
          data.templatePath,
          data.savePath,
        ];

        Process.run(pyExe, args);
      },
    );
  }
}
