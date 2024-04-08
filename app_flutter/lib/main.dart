import 'dart:io';
import 'package:autocells/config/constants.dart';
import 'package:autocells/config/shared.dart';
import 'package:autocells/providers/app_provider.dart';
import 'package:autocells/providers/insert_image_provider.dart';
import 'package:autocells/screens/home_screen.dart';
import 'package:autocells/config/theme.dart';
import 'package:autocells/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter/material.dart';
// import 'package:desktop_window/desktop_window.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    setWindowTitle('AutoCells');
    setWindowMinSize(const Size(800, 500));
    
    // DesktopWindow.setWindowSize(const Size(800, 500));

    final isDarkTheme = await Shared.getLastTheme();

    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InsertImageProvider()),
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
