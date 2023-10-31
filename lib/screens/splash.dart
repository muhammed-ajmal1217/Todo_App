import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist1/screens/bottom_bar.dart';
import 'package:todolist1/controller.dart/theme/theme_manager.dart';

// ignore: must_be_immutable
class SplashScreen extends StatefulWidget {
  String username;
  SplashScreen({super.key, required this.username});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
      gotoHome(context);
    });
  }

  @override
  Widget build(BuildContext context) {
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

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> gotoHome(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => BottomNavigation(username: widget.username),
    ));
  }
}
