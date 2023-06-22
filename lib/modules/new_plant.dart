import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';

class NewPlant extends StatefulWidget {
  final Function(Plant) addPlant;

  NewPlant({required this.addPlant});
  @override
  _NewPlantState createState() => _NewPlantState();
}

class _NewPlantState extends State<NewPlant> {
  File? _selectedImage;
  String? imagePath;
  String? _plantName;
  String? _plantPosition;
  String? _plant;
  bool _isButtonEnabled = true;
  bool _isSaveButtonEnabled = true;
  bool _isSynchronized = false;
  String? plantImage;
  bool plantPicked = false;



  final List<String> _positions = ['Outdoor', 'Indoor', 'Garden', 'Varanda'];
  final List<String> _plants= ['Rosemary', 'Lavender', 'Sage', 'Thyme', 'Oregano', 'Basil', 'Mint', 'Orchidea', 'Rose'];


  Future<void> _pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        plantPicked = false;
      });
    }
  }

  Future<void> _takePhoto() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        imagePath = pickedImage.path;
        plantPicked = false;
      });
    }
  }


  Future<void> _synchronize() async {
    setState(() {
      _isSynchronized = true;
      _isButtonEnabled = true;

    });

    

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 4), () {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Synchronization Completed'),
                actions: [
                  ElevatedButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });

        return AlertDialog(
          title: Text('Synchronizing...'),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16.0),
              Flexible(
                child: Text(
                  'To synchronize the smart pot with PIoT app, put your smartphone near the PIoT smart pot module.',
                ),
              ),
            ],
          ),
        );
      },
    );

  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: _selectedImage == null
              ? plantPicked ? Image.asset("images/" + plantImage!):Icon(Icons.add_a_photo, size: 50, color: Colors.grey[400])
              : Image.file(_selectedImage!, fit: BoxFit.cover),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImageFromGallery,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              child: Text('Choose from Gallery'),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: _takePhoto,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              child: Text('Take a Photo'),
            ),
          ],
        ),

      ],
    );
  }

  Widget _buildTextField({required String label, required Function(String?) onChanged}) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPositionDropdown() {
    return DropdownButtonFormField<String>(
      value: _plantPosition,
      onChanged: (newValue) {
        setState(() {
          _plantPosition = newValue;

        });
      },
      items: _positions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Position',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPlantDropdown() {
    return DropdownButtonFormField<String>(
      value: _plant,
      onChanged: (newValue) {
        setState(() {
          _plant = newValue;
          if(newValue != "" || newValue != null){
            plantImage = newValue! + ".jpg";
            plantPicked = true;
          }
        });
      },
      items: _plants.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Plant Species',
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Plant'),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 5, top: 5),
        child: ListView(
          children: [
            _buildImagePicker(),
            SizedBox(height: 16),
            _buildTextField(
              label: 'Plant Name',
              onChanged: (value) {
                setState(() {
                  _plantName = value;
                });
              },
            ),
            SizedBox(height: 16),
            _buildPositionDropdown(),
            SizedBox(height: 16),
            _buildPlantDropdown(),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _synchronize : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              child: Text('Synchronize'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              onPressed: _isSaveButtonEnabled ? () {
                widget.addPlant(Plant(
                  name: _plantName ?? 'default',
                  position: _plantPosition ?? 'default',
                  image: imagePath ?? 'default',
                  humidity: _isSynchronized ? "22%" : "n/a",
                  temperature:_isSynchronized ? "15°" : "n/a",
                  exposure: _isSynchronized ? "44%" : "n/a",
                  img: true,
                  sync: _isSynchronized ? true:false
                ));
                Navigator.pop(context);

              }:null,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}