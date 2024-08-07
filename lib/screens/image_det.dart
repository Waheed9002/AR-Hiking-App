import 'dart:convert';
import 'dart:convert' as JSON;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pytorch_mobile/pytorch_mobile.dart';
import 'package:pytorch_mobile/model.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class ImageDet extends StatefulWidget {
  const ImageDet({super.key});

  @override
  _ImageDetState createState() => _ImageDetState();
}

class _ImageDetState extends State<ImageDet> {
  final ImagePicker _picker = ImagePicker();
  Model? _model;
  String _result = "";
  var _result2;
  File? _selectedImage;
  bool _isLoading = false;

  final AudioPlayer _audioPlayer = AudioPlayer(); // Initialize AudioPlayer

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _isLoading = true;
          _selectedImage = File(pickedFile.path);
        });

        // Prepare the image to be sent to the API
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('https://wildanimal.abe27.site/detect'),
        );
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _selectedImage!.path,
        ));

        // Send the image and get the response
        final response = await request.send();

        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          final decodedData = json.decode(responseData);
          setState(() {
            _result = decodedData.toString();
            _result2 = decodedData;
            _isLoading = false;

            // Check for dangerous classes
            List<String> dangerousClasses = ['bear', 'gorilla', 'hyena', 'leopard', 'lion', 'rhinoceros', 'tiger', 'wolf'];
            for (var result in decodedData) {
              if (result['label'] != null && dangerousClasses.contains(result['label'].toLowerCase())) {
                _showDangerAlert();
                break;
              }
            }
          });
        } else {
          throw Exception('Failed to load detection result');
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error processing image: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
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

  @override
  void dispose() {
    _audioPlayer.dispose();  // Dispose of the audio player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, size: 15,)),
        title: const Text('Image Detection'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_selectedImage != null)
                  Image.file(
                    _selectedImage!,
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  )
                else
                  Container(
                      width: 250,
                      height: 250,
                      child: Center(child: const Text('No image selected'))),
                SizedBox(height: 30,),

                const SizedBox(height: 20),
                const SizedBox(height: 20),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  Column(
                    children: [
                      Text(
                        _result.isNotEmpty ? 'Label: ${_result2[0]['label'].toString()}' : 'No detection yet',
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        _result.isNotEmpty ? 'Confidence: ${_result2[0]['confidence'].toString()}' : '',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            left: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _selectFromGallery,
              child: const Text('Select from Gallery', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
