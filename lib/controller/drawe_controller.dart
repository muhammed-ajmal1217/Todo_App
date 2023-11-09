import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

dialogueExit(BuildContext context) {
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
}

dialogueLoder(BuildContext context) {
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
}
