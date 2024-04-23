import 'dart:io';
import 'package:autocells/config/constants.dart';
import 'package:autocells/config/shared.dart';
import 'package:autocells/providers/app_provider.dart';
import 'package:autocells/providers/excel_template_provider.dart';
import 'package:autocells/screens/home_screen.dart';
import 'package:autocells/config/theme.dart';
import 'package:autocells/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  if (Platform.isWindows) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    
    await windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      await windowManager.setTitle('AutoCells');
      await windowManager.setMinimumSize(const Size(800, 500));
      await windowManager.show();
    });

    final isDarkTheme = await Shared.getLastTheme();

    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExcelTemplateProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MainApp(isDarkTheme: isDarkTheme),
    ));
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, this.isDarkTheme});

  final bool? isDarkTheme;

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return MaterialApp(
      theme: Themes.ligthTheme,
      darkTheme: Themes.darkTheme,
      themeMode: appProvider.themeMode ??
          (isDarkTheme == null
              ? ThemeMode.system
              : isDarkTheme!
                  ? ThemeMode.dark
                  : ThemeMode.light),
      debugShowCheckedModeBanner: false,
      initialRoute: kHomeScreen,
      themeAnimationCurve: Curves.easeOutQuad,
      routes: {
        kHomeScreen: (_) => const HomeScreen(),
        kSettingsScreen: (_) => const SettingsScreen(),
      },
    );
  }
}
