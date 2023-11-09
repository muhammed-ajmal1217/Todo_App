import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist1/theme/theme_manager_provider.dart';
import 'package:todolist1/widget_pages/bottom_bar.dart';
import 'package:todolist1/widget_pages/custom_container.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameController = TextEditingController();
  // ignore: constant_identifier_names
  static const String SAVE_KEY_NAME = "User_name";
  final _formKey = GlobalKey<FormState>();

  void checkLoggedInUser() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final storedUsername = sharedPreferences.getString(SAVE_KEY_NAME);

    if (storedUsername != null && storedUsername.isNotEmpty) {
      // ignore: use_build_context_synchronously
      navigateToBottomNavigation(context);
    }
  }

  @override
  void initState() {
    checkLoggedInUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ClipPath(
            clipper: MyCustomClipper2(),
            child: Container(
              height: 460,
              width: double.infinity,
              color: themeManager.mainContainerBack,
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                ClipPath(
                  clipper: MyCustomClipper(),
                  child: Container(
                    width: double.infinity,
                    height: 450,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.40),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      gradient: themeManager.primaryColorGradient,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            "Let's Start",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w300,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 247, 229, 67),
                                    Color.fromARGB(255, 85, 211, 200),
                                    Color.fromARGB(255, 205, 243, 169)
                                  ],
                                ).createShader(
                                    const Rect.fromLTWH(0, 0, 200, 70)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "From Today",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w300,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 247, 229, 67),
                                    Color.fromARGB(255, 85, 211, 200),
                                    Color.fromARGB(255, 205, 243, 169)
                                  ],
                                ).createShader(
                                    const Rect.fromLTWH(0, 0, 200, 70)),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none),
                                fillColor:
                                    const Color.fromARGB(255, 207, 206, 206),
                                filled: true,
                                hintText: 'Username',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                loginConform(context);
                              }
                            },
                            child: Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.40),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 1, 82, 64),
                                      Color.fromARGB(255, 9, 136, 130),
                                      Color.fromARGB(255, 34, 177, 170)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30)),
                              child: const Center(
                                  child: Text(
                                'Lets Start',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              right: 8,
              top: 390,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2),
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  'asset/vecteezy_clock-icon-clipart-design-illustration_9342688_130.png',
                  height: 140,
                  width: 140,
                ),
              )),
          Positioned(
            top: 415,
            left: 15,
            child: appTexts(
                text1: 'Task Management:',
                text2:
                    'A to-do list app allows you to list and\ncategorize tasks based on different\nprojects,deadlines, or contexts. This \nmakes it easierto keep track of various\nresponsibilities and activities.'),
          ),
          Positioned(
            top: 520,
            left: 15,
            child: appTexts(
                text1: 'Goal Setting:',
                text2:
                    'To-do list apps can be used for setting both \nshort-term and long-termgoals. Breaking down larger\n goals into smaller tasks makes\nthem more achievable and manageable.'),
          ),
          Positioned(
            top: 610,
            left: 15,
            child: appTexts(
                text1: 'Productivity Boost:',
                text2:
                    'Crossing off completed tasks from your to-do list provides a\nsense of accomplishment and motivates you to tackle more\ntasks. This sense of achievement can boost your overall\nproductivity.'),
          ),
          Positioned(
            top: 706,
            left: 15,
            child: appTexts(
                text1: 'Flexibility:',
                text2:
                    'Digital to-do lists can be easily updated, modified\nand reorganized. This adaptability is especially useful\nwhen priorities change or new tasks emerge.'),
          ),
        ],
      ),
    );
  }

  Align appTexts({String? text1, String? text2}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text1!,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 77, 76, 76),
            ),
          ),
          Text(
            text2!,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void loginConform(BuildContext ctx) async {
    final name = _nameController.text;
    if (name.isNotEmpty) {
      showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.greenAccent,
            ),
          );
        },
      );
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString(SAVE_KEY_NAME, name);
      final usernameBox = await Hive.openBox('username_box');
      await usernameBox.put('username', name);
      await Future.delayed(const Duration(seconds: 2));
      // ignore: use_build_context_synchronously
      // Navigator.of(ctx).pop();

      // ignore: use_build_context_synchronously
      navigateToBottomNavigation(ctx);
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        margin: EdgeInsets.all(10),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        content: Text("Username is empty"),
      ));
    }
  }

  void navigateToBottomNavigation(BuildContext ctx) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
          builder: (context) =>
              BottomNavigation(username: _nameController.text)),
    );
  }
}
