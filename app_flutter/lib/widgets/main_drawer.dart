import 'package:app_flutter/pages/pages.dart';
import 'package:app_flutter/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.read<AppProvider>();

    return Drawer(
      width: 220.0,
      shape: const LinearBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'AutoExcel v0.1',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
          ),
          const Divider(),
          Expanded(
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
          ),
          SwitchListTile(
            value:
                Theme.of(context).brightness == Brightness.dark ? true : false,
            onChanged: (val) {
              appProvider.setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
            },
            title: const Text('Modo oscuro'),
          )
        ],
      ),
    );
  }
}
