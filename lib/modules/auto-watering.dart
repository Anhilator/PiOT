import 'package:flutter/material.dart';
import 'home_page.dart';

import 'package:flutter/material.dart';

class AutowateringPage extends StatefulWidget {
  @override
  _AutowateringPageState createState() => _AutowateringPageState();
}

class _AutowateringPageState extends State<AutowateringPage> {
  String _selectedWateringSystem = "Direct connection to the water system";
  late String _capacity;

  bool _isAutowateringEnabled = false;

  void _enableAutowatering() {
    setState(() {
      _isAutowateringEnabled = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Autowatering Enabled'),
          content: Text('Autowatering has been enabled.'),
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
  }

  void _disableAutowatering() {
    setState(() {
      _isAutowateringEnabled = false;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Autowatering Disabled'),
          content: Text('Autowatering has been disabled.'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autowatering'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            Text(
            'In order to activate autowatering, an autowatering module should be detected.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text('Watering System:'),
          SizedBox(width: 16),
          DropdownButton<String>(
            onChanged: (newValue) {
              setState(() {
                _selectedWateringSystem = newValue!;
              });
            },
            value: _selectedWateringSystem,
            items: <String>[
              'Direct connection to the water system',
              'Autonomous storage (manual refill)'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          SizedBox(height: 16),
          if (_selectedWateringSystem == 'Autonomous storage (manual refill)')
            TextField(
              decoration: InputDecoration(
                hintText: 'Insert storage capacity',
              ),
              onChanged: (value) {
                setState(() {
                  _capacity = value;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isAutowateringEnabled ? null : _enableAutowatering,
                      child: Text('Enable'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isAutowateringEnabled ? _disableAutowatering : null,
                    child: Text('Disable'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
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
                            title: Text('Module Detected'),
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
                      title: Text('Detecting...'),
                      content: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 16.0),
                          Flexible(
                            child: Text(
                              'Searching for an autonomous wataering module attached to the smart pot',
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text("Detect"),

            ),
          ],
        ),
     ),
    );
  }
}