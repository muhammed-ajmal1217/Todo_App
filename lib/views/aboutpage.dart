import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist1/controller/about_page_controller.dart';
import 'package:todolist1/theme/theme_manager_provider.dart';


class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
        appBar: AppBar(
        elevation: 0,
        title: const Text(
          'About',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: themeManager.primaryColorGradient,
          ),)),
        body: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                makeSpace(40),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'App Name:',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text('Todo App'),
                  ],
                ),
                makeSpace(40),
                hedings('Description:'),
                makeSpace(10),
                const Text(
                    "Todo App is a powerful and user-friendly to-do list app designed to help you stay organized and boost productivity. Whether you're managing personal tasks, work projects, or a combination of both, our app is here to simplify your life."),
                makeSpace(10),
                hedings('Features:'),
                makeSpace(10),
                featuresAdd(text1: 'Create and Manage Tasks:',text2: 'Quickly add, edit, and organize your to-do items with ease.'),
                featuresAdd(text1: 'Task Completion:',text2: 'Mark tasks as completed to track your progress.'),
                featuresAdd(text1: 'Task Notes:',text2: 'Add notes to tasks for additional details.'),
                featuresAdd(text1: 'Dark Mode:',text2:'Reduce eye strain and conserve battery life with our dark mode.' ),
                featuresAdd(text1: 'Privacy and Security:',text2: 'Rest assured that your data is secure and private.'),
                makeSpace(10),
                const Text(
                      'Contact:',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    makeSpace(10),
                    const Text('Have questions, feedback, or need assistance? Contact our support team at stranger99980@gmail.com'),
                  makeSpace(15),
                  const Text(
                      'Privacy Policy',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    makeSpace(10),
                    const Text('Read our privacy policy page to learn how we protect your data and respect your privacy.'),
                    makeSpace(15),
                  const Text(
                      'Rate and Review:',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    makeSpace(10),
                    const Text('Enjoying Todo App? Help us grow by rating and reviewing the app on the App Store or Google Play.'),
                    makeSpace(25),
                    const Text("Thank you for choosing Todo App to simplify your task management and organization. We're committed to making your life easier, one task at a time."),
                    makeSpace(25),
                
              ],
            ),
          ),
        ));
  }
}
