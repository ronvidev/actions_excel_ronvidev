import 'dart:io';
import 'package:flutter/material.dart';
import 'package:autocells/widgets/widgets.dart';
import 'package:autocells/dialogs/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:autocells/providers/providers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:autocells/config/constants.dart';
import 'package:path/path.dart' as p;

class ExcelTemplatePage extends StatefulWidget {
  const ExcelTemplatePage({super.key});

  @override
  State<ExcelTemplatePage> createState() => _ExcelTemplatePageState();
}

class _ExcelTemplatePageState extends State<ExcelTemplatePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final nameController = TextEditingController();
  final savePathController = TextEditingController();
  final templatesPathController = TextEditingController();
  final templateController = TextEditingController();

  bool _isReady = false;
  bool _inProcess = false;

  void _pickerTemplatePath(ExcelTemplateProvider excelTemplateProvider) async {
    final result = await FilePicker.platform.pickFiles(
      lockParentWindow: true,
      allowedExtensions: ["xlsx"],
      type: FileType.custom,
    );

    if (result != null) {
      final path = result.files.first.path;
      if (path != null) {
        excelTemplateProvider.copyTemplate(path);
        final templateName = p.basenameWithoutExtension(path);
        setState(() => templateController.text = templateName);
      }
    }
  }

  void _showError(String msg) {
    showDialog(context: context, builder: (context) => ErrorDialog(msg: msg));
  }

  Future<void> _loadData() async {
    await context.read<ExcelTemplateProvider>().loadData();
    setState(() => _isReady = true);
  }

  void _onProcess() async {
    setState(() => _inProcess = true);
    final excelTemplateProvider = context.read<ExcelTemplateProvider>();

    String nameFile = nameController.text;
    if (nameFile.isEmpty) nameFile = "sin-título";
    final templateName = excelTemplateProvider.templateName ?? '';
    final templatesPath = excelTemplateProvider.templatesPath ?? '';
    final savePath = excelTemplateProvider.savePath ?? '';

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
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MainDrawer(),
      body: Column(
        children: [
          MainBar(
            title: 'Excel desde plantilla',
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            child: _configSpace(),
          ),
          if (_isReady) _actionBar(),
          Expanded(
            child: _isReady
                ? _sheetView()
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  Widget _actionBar() {
    final excelTemplateProvider = context.watch<ExcelTemplateProvider>();
    final templates = excelTemplateProvider.templates;

    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.2),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            onPressed: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => ConfirmDialog(
                buttonText: 'Limpiar',
                onConfirm: excelTemplateProvider.deleteAll,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          ComboBox<int>(
            width: 320.0,
            controller: templateController,
            initialValue: excelTemplateProvider.templateName,
            hintText: 'Seleccione una plantilla',
            suffix: _addTemplateButton(excelTemplateProvider),
            onSelected: (item) => excelTemplateProvider
                .setTemplateName(item != null ? templates[item] : null),
            items: List.generate(
              templates.length,
              (index) => ComboBoxItem(label: templates[index], value: index),
            ),
          ),
          const SizedBox(width: 8.0),
          SizedBox(
            width: 250.0,
            child: InputTextBox(
              controller: nameController,
              hintText: 'Nombre de archivo',
              onChanged: (value) {
                excelTemplateProvider.nameFile = value;
              },
            ),
          ),
          const Expanded(child: SizedBox()),
          ProcessButton(
            inProcess: _inProcess,
            onPressed: _inProcess ? null : _onProcess,
            icon: Icon(Icons.play_arrow, color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }

  IconButton _addTemplateButton(ExcelTemplateProvider excelTemplateProvider) {
    return IconButton(
      icon: const Icon(Icons.add_circle_outline),
      style: const ButtonStyle(
        shape: MaterialStatePropertyAll(LinearBorder.none),
      ),
      onPressed: () => _pickerTemplatePath(excelTemplateProvider),
    );
  }

  Widget _sheetView() {
    final excelTemplateProvider = context.watch<ExcelTemplateProvider>();
    final data = excelTemplateProvider.data;
    final pageTypeController = PageController(
      initialPage: excelTemplateProvider.typeSelected,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                IconButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      excelTemplateProvider.typeSelected == 0
                          ? Theme.of(context).focusColor
                          : null,
                    ),
                  ),
                  icon: const Icon(Icons.text_snippet_rounded),
                  onPressed: () {
                    excelTemplateProvider.setTypeSelected(0);
                    pageTypeController.jumpToPage(0);
                  },
                ),
                const SizedBox(width: 4.0),
                IconButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      excelTemplateProvider.typeSelected == 1
                          ? Theme.of(context).focusColor
                          : null,
                    ),
                  ),
                  icon: const Icon(Icons.image),
                  onPressed: () {
                    excelTemplateProvider.setTypeSelected(1);
                    pageTypeController.jumpToPage(1);
                  },
                ),
                if (excelTemplateProvider.typeSelected == 0)
                  ..._infoTextActions(),
                if (excelTemplateProvider.typeSelected == 1)
                  ..._insertImagesActions(),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: excelTemplateProvider.pageSheetController,
              itemCount: data.sheets.length,
              itemBuilder: (context, indexPage) => PageView(
                controller: pageTypeController,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: [
                  _infoTextPage(indexPage),
                  _insertImagesPage(indexPage),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          _sheetButtons(),
        ],
      ),
    );
  }

  Widget _insertImagesPage(int indexPage) {
    final excelTemplateProvider = context.watch<ExcelTemplateProvider>();
    final data = excelTemplateProvider.data;
    final slots = data.sheets[indexPage].imageSlots;

    final width = MediaQuery.of(context).size.width;

    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      mainAxisExtent: 350.0,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      childAspectRatio: 1 / 2,
      crossAxisCount: width > 1600 ? 3 : 2,
    );

    return GridView.builder(
      gridDelegate: gridDelegate,
      itemCount: slots.length,
      itemBuilder: (contet, index) => SlotCard(
        slot: slots[index],
        onInsertPhoto: (photoPath) =>
            excelTemplateProvider.insertPhoto(index, photoPath),
        onDeletePhoto: (photoPath) =>
            excelTemplateProvider.deletePhoto(index, photoPath),
        onChangedNameSlot: (value) =>
            excelTemplateProvider.updateNameSlot(index, value),
        onChangedCells: (value) =>
            excelTemplateProvider.updateSlotCells(index, value),
      ),
    );
  }

  List _insertImagesActions() {
    return [
      const SizedBox(height: 20.0, child: VerticalDivider()),
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const NewSlotDialog(),
        ),
      ),
    ];
  }

  Widget _infoTextPage(int indexPage) {
    final excelTemplateProvider = context.watch<ExcelTemplateProvider>();
    final data = excelTemplateProvider.data;
    final textCells = data.sheets[indexPage].textSlots;

    const gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      mainAxisExtent: 80.0,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      crossAxisCount: 1,
    );

    return GridView.builder(
      gridDelegate: gridDelegate,
      itemCount: textCells.length,
      itemBuilder: (context, index) {
        final textSlot = textCells[index];

        return CellTile(
          textCell: textSlot,
          onEdit: () => showDialog(
            context: context,
            builder: (context) => TextSlotDialog(
              index: index,
              textSlot: textSlot,
            ),
          ),
          onChanged: (val) => excelTemplateProvider.updateTextCell(index, val),
          onDelete: () => excelTemplateProvider.deleteTextCell(textSlot),
        );
      },
    );
  }

  List _infoTextActions() {
    return [
      const SizedBox(height: 20.0, child: VerticalDivider()),
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const TextSlotDialog(),
        ),
      ),
    ];
  }

  Widget _sheetButtons() {
    final excelTemplateProvider = context.watch<ExcelTemplateProvider>();
    int sheetSelected = excelTemplateProvider.sheetSelected;
    final sheets = excelTemplateProvider.data.sheets;

    if (sheetSelected >= sheets.length) sheetSelected = sheets.length - 1;

    return HorizontalView(
      child: Row(
        children: [
          Row(
            children: List.generate(sheets.length, (index) {
              final isSelected = index == sheetSelected;

              return GestureDetector(
                onSecondaryTapDown: (details) {
                  showMenu(
                    context: context,
                    color: Theme.of(context).canvasColor,
                    popUpAnimationStyle:
                        AnimationStyle(duration: Durations.medium3),
                    position: RelativeRect.fromLTRB(
                      details.globalPosition.dx,
                      details.globalPosition.dy,
                      details.globalPosition.dx,
                      details.globalPosition.dy,
                    ),
                    items: [
                      PopupMenuItem(
                        child: const Text('Editar'),
                        onTap: () => showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => SheetDialog(
                            index: index,
                            sheet: sheets[index],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        child: const Text('Eliminar'),
                        onTap: () =>
                            excelTemplateProvider.deleteSheet(sheets[index]),
                      ),
                    ],
                  );
                },
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  color: isSelected
                      ? Theme.of(context).focusColor
                      : Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4.0),
                  ),
                  child: InkWell(
                    splashFactory: NoSplash.splashFactory,
                    onTap: () => excelTemplateProvider.setSheetSelected(index),
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
                                  color: Theme.of(context).colorScheme.primary,
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
          _addSheetButton()
        ],
      ),
    );
  }

  IconButton _addSheetButton() {
    return IconButton(
      style: ButtonStyle(
        shape: const MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
          ),
        ),
        backgroundColor: MaterialStatePropertyAll(
          Theme.of(context).cardColor.withOpacity(0.3),
        ),
      ),
      onPressed: () => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const SheetDialog(),
      ),
      icon: const Icon(Icons.add),
    );
  }

  Widget _configSpace() {
    final excelTemplateProvider = context.read<ExcelTemplateProvider>();

    templatesPathController.text = excelTemplateProvider.templatesPath ?? '';
    savePathController.text = excelTemplateProvider.savePath ?? '';

    return Column(children: [
      TextPickerBox(
        title: 'Carpeta de plantillas',
        controller: templatesPathController,
        onChanged: excelTemplateProvider.setTemplatesPath,
      ),
      const SizedBox(height: 10.0),
      TextPickerBox(
        title: 'Carpeta de guardado',
        controller: savePathController,
        onChanged: excelTemplateProvider.setSavePath,
      ),
    ]);
  }
}
