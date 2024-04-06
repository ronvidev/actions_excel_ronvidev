import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app_flutter/widgets/widgets.dart';
import 'package:app_flutter/dialogs/dialogs.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:app_flutter/providers/providers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:app_flutter/config/constants.dart';

class InsertImagesPage extends StatefulWidget {
  const InsertImagesPage({super.key});

  @override
  State<InsertImagesPage> createState() => _InsertImagesPageState();
}

class _InsertImagesPageState extends State<InsertImagesPage> {
  final nameController = TextEditingController();
  final savePathController = TextEditingController();
  final templatesPathController = TextEditingController();
  final templateController = TextEditingController();

  bool _configIsOpened = false;
  bool _isReady = false;
  bool _inProcess = false;

  void _pickerTemplatePath(InsertImageProvider insertImageProvider) async {
    final result = await FilePicker.platform.pickFiles(
      lockParentWindow: true,
      allowedExtensions: ["xlsx"],
      type: FileType.custom,
    );

    if (result != null) {
      final path = result.files.first.path;
      if (path != null) {
        insertImageProvider.copyTemplate(path);
        final templateName = p.basenameWithoutExtension(path);
        setState(() => templateController.text = templateName);
      }
    }
  }

  void _showError(String msg) {
    showDialog(context: context, builder: (context) => ErrorDialog(msg: msg));
  }

  Future<void> _loadData() async {
    await context.read<InsertImageProvider>().loadData();
    setState(() => _isReady = true);
  }

