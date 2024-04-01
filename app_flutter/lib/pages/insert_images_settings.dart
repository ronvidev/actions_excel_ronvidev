import 'dart:convert';
import 'dart:io';
import 'package:app_flutter/constants.dart';
import 'package:flutter/material.dart';

class InsertImagesSettings extends StatefulWidget {
  const InsertImagesSettings({super.key});

  @override
  State<InsertImagesSettings> createState() => _InsertImagesSettingsState();
}

class _InsertImagesSettingsState extends State<InsertImagesSettings> {
  Map<String, dynamic> data = {"nameSheet": "", "images": []};

  void _addSlot() {
    data["images"]!.add({
      "name": null,
      "celda": null,
      "cols": null,
      "rows": null,
      "isUp": true,
      "photos": []
    });
    setState(() {});
    _saveJson();
  }

  void _deleteSlot(Map<String, dynamic> object) {
    data["images"]!.remove(object);
    setState(() {});
    _saveJson();
  }

  void _saveJson() {
    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    File(jsonData).writeAsString(jsonString);
  }

  void _loadJson() {
    final file = File(jsonData);
    if (file.existsSync()) {
      file.readAsString().then((String jsonString) {
        data = json.decode(jsonString);
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _saveJson();
    super.dispose();
  }

  @override
  void initState() {
    _loadJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      floatingActionButton: _actionButton(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButton<String>(
              underline: const SizedBox(),
              focusColor: Colors.transparent,
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  child: Text(
                    data["nameSheet"],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                )
              ],
              onChanged: (val) {},
            ),
            Expanded(
              child: ListView.builder(
                itemCount: data["images"]!.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    slot(index),
                    if (index == data["images"]!.length - 1)
                      const SizedBox(height: 100.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.greenAccent,
      onPressed: _addSlot,
      child: const Icon(Icons.add),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: const Text("Ajustes de Insertar imágenes"),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget slot(int index) {
    final textControllerCell = TextEditingController();
    final textControllerCol = TextEditingController();
    final textControllerRow = TextEditingController();

    textControllerCell.text = data["images"]![index]["celda"] ?? "";
    textControllerCol.text = data["images"]![index]["cols"] ?? "";
    textControllerRow.text = data["images"]![index]["rows"] ?? "";

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          height: 70.0,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(labelText: "Celda"),
                controller: textControllerCell,
                onChanged: (value) {
                  data["images"]![index]["celda"] = textControllerCell.text;
                },
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(labelText: "Columnas"),
                controller: textControllerCol,
                onChanged: (value) {
                  data["images"]![index]["cols"] = textControllerCol.text;
                },
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(labelText: "Filas"),
                controller: textControllerRow,
                onChanged: (value) {
                  data["images"]![index]["rows"] = textControllerRow.text;
                },
              ),
            ),
            const SizedBox(width: 8.0),
            const Text("Abajo"),
            Switch(
              activeColor: Colors.green,
              value: data["images"]![index]["isUp"],
              onChanged: (val) {
                setState(() => data["images"]![index]["isUp"] = val);
                _saveJson();
              },
            ),
            const Text("Arriba"),
            const SizedBox(width: 8.0),
            IconButton(
              onPressed: () => _deleteSlot(data["images"]![index]),
              icon: const Icon(Icons.close, color: Colors.red),
            )
          ]),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
