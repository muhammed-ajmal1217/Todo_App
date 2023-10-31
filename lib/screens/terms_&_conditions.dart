import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist1/controller.dart/theme/theme_manager.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: themeManager.primaryColorGradient,
          ),)),
      
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headings('Terms & Conditions'),
              spacing(10),
              content('Welcome to the TodoApp! By using this app you agree to these terms'),
              spacing(10),
              content('1: Use Responsibily - The TodoApp is designed to help you to store your daily task. Use responsibly and and manage you time. '),
              spacing(10),
              content('2: Your Content - Any tasks and image you add it is your responsibilty. Make sure they are accurate and safe to use'),
              spacing(10),
              content('3: Respect Privacy - We care about your privacy. your use of the app is subject to our privacy policy. '),
              spacing(10),
              content('4: App ownership - The TodoApp and its content belongs to us please dont modify,distribute,reverse engineer the app without our permission'),
              spacing(10),
              content('5: App changes - We might update the app ot these terms.stay tuned for any announcement from us'),
              spacing(10),
              content('6: App availability - We aim to provide the app 24/7, but we cant guarantee it . We are not responsible for any inconvenience caused by app unavailability.'),
              spacing(10),
              content('7: Get in touch - if you have questions, resch out to us at stranger99980@gmail.com.'),
              spacing(20),
              content('By using the TodoApp, you agree to these terms. Enjoy your day, Make it worthy. ')
            ],
          ),
        ),
      ),
    );
  }

  Row servicePoints(String text3) {
    return Row(
      children: [
        const Icon(
          Icons.circle,
          size: 8,
        ),
        const SizedBox(
          width: 6,
        ),
        Text(text3),
      ],
    );
  }

  Text content(String text2) {
    return Text(text2);
  }

  SizedBox spacing(double height) {
    return SizedBox(
      height: height,
    );
  }

  Text headings(String text1) {
    return Text(
      text1,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    );
  }
}
