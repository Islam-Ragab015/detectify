import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ObjectDetectionScreen(),
    );
  }
}

class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({super.key});

  @override
  _ObjectDetectionScreenState createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  File? file;
  var _recognitions;
  var resultText = "";

  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        file = File(image!.path);
      });
      detectimage(file!);
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future detectimage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
      resultText = _recognitions.isNotEmpty
          ? _recognitions
              .map((rec) =>
                  "${rec['label']}: ${(rec['confidence'] * 100).toStringAsFixed(0)}%")
              .join("\n")
          : "No objects detected!";
    });
    print(_recognitions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          'Object Detection via TFLITE',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.deepPurple.shade400,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Image Display
                if (_image != null)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade400,
                          Colors.deepPurple.shade800,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        File(_image!.path),
                        height: 250,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  const Text(
                    'Pick an image to identify',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                const SizedBox(height: 30),

                // Pick Image Button
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(
                    Icons.image,
                    size: 24,
                  ),
                  label: const Text(
                    'Pick Image from Gallery',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Button background color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15), // Increased padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                    elevation: 5,
                  ),
                ),
                const SizedBox(height: 30),

                // Result Display Card
                if (_recognitions != null)
                  Card(
                    elevation: 8,
                    shadowColor: Colors.deepPurple.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title for the result
                          Text(
                            'Object Detection Results',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple.shade700,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Display the results
                          if (_recognitions.isNotEmpty)
                            ..._recognitions.map<Widget>((rec) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    // Label name
                                    Expanded(
                                      child: Text(
                                        "${rec['label']}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.deepPurple.shade600,
                                        ),
                                      ),
                                    ),
                                    // Confidence percentage
                                    Text(
                                      "${(rec['confidence'] * 100).toStringAsFixed(0)}%",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.orange.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList()
                          else
                            Text(
                              'No objects detected!',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