  void _onProcess() async {
    setState(() => _inProcess = true);
    final insertImageProvider = context.read<InsertImageProvider>();

    String nameFile = nameController.text;
    if (nameFile.isEmpty) nameFile = "sin-título";
    final templateName = insertImageProvider.templateName ?? '';
    final templatesPath = insertImageProvider.templatesPath ?? '';
    final savePath = insertImageProvider.savePath ?? '';

    if (templateName.isNotEmpty &&
        templatesPath.isNotEmpty &&
        savePath.isNotEmpty) {
      final args = [
        "${Directory.current.path}/$imgToExcelPyPath",
        "$templatesPath/$templateName.json",
        "$templatesPath/$templateName.xlsx",
        "$savePath/$nameFile.xlsx",
      ];

      final out = await Process.run(pyExe, args);
      final outString = out.stdout;
      if (outString.isNotEmpty) _showError(outString);
    } else {
      _showError('Faltan datos');
    }
    setState(() => _inProcess = false);
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _configSpace(),
        if (_isReady) _actionBar(),
        Expanded(
          child: _isReady
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _sheetView()),
                    _sheetButtons(),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  Widget _configSpace() {
    final insertImageProvider = context.read<InsertImageProvider>();

    templatesPathController.text = insertImageProvider.templatesPath ?? '';
    savePathController.text = insertImageProvider.savePath ?? '';

    return ConfigSpace(
      isOpened: _configIsOpened,
      height: 160.0,
      child: Column(children: [
        TextPickerBox(
          title: 'Carpeta de plantillas',
          controller: templatesPathController,
          onChanged: insertImageProvider.setTemplatesPath,
        ),
        const SizedBox(height: 10.0),
        TextPickerBox(
          title: 'Carpeta de guardado',
          controller: savePathController,
          onChanged: insertImageProvider.setSavePath,
        ),
      ]),
    );
  }

  Widget _actionBar() {
    final insertImageProvider = context.watch<InsertImageProvider>();
    final templates = insertImageProvider.templates;

    return Container(
      color: Theme.of(context).primaryColor.withAlpha(20),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ComboBox<int>(
            width: 300.0,
            controller: templateController,
            initialValue: insertImageProvider.templateName,
            hintText: 'Seleccione una plantilla',
            onSelected: (item) => item != null
                ? insertImageProvider.setTemplateName(templates[item])
                : insertImageProvider.setTemplateName(null),
            items: List.generate(
              templates.length,
              (index) => ComboBoxItem(
                label: templates[index],
                value: index,
              ),
            ),
            suffix: ActionButton(
              borderRadius: BorderRadius.zero,
              onPressed: () => _pickerTemplatePath(insertImageProvider),
              child: const Icon(Icons.add_circle_outline),
            ),
          ),
          const SizedBox(width: 8.0),
          SizedBox(
            width: 180.0,
            child: InputTextBox(
              controller: nameController,
              hintText: 'Nombre de archivo',
              onChanged: (value) {
                insertImageProvider.nameFile = value;
              },
            ),
          ),
          const SizedBox(width: 8.0),
          _processButton(),
          const Expanded(child: SizedBox()),
          ActionButton(
            onPressed: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const NewSlotDialog(),
            ),
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 8.0),
          ActionButton(
            onPressed: () => setState(() {
              _configIsOpened = !_configIsOpened;
              insertImageProvider.loadData();
            }),
            child: Icon(
              _configIsOpened
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sheetView() {
    final insertImageProvider = context.watch<InsertImageProvider>();
    final data = insertImageProvider.data;

    final width = MediaQuery.of(context).size.width;

    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      mainAxisExtent: 350.0,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      childAspectRatio: 1 / 2,
      crossAxisCount: width > 1600 ? 3 : 2,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: insertImageProvider.pageController,
        itemCount: data.sheets.length,
        itemBuilder: (context, indexPage) {
          final slots = data.sheets[indexPage].slots;

          return GridView.builder(
            gridDelegate: gridDelegate,
            itemCount: slots.length,
            itemBuilder: (contet, index) => InsertPhotosCard(
              slot: slots[index],
              onInsertPhoto: (photoPath) =>
                  insertImageProvider.insertPhoto(index, photoPath),
              onDeletePhoto: (photoPath) =>
                  insertImageProvider.deletePhoto(index, photoPath),
              onChangedNameSlot: (value) =>
                  insertImageProvider.setNameSlot(index, value),
              onChangedCells: (value) =>
                  insertImageProvider.setCells(index, value),
            ),
          );
        },
      ),
    );
  }

  Widget _sheetButtons() {
    final insertImageProvider = context.watch<InsertImageProvider>();
    final sheetSelected = insertImageProvider.sheetSelected;
    final sheets = insertImageProvider.data.sheets;

    return HorizontalView(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Row(
            children: List.generate(sheets.length, (index) {
              final isSelected = index == sheetSelected;

              return GestureDetector(
                onSecondaryTapDown: (details) {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      details.globalPosition.dx,
                      details.globalPosition.dy - 60,
                      details.globalPosition.dx,
                      details.globalPosition.dy - 60,
                    ),
                    items: [
                      PopupMenuItem(
                        value: 1,
                        child: const Text('Eliminar'),
                        onTap: () =>
                            insertImageProvider.deleteSheet(sheets[index]),
                      ),
                    ],
                  );
                },
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  color: isSelected ? Theme.of(context).focusColor : null,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4.0),
                  ),
                  child: InkWell(
                    splashFactory: NoSplash.splashFactory,
                    onTap: () => insertImageProvider.setSheetSelected(index),
                    child: AnimatedContainer(
                      duration: Durations.short2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: Stack(
                        children: [
                          Text(
                            sheets[index].nameSheet,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          if (isSelected)
                            Positioned(
                              left: 0.0,
                              right: 0.0,
                              bottom: 0.0,
                              child: Container(
                                height: 2.0,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          ActionButton(
            onPressed: () => showDialog(
              context: context,
              barrierDismissible :false,
              builder: (context) => const NewSheetDialog(),
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(4.0),
            ),
            child: const Icon(Icons.add),
          )
        ],
      ),
    );
  }

  Widget _processButton() {
    return ActionButton(
      color: Theme.of(context).primaryColor,
      onPressed: _inProcess ? null : _onProcess,
      child: _inProcess
          ? const SizedBox.square(
              dimension: 15.0,
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.play_arrow, color: Colors.white),
    );
  }
}
