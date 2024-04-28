import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class Scan extends StatefulWidget {
  const Scan({Key? key}) : super(key: key);

  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  File? _image;
  List<ImageLabel> _imageLabels = [];

  final _picker = ImagePicker();

  Future<void> _getImageFromCamera() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 600,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageLabels.clear();
      });

      _runImageLabeler();
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 600,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageLabels.clear();
      });

      _runImageLabeler();
    }
  }

  Future<void> _runImageLabeler() async {
    if (_image == null) {
      return;
    }

    final inputImage = InputImage.fromFile(_image!);
    final imageLabeler = GoogleMlKit.vision.imageLabeler();
    final imageLabels = await imageLabeler.processImage(inputImage);

    bool foundFood = false;
    for (final label in imageLabels) {
      if (label.label == 'Food' && label.confidence > 0.5) {
        for (final name in label.label.characters) {
          print('Found food: $name, confidence: ${label.confidence}');
        }
        foundFood = true;
        break;
      }
    }

    if (!foundFood) {
      print('Food cannot be recognized, try again!');
    }

    setState(() {
      _imageLabels = imageLabels;
    });
  }

  String _getHighestConfidenceFood(List<ImageLabel> labels) {
    double highestConfidence = 0;
    String highestConfidenceFood = '';

    for (final label in labels) {
      if (label.confidence > highestConfidence) {
        highestConfidence = label.confidence;
        highestConfidenceFood = label.label;
      }
    }

    if (highestConfidenceFood.isNotEmpty) {
      return '$highestConfidenceFood with ${highestConfidence.toStringAsFixed(2)}% confidence';
    } else {
      return 'Food cannot be recognized, try again!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Upload Your Ingredients',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _getImageFromCamera,
                  icon: Icon(Icons.camera_alt),
                  label: Text('Camera'),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _getImageFromGallery,
                  icon: Icon(Icons.image),
                  label: Text('Gallery'),
                ),
                SizedBox(height: 16),
                // Add more buttons as needed
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                if (_image != null)
                  SizedBox(
                    height: 400,
                    child: Image.file(_image!),
                  ),
                if (_imageLabels.isNotEmpty)
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Found food: ${_getHighestConfidenceFood(_imageLabels)}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
