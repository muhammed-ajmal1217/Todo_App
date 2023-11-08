import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todolist1/controller.dart/provider.dart';
import 'package:todolist1/views/aboutpage.dart';
import 'package:todolist1/views/terms_&_conditions.dart';
import 'package:todolist1/controller.dart/theme/theme_manager.dart';

// ignore: camel_case_types
class draWer extends StatelessWidget {
  const draWer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {   
    final themeManager = Provider.of<ThemeManager>(context);
    return Drawer(
      elevation: 5,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: themeManager.primaryColorGradient,
            ),
            child: const Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(
                  Icons.lock,
                  size: 20,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Privacy Policy',
                  style: TextStyle(
                      color: Color.fromARGB(255, 80, 79, 79),
                      fontSize: 17),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => const PrivacyPage()));
            },
          ),
          const Divider(),
          ListTile(
            title: const Row(
              children: [
                Icon(
                  Icons.dark_mode_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Theme',
                  style: TextStyle(
                    color: Color.fromARGB(255, 80, 79, 79),
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            trailing: Switch(
              value: themeManager.currentThemeType == ThemeType.dark,
              onChanged: (newValue) {
                themeManager.toggleTheme();
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 20,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'About',
                  style: TextStyle(
                      color: Color.fromARGB(255, 80, 79, 79),
                      fontSize: 17),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => const AboutPage()));
            },
          ),
          const Divider(),
          ListTile(
            title: const Row(
              children: [
                Icon(
                  Icons.restart_alt_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Reset',
                  style: TextStyle(
                    color: Color.fromARGB(255, 80, 79, 79),
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reset app'),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'if you tap Reset it will delete all the datas including image name are you sure you want to reset the app..?',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        )
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                           Provider.of<ResetProvider>(context,listen:false).resetApp(context);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.greenAccent,
                                  ),
                                );
                              },
                            );
                          },
                          child: const Text('Reset')),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('cancel'))
                    ],
                  );
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Row(
              children: [
                Icon(
                  Icons.exit_to_app,
                  size: 20,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Exit',
                  style: TextStyle(
                      color: Color.fromARGB(255, 80, 79, 79),
                      fontSize: 17),
                ),
              ],
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Exit App..?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                            child: const Text('Exit')),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('cancel')),
                      ],
                    );
                  });
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
