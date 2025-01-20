import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmotionDetectionPage extends StatefulWidget {
  @override
  _EmotionDetectionPageState createState() => _EmotionDetectionPageState();
}

class _EmotionDetectionPageState extends State<EmotionDetectionPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  String _emotion = "Scanning...";
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras!.first,
      ResolutionPreset.medium,
    );
    await _cameraController!.initialize();
    setState(() {});
    _startEmotionDetection();
  }

  Future<void> _startEmotionDetection() async {
    while (mounted && _cameraController!.value.isInitialized) {
      if (!_isProcessing) {
        _isProcessing = true;
        try {
          final XFile image = await _cameraController!.takePicture();
          final Uint8List bytes = await image.readAsBytes();
          await _sendToBackend(bytes);
        } catch (e) {
          print("Error capturing frame: $e");
        }
        _isProcessing = false;
        await Future.delayed(Duration(milliseconds: 500)); // Limit frame rate
      }
    }
  }

  Future<void> _sendToBackend(Uint8List imageBytes) async {
    try {
      final response = await http.post(
        Uri.parse('http://<YOUR_BACKEND_IP>:5000/analyze'),
        headers: {'Content-Type': 'application/octet-stream'},
        body: imageBytes,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        setState(() {
          _emotion = result['emotion'] ?? "Unknown";
        });
      } else {
        setState(() {
          _emotion = "Error in detection";
        });
      }
    } catch (e) {
      print("Error sending data to backend: $e");
      setState(() {
        _emotion = "Connection error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: Text("Emotion Detection")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Real-Time Emotion Detection")),
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.black54,
              child: Text(
                "Emotion: $_emotion",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
