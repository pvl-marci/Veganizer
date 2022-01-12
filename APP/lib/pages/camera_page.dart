// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

StreamController<String> streamController1 = StreamController<String>();
StreamController<int> streamController2 = StreamController<int>();

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);
  static String recipe = "";

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? selectedImage;
  var resJson;
  String message = "";
  String browserUrl = "https://google.com";

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      selectedImage = File(pickedFile!.path);
    });
    Navigator.pop(context);
    onUploadImage();
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      selectedImage = File(pickedFile!.path);
    });

    Navigator.pop(context);
    onUploadImage();
  }

  Future<void> _showChoiceDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: Text("Camera"),
                    leading: Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  onUploadImage() async {
    streamController2.add(1);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://a146-92-73-252-184.ngrok.io/upload"),
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'image',
        selectedImage!.readAsBytes().asStream(),
        selectedImage!.lengthSync(),
        filename: selectedImage!.path.split('/').last,
      ),
    );
    request.headers.addAll(headers);
    print("request: " + request.toString());
    var res = await request.send();
    http.Response response = await http.Response.fromStream(res);

    setState(() {
      resJson = jsonDecode(response.body);
      browserUrl = resJson["browserUrl"];
      streamController1.add(browserUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: selectedImage == null
                ? Text(
                    'Please Pick an image to upload',
                    style: TextStyle(color: Colors.grey[400]),
                  )
                : Image.file(
                    selectedImage!,
                    height: 300,
                    width: 250,
                  ),
          ),
          Center(
              child: Material(
            child: InkWell(
              onTap: () {
                _showChoiceDialog();
              },
              child: Image.asset(
                'assets/images/cameraicon.png',
                width: 110,
                height: 110,
              ),
            ),
          ))
        ],
      ),
    );
  }
}
