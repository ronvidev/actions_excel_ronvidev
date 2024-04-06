import 'package:app_flutter/pages/pages.dart';
import 'package:app_flutter/providers/app_provider.dart';
import 'package:app_flutter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> pages = [
    const InsertImagesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final pageSelected = appProvider.pageSelected;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const MainDrawer(),
      appBar: _appBar(context, pageSelected),
      body: pages[pageSelected],
    );
  }

  AppBar _appBar(BuildContext context, int pageSelected) {
    Widget leading = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: ActionButton(
        color: Colors.black.withOpacity(0.2),
        child: const Icon(Icons.menu, color: Colors.white),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
    );

    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading: leading,
      title: Text(
        pageNames[pageSelected],
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
