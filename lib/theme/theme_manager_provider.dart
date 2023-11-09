import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum ThemeType { light, dark }

class ThemeManager extends ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();
  ThemeType _currentThemeType = ThemeType.light;

  ThemeData get currentTheme => _currentTheme;
  ThemeType get currentThemeType => _currentThemeType;

  static const String themeBoxName = 'theme_box';
  static const String selectedThemeKey = 'selected_theme';
  

LinearGradient get primaryColorGradient => _currentThemeType == ThemeType.dark
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
           Colors.black,
           Colors.black,
          ],         
        )
      : const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          
          colors: [
            Color.fromARGB(255, 117, 36, 36),
            Color.fromARGB(255, 143, 52, 52),
            Color.fromARGB(255, 167, 71, 71),
            Color.fromARGB(255, 185, 98, 98),
            Color.fromARGB(255, 201, 113, 113),
          ],
        );
// ignore: non_constant_identifier_names
LinearGradient get IconColorHome => _currentThemeType == ThemeType.dark
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
           Color.fromARGB(255, 46, 45, 45),
           Color.fromARGB(255, 15, 15, 15),
          ],         
        )
      : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          
          colors: [
            Color.fromARGB(255, 143, 52, 52),
            Color.fromARGB(255, 167, 71, 71),
            Color.fromARGB(255, 201, 113, 113),
            Color.fromARGB(255, 143, 52, 52),
            Color.fromARGB(255, 90, 25, 25),
          ],
        );
  Color get floatingButtonColor => _currentThemeType == ThemeType.dark
      ? Colors.blueGrey
      : const Color.fromARGB(255, 255, 102, 0);
  Color get primaryColorGradientApp => _currentThemeType == ThemeType.dark
      ? Colors.black
      : const Color.fromARGB(255, 201, 113, 113);
  Color get mainContainerBack => _currentThemeType == ThemeType.dark
      ? const Color.fromARGB(255, 32, 33, 34)
      : Color.fromARGB(255, 252, 232, 190);
  Color get deleteIcons => _currentThemeType == ThemeType.dark
      ? const Color.fromARGB(255, 151, 143, 144)
      : const Color.fromARGB(255, 99, 90, 92);
  Color get completedTaskColors => _currentThemeType == ThemeType.dark
      ? const Color.fromARGB(255, 61, 61, 61)
      : Colors.green[100]!;
  Color get incompletedTaskColors => _currentThemeType == ThemeType.dark
      ? const Color.fromARGB(255, 61, 61, 61)
      : Colors.red[100]!;
  Color get splashColor => _currentThemeType == ThemeType.dark
      ? const Color.fromARGB(255, 0, 0, 0)
      : const Color.fromARGB(255, 172, 91, 95);
  Color get splashIconColor => _currentThemeType == ThemeType.dark
      ? const Color.fromARGB(255, 66, 66, 66)
      : const Color.fromARGB(255, 196, 110, 114);
  Color get incompletedChart => _currentThemeType == ThemeType.dark
      ? const Color.fromARGB(255, 36, 10, 129)
      : const Color.fromARGB(255, 255, 148, 116);
  Color get completedChart => _currentThemeType == ThemeType.dark
      ? const Color.fromARGB(255, 10, 75, 129)
      : const Color.fromARGB(255, 129, 245, 206);
  Color get pictureBackground => _currentThemeType == ThemeType.dark
      ? const Color.fromARGB(255, 59, 64, 68)
      : const Color.fromARGB(255, 156, 89, 89);

void toggleTheme() async {
  if (_currentThemeType == ThemeType.light) {
    _currentTheme = ThemeData.dark();
    _currentThemeType = ThemeType.dark;
  } else {
    _currentTheme = ThemeData.light();
    _currentThemeType = ThemeType.light;
  }
  final themeBox = await Hive.openBox(themeBoxName);
  themeBox.put(selectedThemeKey, _currentThemeType.toString());

  notifyListeners();
}
Future<void> initializeTheme() async {
  final themeBox = await Hive.openBox(themeBoxName);
  final selectedTheme = themeBox.get(selectedThemeKey);

  if (selectedTheme == null) {
    _currentThemeType = ThemeType.light;
  } else {
    _currentThemeType = ThemeType.values
        .firstWhere((type) => type.toString() == selectedTheme);
  }
  if (_currentThemeType == ThemeType.light) {
    _currentTheme = ThemeData.light();
  } else {
    _currentTheme = ThemeData.dark();
  }

  notifyListeners();
}

}
