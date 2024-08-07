import 'package:flutter/material.dart';
import 'image_det.dart'; // Import the ImageDet page
import 'live_det.dart'; // Import the LiveDet page
import 'package:camera/camera.dart';

class Detection extends StatelessWidget {
  const Detection({super.key});

  Future<CameraDescription> _getFirstCamera() async {
    final cameras = await availableCameras();
    return cameras.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/wildlife.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Light black overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Back Button
          Positioned(
            top: 30,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context); // Navigate to the previous screen
              },
            ),
          ),
          // Main content
          Column(
            children: <Widget>[
              // Heading Text
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 200.0),
                  child: Text(
                    'Wildlife Identification',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: const Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // Buttons
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ImageDet()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white.withOpacity(0.8),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        child: const Text('Select from Gallery'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final camera = await _getFirstCamera();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LiveDetectionPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white.withOpacity(0.8),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        child: const Text('Live Detection'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
