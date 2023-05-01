// ignore_for_file: must_be_immutable, invalid_use_of_visible_for_testing_member

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

File frontUpdateKycFilePath;
File backUpdateKycFilePath;
File panUpdateKycFilePath;
String image = "";

class AttachmentAddDialogBox extends StatefulWidget {
  String clickby = '';
  AttachmentAddDialogBox(this.clickby);
  @override
  State<StatefulWidget> createState() {
    return _AttachmentAddDialogBox();
  }
}

class _AttachmentAddDialogBox extends State<AttachmentAddDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        height: 225,
        child: Dialog(
          backgroundColor: Color(0xff17394f),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "New Attachment",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close),
                    )
                  ],
                ),

                Divider(),
//                CheckboxListTile(title: Text('Public'),value: _isChecked,onChanged: (val){setState((){});},),
                Container(
                  child: Column(
                    children: <Widget>[
                      Center(child: Text("Choose Option")),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            // final pickimage=await ImagePicker.platform.getImage(source:ImageSource.camera);
                            // final file=pickimage.path;

                            final pickimage = await ImagePicker.platform
                                .pickImage(source: ImageSource.camera);
                            final file = pickimage.path;

                            File cropper = await ImageCropper().cropImage(
                                sourcePath: file,
                                maxWidth: 100,
                                maxHeight: 100,
                                compressQuality: 80,
                                aspectRatioPresets: [
                                  CropAspectRatioPreset.square,
                                  CropAspectRatioPreset.ratio3x2,
                                  CropAspectRatioPreset.ratio16x9
                                ]);
                            setState(() {
                              if (widget.clickby == "Front") {
                                frontUpdateKycFilePath = cropper;
                              }
                              if (widget.clickby == "Back") {
                                backUpdateKycFilePath = cropper;
                              }
                              if (widget.clickby == "Pan") {
                                panUpdateKycFilePath = cropper;
                              }
                            });

                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.camera,
                            size: 50,
                            color: Colors.blue,
                          ),
                        ),
                        Text('Camera')
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            PickedFile gallery = await ImagePicker.platform
                                .pickImage(source: ImageSource.gallery);
                            print(gallery.path.toString());
                            File cropper = (await ImageCropper().cropImage(
                                sourcePath: gallery.path,
                                maxWidth: 100,
                                maxHeight: 100,
                                compressQuality: 80,
                                aspectRatioPresets: [
                                  CropAspectRatioPreset.square,
                                  CropAspectRatioPreset.ratio3x2,
                                  CropAspectRatioPreset.ratio16x9
                                ]));
                            if (cropper != null) {
                              setState(() {
                                if (widget.clickby == "Front") {
                                  frontUpdateKycFilePath = cropper;
                                }
                                if (widget.clickby == "Back") {
                                  backUpdateKycFilePath = cropper;
                                }
                                if (widget.clickby == "Pan") {
                                  panUpdateKycFilePath = cropper;
                                }
                              });
                              Navigator.of(context).pop();
                            } else {
                              print("error");
                              Navigator.of(context).pop();
                            }
                          },
                          child: Icon(Icons.dashboard,
                              size: 50, color: Colors.green),
                        ),
                        Text('Gallery')
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
