import 'package:flutter/material.dart';
import 'package:todolist/bottom_bar.dart';

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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 172, 91, 95),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 350),
            child: Center(
              child:Column(
              children: [
                const Icon(Icons.description_outlined,color:Color.fromARGB(255, 185, 115, 119) ,size: 100,),
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
