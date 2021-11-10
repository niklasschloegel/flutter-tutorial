import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum ImagePickAction { camera, gallery, cancel }

class UserImagePicker extends StatefulWidget {
  final void Function(File file) onImagePicked;
  const UserImagePicker({Key? key, required this.onImagePicked})
      : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  Future<void> _pickImage() async {
    final action = await showDialog<ImagePickAction>(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Add image"),
              content: Text("Take a new picture or choose an existing one."),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.of(ctx).pop(ImagePickAction.cancel),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton.icon(
                  onPressed: () =>
                      Navigator.of(ctx).pop(ImagePickAction.camera),
                  label: Text("Camera"),
                  icon: Icon(Icons.photo_camera),
                ),
                TextButton.icon(
                  onPressed: () =>
                      Navigator.of(ctx).pop(ImagePickAction.gallery),
                  label: Text("Gallery"),
                  icon: Icon(Icons.collections),
                ),
              ],
            ));

    ImageSource imageSource;
    switch (action) {
      case ImagePickAction.camera:
        imageSource = ImageSource.camera;
        break;
      case ImagePickAction.gallery:
        imageSource = ImageSource.gallery;
        break;
      default:
        return;
    }

    final imagePicker = ImagePicker();
    final file = await imagePicker.getImage(
      source: imageSource,
      imageQuality: 50,
      maxWidth: 150,
      preferredCameraDevice: CameraDevice.front,
    );
    if (file == null) {
      print("file null");
      return;
    }
    final imgFile = File(file.path);
    setState(() => _pickedImage = imgFile);
    widget.onImagePicked(imgFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey.shade900,
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage!) as ImageProvider
              : AssetImage("assets/images/defaultProfilePic.png")
                  as ImageProvider,
        ),
        TextButton.icon(
          icon: Icon(Icons.image),
          label: Text("Add image"),
          onPressed: _pickImage,
        ),
      ],
    );
  }
}
