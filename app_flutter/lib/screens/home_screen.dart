import 'package:autocells/pages/pages.dart';
import 'package:autocells/providers/app_provider.dart';
import 'package:autocells/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> pages = [
    const ExcelTemplatePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final pageSelected = appProvider.pageSelected;

    return MainScaffold(child: pages[pageSelected]);
  }
}
