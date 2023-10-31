// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todolist1/controller.dart/functions/db_functions.dart';
class ImageFunction {
  static Future<void> showAddPhotoDialog(BuildContext context) async {
    final ImagePicker imagePicker = ImagePicker();
    File? file;
  //     final cameraPermission = await Permission.camera.request();
  // if (cameraPermission.isDenied) {
  //   return null;
  // }
  // final galleryPermission = await Permission.photos.request();
  // if (galleryPermission.isDenied) {
  //   return null;
  // }

   await showDialog(
      context: context,
      builder: (BuildContext context) {
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
                            storeImageInHive(file!);
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
                            storeImageInHive(file!);
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
                    deleteStoredImage();
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
