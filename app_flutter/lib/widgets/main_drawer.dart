import 'package:autocells/config/constants.dart';
import 'package:autocells/pages/pages.dart';
import 'package:autocells/providers/providers.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appProvider = context.watch<AppProvider>();
    final versionApp = appProvider.versionApp;

    return Drawer(
      width: 240.0,
      elevation: 0.0,
      backgroundColor: Theme.of(context).primaryColor,
      shape: const LinearBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  height: 48.0,
                  width: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Theme.of(context).primaryColor,
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/ico_${isDark ? "dark" : "light"}.ico',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      nameApp,
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
                const Expanded(child: SizedBox()),
                IconButton(
                  icon: const Icon(Icons.settings),
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
                  // selectedColor: Theme.of(context).dividerColor,
                  selectedTileColor: Theme.of(context).focusColor,
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
