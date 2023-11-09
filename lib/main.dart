import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist1/db_functions/db_functions.dart';
import 'package:todolist1/provider/resetapp_provider.dart';
import 'package:todolist1/provider/splash_provider.dart';
import 'package:todolist1/provider/username_provider.dart.dart';
import 'package:todolist1/views/login.dart';
import 'package:todolist1/views/splash.dart';
import 'package:todolist1/theme/theme_manager_provider.dart';
import 'package:todolist1/model/data_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(TaskModelAdapter().typeId)) {
    Hive.registerAdapter(TaskModelAdapter());
  }
  await Hive.openBox('profile_picture_box');
  await Hive.openBox('username_box');
  await Hive.openBox<TaskModel>('task_db');
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
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => UsernameProvider()),
      ChangeNotifierProvider(create: (context) => dbProvider()),
      ChangeNotifierProvider(create: (context) => SplashProvider()),
      ChangeNotifierProvider(create: (context) => ResetProvider()),
      ChangeNotifierProvider(create: (context) => SearchProvider()),
      ChangeNotifierProvider(create: (context) => BottomNavigationProvider(username: '')),
      
    ],
      child: MaterialApp(
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
      ),
    );
  }

  static Future<String?> _getUsername() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('User_name');
  }
}
