import 'dart:io';
import 'package:app_flutter/providers/insert_image_provider.dart';
import 'package:app_flutter/widgets/horizontal_view.dart';
import 'package:app_flutter/widgets/insert_photos_card.dart';
import 'package:flutter/material.dart';
import 'package:app_flutter/constants.dart';
import 'package:provider/provider.dart';

class InsertImagesPage extends StatefulWidget {
  const InsertImagesPage({super.key});

  @override
  State<InsertImagesPage> createState() => _InsertImagesPageState();
}

class _InsertImagesPageState extends State<InsertImagesPage> {
  bool isReady = false;

  Future<void> _loadData() async {
    await context.read<InsertImageProvider>().loadJson();
    setState(() => isReady = true);
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _actionButton(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isReady
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _sheetView()),
                  _sheetButtons(),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _sheetView() {
    final insertImageProvider = context.watch<InsertImageProvider>();
    final data = insertImageProvider.data;

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
          itemBuilder: (contet, index) => InsertPhotosCard(
            slotName: slots[index].name,
            cells: slots[index].cells,
            photos: slots[index].photos,
            onInsertPhoto: (photoPath) =>
                insertImageProvider.insertPhoto(index, photoPath),
            onDeletePhoto: (photoPath) =>
                insertImageProvider.deletePhoto(index, photoPath),
          ),
        );
      },
    );
  }

  Widget _sheetButtons() {
    final insertImageProvider = context.watch<InsertImageProvider>();
    final sheetSelected = insertImageProvider.sheetSelected;
    final data = insertImageProvider.data;

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

  Widget _actionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      child: const Icon(Icons.play_arrow, color: Colors.white),
      onPressed: () async {
        setState(() => isReady = false);
        final insertImageProvider = context.watch<InsertImageProvider>();
        final data = insertImageProvider.data;

        final args = [
          "${Directory.current.path}/$imgToExcelPyPath",
          "${Directory.current.path}/$jsonDataPath",
          data.templatePath,
          data.savePath,
        ];

        Process.run(pyExe, args).whenComplete(() {
          setState(() => isReady = true);
        });
      },
    );
  }
}
