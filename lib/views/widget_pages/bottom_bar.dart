import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todolist1/provider/username_provider.dart.dart';
import 'package:todolist1/views/chart.dart';
import '../../theme/theme_manager_provider.dart';
import '../completed_page.dart';
import '../home_page.dart';
import '../in_complete.dart';

class BottomNavigation extends StatelessWidget {
  final String username;
  BottomNavigation({super.key, required this.username});
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    final bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context, listen: false);
    final indexPro =
        Provider.of<BottomNavigationProvider>(context, listen: true);
    final themeManager = Provider.of<ThemeManager>(context);
    bottomNavigationProvider.widgetOptions = [
      HomePage(username: username),
      const Completed(),
      UnComplete(),
      const Chart(),
    ];
    bottomNavigationProvider.currentScreen;
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: PageStorage(
          bucket: bucket,
          child: Provider.of<BottomNavigationProvider>(context, listen: false)
              .currentScreen,
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
                      bottomNavigationProvider.navigateToPage(0);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_outlined,
                          size: 30,
                          color: indexPro.selectIndex == 0
                              ? Colors.orange
                              : Colors.white,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: indexPro.selectIndex == 0
                                ? Colors.orange
                                : Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      bottomNavigationProvider.navigateToPage(1);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt_outlined,
                          size: 30,
                          color: indexPro.selectIndex == 1
                              ? Colors.orange
                              : Colors.white,
                        ),
                        Text(
                          'Complete',
                          style: TextStyle(
                            color: indexPro.selectIndex == 1
                                ? Colors.orange
                                : Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      bottomNavigationProvider.navigateToPage(2);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.rule,
                          size: 30,
                          color: indexPro.selectIndex == 2
                              ? Colors.orange
                              : Colors.white,
                        ),
                        Text(
                          'Incomplete',
                          style: TextStyle(
                            color: indexPro.selectIndex == 2
                                ? Colors.orange
                                : Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      bottomNavigationProvider.navigateToPage(3);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.leaderboard_outlined,
                          size: 30,
                          color: indexPro.selectIndex == 3
                              ? Colors.orange
                              : Colors.white,
                        ),
                        Text(
                          'Chart',
                          style: TextStyle(
                            color: indexPro.selectIndex == 3
                                ? Colors.orange
                                : Colors.white,
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
