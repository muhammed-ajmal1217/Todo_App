import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist1/controller.dart/provider.dart';
import 'package:todolist1/views/bottom_bar.dart';
import 'package:todolist1/controller.dart/theme/theme_manager.dart';

// ignore: must_be_immutable
class SplashScreen extends StatelessWidget {
  String username;
  SplashScreen({super.key, required this.username});

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    Future.delayed(const Duration(seconds: 2), () {
      splashProvider.setLoading(false);
      gotoHome(context);
    });
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      backgroundColor: themeManager.splashColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 350),
            child: Center(
              child:Column(
              children: [
                Icon(Icons.description_outlined,color: themeManager.splashIconColor ,size: 100,),
                if (isLoading)
                  const CircularProgressIndicator(color: Colors.greenAccent),
              ],
            ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> gotoHome(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 0));
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => BottomNavigation(username: username),
    ));
  }
}
