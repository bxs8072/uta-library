import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uta_library/models/user.dart';

class ProfilePicture extends StatefulWidget {
  final User user;
  const ProfilePicture({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  bool _isUploading = false;

  Future<void> chooseFile() async {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    // ignore: invalid_use_of_visible_for_testing_member
                    await ImagePicker.platform
                        .pickImage(source: ImageSource.camera)
                        .then((file) {
                      uploadFile(file!).then((url) {
                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(widget.user.uid)
                            .update({
                          "photo": url,
                        });
                      });
                    }).then((value) => Navigator.of(ctx).pop(true));
                  },
                  icon: const Icon(Icons.camera_alt),
                ),
                IconButton(
                  onPressed: () async {
                    // ignore: invalid_use_of_visible_for_testing_member
                    await ImagePicker.platform
                        .pickImage(source: ImageSource.gallery)
                        .then((file) {
                      uploadFile(file!).then((url) {
                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(widget.user.uid)
                            .update({
                          "photo": url,
                        });
                      });
                    }).then((value) => Navigator.of(ctx).pop(true));
                  },
                  icon: const Icon(Icons.photo),
                ),
              ],
            ),
          );
        });
  }

  Future<String> uploadFile(PickedFile file) async {
    String _url = "";
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('${widget.user.uid}/${path.basename(file.path)}}');

    setState(() {
      _isUploading = true;
    });

    try {
      UploadTask uploadTask = storageReference.putFile(File(file.path));
      await uploadTask;
      _url = await storageReference.getDownloadURL();
    } catch (e) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Upload Failed"),
              content: Text(
                e.toString(),
              ),
            );
          });
    } finally {
      setState(() {
        _isUploading = false;
      });
      Fluttertoast.showToast(
        msg: "Image has been uploaded successfully",
      );
    }
    return _url;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(
      children: [
        _isUploading
            ? Container(
                width: MediaQuery.of(context).size.height * 0.2,
                height: MediaQuery.of(context).size.height * 0.2,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const CircularProgressIndicator(),
              )
            : widget.user.photo == ""
                ? Container(
                    width: MediaQuery.of(context).size.height * 0.2,
                    height: MediaQuery.of(context).size.height * 0.2,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      widget.user.initial,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.height * 0.1,
                        letterSpacing: 1.5,
                      ),
                    ),
                  )
                : ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: Ink.image(
                        image: NetworkImage(widget.user.photo!),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.height * 0.2,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: const InkWell(),
                      ),
                    ),
                  ),
        Positioned(
          bottom: 0,
          right: 4,
          child: ClipOval(
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: chooseFile,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color:
                    ThemeProvider.controllerOf(context).currentThemeId == "dark"
                        ? Colors.white
                        : Colors.black,
                child: Icon(
                  Icons.add_a_photo,
                  color: ThemeProvider.controllerOf(context).currentThemeId ==
                          "dark"
                      ? Colors.black
                      : Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
