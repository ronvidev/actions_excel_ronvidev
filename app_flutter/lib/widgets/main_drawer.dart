import 'package:autocells/config/constants.dart';
import 'package:autocells/pages/pages.dart';
import 'package:autocells/providers/providers.dart';
import 'package:autocells/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  void initState() {
    context.read<AppProvider>().getVersionApp();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final versionApp = appProvider.versionApp;

    return Drawer(
      width: 240.0,
      backgroundColor: Theme.of(context).canvasColor,
      shape: const LinearBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AutoExcel',
                      style: TextStyle(
                        fontSize: 18.0,
                        height: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'v$versionApp',
                      style: TextStyle(
                        height: 0.0,
                        fontSize: 14.0,
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                ActionButton(
                  child: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, kSettingsScreen);
                  },
                )
              ],
            ),
          ),
          // const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: pageNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  selectedColor: Theme.of(context).dividerColor,
                  selectedTileColor: Theme.of(context).splashColor,
                  splashColor: Colors.transparent,
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
            trackOutlineColor:
                const MaterialStatePropertyAll(Colors.transparent),
            thumbColor: MaterialStatePropertyAll(Theme.of(context).hintColor),
            value:
                Theme.of(context).brightness == Brightness.dark ? true : false,
            onChanged: (val) => appProvider.setThemeMode(
              val ? ThemeMode.dark : ThemeMode.light,
            ),
            title: const Text('Modo oscuro'),
          )
        ],
      ),
    );
  }
}
