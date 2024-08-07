import 'dart:async';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class LiveDetectionPage extends StatefulWidget {
  @override
  _LiveDetectionPageState createState() => _LiveDetectionPageState();
}

class _LiveDetectionPageState extends State<LiveDetectionPage> {
  CameraController? _cameraController;
  bool _isProcessing = false;
  bool _isLoading = false;
  bool _isFlashing = false;
  String _result = "";
  var _result2;

  final AudioPlayer _audioPlayer = AudioPlayer(); // Initialize AudioPlayer
  double _currentZoomLevel = 1.0;
  final double _maxZoomLevel = 5.0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
      );
      await _cameraController?.initialize();
      setState(() {});
    } catch (e) {
      _showPopup('Camera Initialization Error', e.toString());
    }
  }

  Future<void> _captureAndSendImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized || _isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _isFlashing = true;  // Trigger flash effect
    });

    // Flash effect duration
    await Future.delayed(Duration(milliseconds: 100));

    setState(() {
      _isFlashing = false;  // End flash effect
    });

    try {
      // Capture image
      final XFile image = await _cameraController!.takePicture();

      // Show success message
      _showPopup('Image Captured', 'The image was successfully captured!');

      // Get the file path of the image
      final String imagePath = image.path;

      // Send image file path to API
      await _sendImageToApi(imagePath);

      _isProcessing = false;
    } catch (e) {
      _showPopup('Capture Error', e.toString());
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _sendImageToApi(String imagePath) async {
    const apiUrl = 'https://wildanimal.abe27.site/detect';

    try {
      setState(() {
        _isLoading = true;
      });

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Attach the image file to the request
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      // Send the request
      var response = await request.send();

      // Parse the response
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final responseData = jsonDecode(responseBody);

        setState(() {
          _result = responseData.toString();
          _result2 = responseData;
          _isLoading = false;

          // Check for dangerous classes
          List<String> dangerousClasses = ['bear', 'gorilla', 'hyena', 'leopard', 'lion', 'rhinoceros', 'tiger', 'wolf'];
          for (var result in responseData) {
            if (result['label'] != null && dangerousClasses.contains(result['label'].toLowerCase())) {
              _showDangerAlert();
              break;
            }
          }
        });
      } else {
        _showPopup('API Error', 'Failed to get a response from the API');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _showPopup('API Error', e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showPopup(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDangerAlert() {
    // Play danger sound
    _audioPlayer.play(AssetSource('emg/danger.mp3'));

    // Show danger alert
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Danger Alert!'),
          content: Text('A dangerous animal has been detected.'),
          backgroundColor: Colors.red,  // Set background color to red for alert
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _zoomIn() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final zoom = (_currentZoomLevel + 1).clamp(1.0, _maxZoomLevel);
      await _cameraController!.setZoomLevel(zoom);
      setState(() {
        _currentZoomLevel = zoom;
      });
    }
  }

  Future<void> _zoomOut() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final zoom = (_currentZoomLevel - 1).clamp(1.0, _maxZoomLevel);
      await _cameraController!.setZoomLevel(zoom);
      setState(() {
        _currentZoomLevel = zoom;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _audioPlayer.dispose();  // Dispose of the audio player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_cameraController!),

          // Flash effect overlay
          if (_isFlashing)
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.8),
              ),
            ),

          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: _isLoading
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(),
                ),
              ],
            )
                : Container(
              color: Colors.black54,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    _result.isNotEmpty ? 'Label: ${_result2[0]['label'].toString()}' : '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _result.isNotEmpty ? 'Confidence: ${_result2[0]['confidence'].toString()}' : '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            child: FloatingActionButton(
              onPressed: _captureAndSendImage,
              child: Icon(Icons.camera_alt),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _zoomIn,
                  child: Icon(Icons.zoom_in),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _zoomOut,
                  child: Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 16,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 15),
            ),
          ),
        ],
      ),
    );
  }
}
