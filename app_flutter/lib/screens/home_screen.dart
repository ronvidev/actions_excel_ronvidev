import 'package:app_flutter/pages/insert_image_page.dart';
import 'package:app_flutter/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageSelected = 0;

  List<String> pageNames = [
    "Insertar imágenes",
  ];

  List<Widget> pages = [
    const InsertImagesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final pageSelected = appProvider.pageSelected;

    return Scaffold(
      drawer: _drawer(),
      appBar: AppBar(title: Text(pageNames[pageSelected])),
      body: pages[pageSelected],
    );
  }

  Widget _drawer() {
    final appProvider = context.read<AppProvider>();

    return Drawer(
      width: 240.0,
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return ListTile(
            selected: index == appProvider.pageSelected,
            title: Text(pageNames[index]),
            onTap: () {
              appProvider.setPageSelected(index);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
