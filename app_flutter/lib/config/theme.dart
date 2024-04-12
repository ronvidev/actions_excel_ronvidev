import 'package:flutter/material.dart';

class Themes {
  static const useMaterial3 = true;
  static const primaryColorScheme = Colors.green;
  static final dividerColor = primaryColorScheme.withOpacity(0.3);

  static const lightPrimaryColor = Color.fromARGB(255, 243, 243, 243);
  static const lightBackroundColor = Color.fromARGB(255, 237, 237, 237);
  static const lightCanvasColor = Color.fromARGB(255, 255, 255, 255);
  static final lightHoverColor = primaryColorScheme.withOpacity(0.1);
  static const lightCardColor = Color.fromRGBO(249, 249, 249, 1);
  static const lightFocusColor = Color.fromRGBO(213, 237, 213, 1);

  static const darkPrimaryColor = Color.fromARGB(255, 48, 48, 48);
  static const darkBackroundColor = Color.fromARGB(255, 22, 22, 22);
  static const darkCanvasColor = Color.fromARGB(255, 42, 42, 42);
  static const darkCardColor = Color.fromARGB(255, 32, 32, 32);
  static final darkHoverColor = primaryColorScheme.withOpacity(0.1);

  static final pageTransitionsTheme = PageTransitionsTheme(builders: {
    TargetPlatform.windows: CustomPageTransitionsBuilder(),
  });

  static final borderSide = BorderSide(color: dividerColor, width: 0.2);

  static final iconButtonStyle = ButtonStyle(
    foregroundColor: const MaterialStatePropertyAll(primaryColorScheme),
    padding: const MaterialStatePropertyAll(EdgeInsets.zero),
    splashFactory: NoSplash.splashFactory,
    minimumSize: const MaterialStatePropertyAll(Size(56.0, 40.0)),
    visualDensity: VisualDensity.compact,
    shape: MaterialStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
        side: borderSide,
      ),
    ),
  );

  static final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: const MaterialStatePropertyAll(0.0),
      splashFactory: NoSplash.splashFactory,
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
          side: borderSide,
        ),
      ),
    ),
  );

  static final dividerTheme = DividerThemeData(
    color: dividerColor,
    thickness: 2.0,
    indent: 2.0,
  );

  static ThemeData ligthTheme = ThemeData(
    useMaterial3: useMaterial3,
    colorScheme: const ColorScheme.light(
      primary: primaryColorScheme,
      background: lightBackroundColor,
    ),
    primaryColor: lightPrimaryColor,
    canvasColor: lightCanvasColor,
    cardColor: lightCardColor,
    hintColor: Colors.black38,
    hoverColor: lightHoverColor,
    dividerTheme: dividerTheme,
    dividerColor: dividerColor,
    focusColor: lightFocusColor,
    highlightColor: primaryColorScheme.withOpacity(0.2),
    pageTransitionsTheme: pageTransitionsTheme,
    appBarTheme: const AppBarTheme(backgroundColor: lightPrimaryColor),
    elevatedButtonTheme: elevatedButtonTheme,
    iconButtonTheme: IconButtonThemeData(
      style: iconButtonStyle.copyWith(
        backgroundColor: const MaterialStatePropertyAll(lightCardColor),
        overlayColor: MaterialStatePropertyAll(lightHoverColor),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: useMaterial3,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColorScheme,
      background: darkBackroundColor,
    ),
    primaryColor: darkPrimaryColor,
    dialogBackgroundColor: darkBackroundColor,
    canvasColor: darkCanvasColor,
    cardColor: darkCardColor,
    hintColor: const Color.fromARGB(255, 191, 222, 191),
    focusColor: const Color.fromARGB(255, 57, 69, 55),
    highlightColor: primaryColorScheme.withOpacity(0.2),
    hoverColor: darkHoverColor,
    dividerTheme: dividerTheme,
    dividerColor: dividerColor,
    pageTransitionsTheme: pageTransitionsTheme,
    appBarTheme: const AppBarTheme(backgroundColor: darkPrimaryColor),
    elevatedButtonTheme: elevatedButtonTheme,
    iconButtonTheme: IconButtonThemeData(
      style: iconButtonStyle.copyWith(
        backgroundColor: const MaterialStatePropertyAll(darkCardColor),
        overlayColor: MaterialStatePropertyAll(darkHoverColor),
      ),
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
