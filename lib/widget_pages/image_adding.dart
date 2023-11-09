// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:todolist1/db_functions/db_functions.dart';
class ImageFunction {
  static Future<void> showAddPhotoDialog(BuildContext context) async {
    final ImagePicker imagePicker = ImagePicker();
    File? file;
   await showDialog(
      context: context,
      builder: (BuildContext context) {
        final db = Provider.of<dbProvider>(context,listen: false);
        return AlertDialog(
          title: const Center(child: Text('Add Profile picture')),
          actions: <Widget>[
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        onPressed: () async {
                          final selectedImage = await imagePicker.pickImage(
                            source: ImageSource.camera,
                          );
                          if (selectedImage != null) {
                            file = File(selectedImage.path);
                            db.storeImageInHive(file!);
                            Navigator.of(context).pop(file);
                          }
                        },
                        backgroundColor: Colors.red,
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          final selectedImage = await imagePicker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (selectedImage != null) {
                            file = File(selectedImage.path);
                            db.storeImageInHive(file!);
                            Navigator.of(context).pop(file);
                          }
                        },
                        backgroundColor: const Color.fromARGB(255, 241, 218, 6),
                        child: const Icon(
                          Icons.folder_open_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    db.deleteStoredImage();
                    Navigator.of(context).pop(null);
                  },
                  child: const Text('Delete Image'),
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
