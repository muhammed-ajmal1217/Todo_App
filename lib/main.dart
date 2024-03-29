import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todolist/functions/db_functions.dart';
import 'package:todolist/login_page.dart';
import 'package:todolist/model/data_model.dart';
import 'package:todolist/splash.dart';
import 'package:todolist/theme/theme_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(TaskModelAdapter().typeId)) {
    Hive.registerAdapter(TaskModelAdapter());
  }
  await Hive.openBox('profile_picture_box');
  await Hive.openBox('username_box');
  final taskDb = await Hive.openBox<TaskModel>('task_db');
  taskListNotifier.value = taskDb.values.toList();
  final themeManager = ThemeManager();
  await themeManager.initializeTheme();

  runApp(
    ChangeNotifierProvider.value(
      value: themeManager,
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<String?>(
        future: _getUsername(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(); 
          } else if (snapshot.hasData && snapshot.data != null) {
            return SplashScreen(username: snapshot.data!);
          } else {
            return const LoginPage();
          }
        },
      ),
      theme: themeManager.currentTheme,
      darkTheme: ThemeData.dark(),
      themeMode: themeManager.currentThemeType == ThemeType.dark
          ? ThemeMode.dark
          : ThemeMode.light,
    );
  }

  static Future<String?> _getUsername() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('User_name');
  }
}
