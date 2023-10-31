import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todolist1/screens/chart.dart';
import '../controller.dart/theme/theme_manager.dart';
import 'completed_page.dart';
import 'home_page.dart';
import 'in_complete.dart';

class BottomNavigation extends StatefulWidget {
  final String username;

  const BottomNavigation({super.key, required this.username});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectIndex = 0;

  List<Widget> widgetOptions = [];
  late Widget currentScreen;

  @override
  void initState() {
    super.initState();
    widgetOptions = [
      HomePage(username: widget.username),
      const Completed(),
      const UnComplete(),
      const Chart(),
    ];
    currentScreen = widgetOptions[selectIndex];
  }

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true; 
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent, 
          elevation: 0, 
          child: Container(
            decoration: BoxDecoration(
              gradient: themeManager.primaryColorGradient, 
            ),
            child: SizedBox(
              height: 74,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = HomePage(username: widget.username);
                        selectIndex = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_outlined,
                          size: 30,
                          color: selectIndex == 0 ? Colors.orange : Colors.white,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: selectIndex == 0 ? Colors.orange : Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = const Completed();
                        selectIndex = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt_outlined,
                          size: 30,
                          color: selectIndex == 1 ? Colors.orange : Colors.white,
                        ),
                        Text(
                          'Complete',
                          style: TextStyle(
                            color: selectIndex == 1 ? Colors.orange : Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = const UnComplete();
                        selectIndex = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.rule,
                          size: 30,
                          color: selectIndex == 2 ? Colors.orange : Colors.white,
                        ),
                        Text(
                          'Incomplete',
                          style: TextStyle(
                            color: selectIndex == 2 ? Colors.orange : Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = const Chart();
                        selectIndex = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.leaderboard_outlined,
                          size: 30,
                          color: selectIndex == 3 ? Colors.orange : Colors.white,
                        ),
                        Text(
                          'Chart',
                          style: TextStyle(
                            color: selectIndex == 3 ? Colors.orange : Colors.white,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
