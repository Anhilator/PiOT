import 'package:flutter/material.dart';
import 'dart:io';
import 'home_page.dart';

class PlantItem extends StatefulWidget {
  final Plant plant;
  final bool toggleAll;

  PlantItem({required this.plant, required this.toggleAll});

  @override
  _PlantItemState createState() => _PlantItemState();
}

class _PlantItemState extends State<PlantItem> {
  bool toggle = false;
  bool intelligentButton = true;
  bool customButton = false;
  bool intervalActive = false;
  TextEditingController intervalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
            ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 45), // Increase the vertical padding
                leading: Column(
                  children: <Widget> [
                    Text(widget.plant.name),
                    widget.plant.img ?
                    Image.file(File(widget.plant.image), height: 130, width: 130, fit: BoxFit.cover):
                    Image.asset("images/" + widget.plant.name! + ".jpg", height: 130, width: 130, fit: BoxFit.cover,),
                  ],
                ),
                trailing: Switch(
                    value: widget.toggleAll ? true : toggle,
                    onChanged: (value) {
                        setState(() {
                            toggle = value;
                        });
                    },
                ),
            ),
            Row(
                children: [
                    Expanded(
                        child: RadioListTile(
                        title: Text('Intelligent'),
                        value: true,
                        groupValue: intelligentButton,
                        onChanged: (value) {
                            setState(() {
                                intelligentButton = value as bool;
                                customButton = !value;
                                intervalActive = false;
                            });
                        },
                        ),
                    ),
            Expanded(
                child: RadioListTile(
                title: Text('Custom'),
                value: true,
                groupValue: customButton,
                onChanged: (value) {
                    setState(() {
                        customButton = value as bool;
                        intelligentButton = !value;
                        intervalActive = value;
                    });
                },
                ),
            ),
                ],
          ),
          if (intervalActive)
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: intervalController,
                decoration: InputDecoration(
                  labelText: 'Interval',
                ),
              ),
            ),
        ],
    );
  }

  @override
  void dispose() {
    intervalController.dispose();
    super.dispose();
  }
}


class NewWateringPage extends StatefulWidget {
  final List<Plant> plants;

  NewWateringPage({required this.plants});

  @override
  _NewWateringPageState createState() => _NewWateringPageState();
}

class _NewWateringPageState extends State<NewWateringPage> {
  bool toggleAll = false;
  bool intelligentAll = false;
  List<bool> toggle = [];
  List <bool> intelligentButton = [];
  List <bool> customButton = [];
  List<bool> intervalActive = [];
  List<String> capacity = [];

  @override
  Widget build(BuildContext context) {

    for (var plant in widget.plants){
      intelligentButton.add(false);
      customButton.add(false);
      intervalActive.add(false);
      capacity.add('');
      toggle.add(false);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Text('Watering Reminder',style: TextStyle(color: Colors.black),),
      ),
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 190,),
                Column(
                  children: <Widget> [
                    Text('Enable All'),
                    SizedBox(height: 32,),
                    Text('All Intelligent'),
                  ],
                ),
                Column(
                  children: <Widget> [

                    Switch(
                      value: toggleAll,
                      onChanged: (value) {
                        setState(() {
                          toggleAll = value;
                        });
                      },
                    ),

                    Switch(
                      value: intelligentAll,
                      onChanged: (value) {
                        setState(() {
                          intelligentAll = value;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
            Container(
              height: 512,
           //   width: 300,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.plants.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index){
                      return Container(
                        width: 300,

                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Text(widget.plants[index].position!, style: TextStyle(fontSize: 14, color: Colors.grey.shade500),),


                                SizedBox(height: 6,),
                                Text(widget.plants[index].name!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                                SizedBox(height: 10,),
                                widget.plants[index].img ?
                                Image.file(File(widget.plants[index].image), height: 100, width: 100, fit: BoxFit.cover):
                                Image.asset("images/" + widget.plants[index].name! + ".jpg", height: 100, width: 100, fit: BoxFit.cover,),
                                ]
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //SizedBox(height: 100),
                                GestureDetector(
                                onTap: () {
                                    setState(() {
                                      intelligentButton[index] = !intelligentButton[index];
                                    });
                                },
                                child: Row(
                                    children: [
                                        Radio<bool>(
                                        value: true,
                                        groupValue: intelligentAll ? true : intelligentButton[index],
                                        onChanged: (value) {
                                            setState(() {
                                              intelligentButton[index] = value as bool;
                                              customButton[index] = !value;
                                              intervalActive[index] = false;
                                            });
                                        },
                                        ),
                                        Text('Intelligent'),
                                   ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      customButton[index] = !customButton[index];
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Radio<bool>(
                                        value: true,
                                        groupValue: customButton[index],
                                        onChanged: (value) {
                                          setState(() {
                                            customButton[index] = value as bool;
                                            intelligentButton[index] = !value;
                                            intervalActive[index] = value;
                                          });
                                          String capacityValue = '';
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Enter Interval in hour'),
                                                content: TextField(
                                                  onChanged: (value) {
                                                    capacityValue = value;
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: "How many hours interval?",
                                                    labelText: 'Interval',
                                                  ),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        capacity[index] = capacityValue;
                                                      });
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Save'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      Text('Custom'),
                                    ],
                                  ),
                                ),
                                customButton[index] ? Text("Interval: every " + capacity[index] + "h"):Text("")
                              ],
                            ),
                            SizedBox(width: 38,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget> [
                                Switch(
                                  value: toggleAll ? true : toggle[index],
                                  onChanged: (value) {
                                    setState(() {
                                      toggle[index] = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 100,)

                              ],
                            )
                          ],
                        ),

                      );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

