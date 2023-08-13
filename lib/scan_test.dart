// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class ScanTestScreen extends StatefulWidget {
  @override
  _ScanTestScreenState createState() => _ScanTestScreenState();
}

class _ScanTestScreenState extends State<ScanTestScreen> {
  File? _image;
  List? _recognitions;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  void _loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
    setState(() {
      _loading = false;
    });
  }

  void _getImage(ImageSource source) async {
    var image = await ImagePicker().pickImage(source: source);
    setState(() {
      _image = File(image!.path);

      _loading = true;
    });
    _predictImage();
  }

  void _predictImage() async {
    List<int> bytes = await _image!.readAsBytes();
    Uint8List uint8list = Uint8List.fromList(bytes);
    // var recognitions = await Tflite.runModelOnBinary(binary: uint8list);

    var recognitions = await Tflite.runModelOnImage(
      path: _image!.path,
      numResults: 5,
      threshold: 0.05,
    );
    setState(() {
      _recognitions = recognitions!;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Object Detection'),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _image == null
              ? Center(
                  child: Text('No image selected.'),
                )
              : ListView(
                  children: <Widget>[
                    Image.file(_image!),
                    if (_recognitions != null && _recognitions!.isNotEmpty)
                      ..._recognitions!.map(
                        (r) => ListTile(
                          title: Text(r['label']),
                          subtitle: Text('${r['confidence']}'),
                        ),
                      )
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Choose an image'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Camera'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _getImage(ImageSource.camera);
                  },
                ),
                ElevatedButton(
                  child: Text('Gallery'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _getImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }
}
