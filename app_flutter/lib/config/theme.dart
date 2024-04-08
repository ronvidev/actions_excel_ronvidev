import 'package:flutter/material.dart';

class Themes {
  static const useMaterial3 = true;
  static const primaryColorScheme = Colors.green;

  static const lightPrimaryColor = Color.fromARGB(255, 240, 255, 240);
  static const lightBackroundColor = Color.fromARGB(255, 231, 248, 229);
  static const lightCanvasColor = Color.fromARGB(255, 247, 255, 246);

  static const darkPrimaryColor = Color.fromARGB(255, 48, 48, 48);
  static const darkBackroundColor = Color.fromARGB(255, 22, 22, 22);
  static const darkCanvasColor = Color.fromARGB(255, 42, 42, 42);

  static final pageTransitionsTheme = PageTransitionsTheme(builders: {
    TargetPlatform.windows: CustomPageTransitionsBuilder(),
  });

  static ThemeData ligthTheme = ThemeData(
    useMaterial3: useMaterial3,
    colorScheme: const ColorScheme.light(
      primary: primaryColorScheme,
      background: lightBackroundColor,
    ),
    primaryColor: lightPrimaryColor,
    canvasColor: lightCanvasColor,
    cardColor: const Color.fromARGB(255, 248, 255, 247),
    hintColor: Colors.black38,
    pageTransitionsTheme: pageTransitionsTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightPrimaryColor,
    ),
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: useMaterial3,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        primary: primaryColorScheme, background: darkBackroundColor),
    primaryColor: darkPrimaryColor,
    dialogBackgroundColor: darkBackroundColor,
    canvasColor: darkCanvasColor,
    cardColor: const Color.fromARGB(255, 32, 32, 32),
    hintColor: const Color.fromARGB(255, 191, 222, 191),
    pageTransitionsTheme: pageTransitionsTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkPrimaryColor,
    ),
  );
}

class CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutQuad,
    );

    return Stack(
      children: [
        FadeTransition(
          opacity: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(curvedAnimation),
          child: Container(color: Theme.of(context).primaryColor),
        ),
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.1),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(curvedAnimation),
            child: child,
          ),
        ),
      ],
    );
  }
}
