import 'dart:io';
import 'package:app_flutter/providers/app_provider.dart';
import 'package:app_flutter/providers/insert_image_provider.dart';
import 'package:app_flutter/screens/home_screen.dart';
import 'package:app_flutter/config/theme.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter/material.dart';
import 'package:desktop_window/desktop_window.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    setWindowTitle('AutoExcel');
    setWindowMinSize(const Size(800, 500));
    DesktopWindow.setWindowSize(const Size(800, 500));

    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InsertImageProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const MainApp(),
    ));
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return MaterialApp(
      theme: Themes.ligthTheme,
      darkTheme: Themes.darkTheme,
      themeMode: appProvider.themeMode,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
