import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/bottom_bar.dart';
import 'package:todolist/theme/theme_manager.dart';

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
    Future.delayed(Duration(seconds: 2), () {
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
      //backgroundColor: themeManager.primaryColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 350),
            child: Center(
              child:Column(
              children: [
                Image.asset('asset/42430-removebg-preview.png',height: 110,),
                if (isLoading)
                  CircularProgressIndicator(color: Colors.greenAccent),
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
    await Future.delayed(Duration(seconds: 1));
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => BottomNavigation(username: widget.username),
    ));
  }
}
