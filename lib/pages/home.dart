import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutricare/nutritionix/nutrionixsearch.dart';
import '../AI Stuff/camerastream.dart';
import '../AI%20Stuff/imagefoodclassification.dart'; // Adjust the path as necessary

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FoodClassification _foodClassifier = FoodClassification();
  String _result = '';

  // In _HomeState class of home.dart
  void _uploadAndClassifyImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final classificationResult =
          await _foodClassifier.classifyImageFromSource(image);
      setState(() {
        _result =
            'Food: ${classificationResult['label']}, Calories: ${classificationResult['calories']}';
      });
    } else {
      setState(() {
        _result = 'No image selected';
      });
    }
  }

  void _openCameraStream() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            CameraStream(onFoodDetected: (String label, String calories) {
              // Handle the received data here
              // For example, update the state to display the received label and calories
              setState(() {
                _result = 'Food: $label, Calories: $calories';
              });
              // Pop the CameraStream off the navigation stack to return to the home screen
              Navigator.of(context).pop();
            })));
  }


  void handleItemSelected(String name, double calories, double cholesterol) {
    setState(() {
      _result = 'Food: $name, Calories: $calories, Cholesterol: $cholesterol';
    });
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _uploadAndClassifyImage,
              child: Text('Upload Image'),
            ),
            SizedBox(height: 20),
            Text(_result, style: TextStyle(fontSize: 20)),
            ElevatedButton(
              onPressed: _openCameraStream,
              child: Text('Open Camera Stream'),
            ),
            SizedBox(height: 20), // Add space between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NutritionixSearch(onItemSelected: handleItemSelected),
                ));
              },
              child: Text('Search Nutrition'),
            ),
          ],
        ),
      ),
    );
  }
}
