import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piot/modules/NewWatering.dart';
import 'info_plant.dart';
import 'new_plant.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'size_config.dart';
import 'package:provider/provider.dart';

class Plant {
  final String name;
  final String position;
  String image;
  String humidity;
  String exposure;
  String temperature;
  final bool img;
  bool sync;

  Plant({
    required this.name,
    required this.position,
    required this.image,
    required this.humidity,
    required this.exposure,
    required this.temperature,
    required this.img,
    required this.sync

  });
}


//final plantsProvider = ChangeNotifierProvider<List<Plant>>((ref) => List<Plant>());


class HomePage extends StatefulWidget{
  static String routeName = "/homepage";

  @override
  State<StatefulWidget> createState() => _HomePageState();
  
}



class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Plant> _plants = [];
  int counter = 0;
  String category = "All";
  String sync = "True";

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  void addPlant(Plant newPlant) {
    setState(() {
      _plants.add(newPlant);
    });
  }

  void removePlant(Plant oldPlant) {
    setState(() {
      _plants.remove(oldPlant);
    });
  }

  Future<void> readJson() async{
    _plants = [];
    final String response = await rootBundle.loadString('images/plant.json');
    final data = await json.decode(response);
    List<Plant> _plantList = [];
    int j = 0;
    for (var i in data["items"]){
        _plantList.add(Plant(
          name: i["Plant_Name"],
          position: i["Location"],
          image: "",
          humidity:j==0 ? i["Humidity"]: "n/a",
          exposure:j==0 ? i["Exposure"]: "n/a",
          temperature:j==0 ? i["Temperature"]: "n/a",
            img: false,
          sync: j==0 ? true:false
        ));
        j=1;
    }
    setState(() {
      _plants = _plantList;
    });
  }

  void _handleTabSelection() {
    if (_tabController.index == 0) {
      print(category);
      setState(() {
        category = "All";
      });
    } else if (_tabController.index == 1) {
      print(category);
      setState(() {
        category = "Outdoor";
      });
    } else if (_tabController.index == 2) {
      print(category);
      setState(() {
        category = "Indoor";
      });
    } else if (_tabController.index == 3) {
      setState(() {
        category = "Garden";
      });
    } else if (_tabController.index == 4) {
      setState(() {
        category = "Varanda";
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset("images/piot4.png", scale: 10,),
                      SizedBox(width: getProportionateScreenWidth(150),),


                      Column(
                        children: [
                          SizedBox(height: 5,),
                          InkWell(
                              child: SizedBox(
                                width: getProportionateScreenWidth(60),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.asset("images/clock.png"),
                                ),
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => NewWateringPage(plants: _plants,),));
                              },
                            ),
                          Text("Reminder")
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, left: 16),
                  child: Text("Plants", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, left: 16, right: 16),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(fontSize: 14,color: Colors.grey.shade600),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.black, size: 30,),
                        suffixIcon: Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.repeat, color: Colors.white,),
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.all(6),
                        )
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                TabBar(
                  //controller: _tabController,
                  isScrollable: true,
                  labelStyle: TextStyle(fontSize: 15),
                  unselectedLabelStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
                  labelColor: Colors.green,
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(color: Colors.grey.shade200)
                  ),
                  unselectedLabelColor: Colors.grey.shade500,
                  tabs: <Widget>[
                    Tab(
                        text: "All"
                    ),
                    Tab(
                        text: "Outdoor"
                    ),
                    Tab(
                        text: "Indoor"
                    ),
                    Tab(
                        text: "Garden"
                    ),
                    Tab(
                        text: "Varanda"
                    ),

                  ],
                ),
                Container(
                  height: 336,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _plants.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index){
                        if ((category == "All") || (category == _plants[index].position)){
                          return InkWell(
                            child: Container(
                              width: 170,

                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.only(left: 16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _plants[index].sync ?
                                  Text("synchronized", style: TextStyle(fontSize: 15, color: Colors.green),):
                                  InkWell(
                                    child: Text("tap to sync", style: TextStyle(fontSize: 15, color: Colors.redAccent),),
                                    onTap: () {

                                    },

                                  ),
                                  Text(_plants[index].position!, style: TextStyle(fontSize: 14, color: Colors.grey.shade500),),


                                  SizedBox(height: 6,),
                                  Text(_plants[index].name!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                                  SizedBox(height: 10,),
                                  _plants[index].img ?
                                  Image.file(File(_plants[index].image), height: 130, width: 130, fit: BoxFit.cover):
                                  Image.asset("images/" + _plants[index].name! + ".jpg", height: 130, width: 130, fit: BoxFit.cover,),
                                  Row(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(height: 15,),
                                          Image.asset("images/humidity.jpg", height: 20, width: 20, fit: BoxFit.cover,),
                                          SizedBox(height: 8,),
                                          Image.asset("images/sun.jpg", height: 20, width: 20, fit: BoxFit.cover,),
                                          SizedBox(height:8,),
                                          Image.asset("images/temperature.jpg", height: 34, width: 20, fit: BoxFit.cover,),
                                        ],
                                      ),
                                      SizedBox(width: 5,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(height: 3,),
                                          Text("Humidity:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                                          SizedBox(height: 12,),
                                          Text("Exposure:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                                          SizedBox(height: 12,),
                                          Text("Temperature:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                                        ],
                                      ),
                                      SizedBox(width: 4,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(height: 3,),
                                          Text(_plants[index].humidity!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                                          SizedBox(height: 12,),
                                          Text(_plants[index].exposure!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                                          SizedBox(height: 12,),
                                          Text(_plants[index].temperature! + "", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                                        ],
                                      )


                                    ],
                                  ),

                                ],
                              ),
                            ),
                            onTap: () {
                              if (_plants[index].sync){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlantInfo(plant: _plants[index], removePlant: removePlant,),
                                  ));
                              }else{



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
                                                  setState(() {
                                                    _plants[index].sync = true;
                                                    _plants[index].humidity = "22%";
                                                    _plants[index].exposure = "44%";
                                                    _plants[index].temperature = "15°";
                                                  });
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
                            },
                          );
                        }else{
                          return null;
                        }


                      }),
                ),
                SizedBox(height: 5,),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  child: ListView.builder(
                      itemCount: 1,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index){
                        return InkWell(
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                            padding: EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Add a new Plant", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),),
                              ],
                            ),
                          ),
                          onTap: () {

                            Navigator.push(context, MaterialPageRoute(builder: (context) => NewPlant(addPlant: addPlant),));
                          },
                        );
                      }
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    readJson();

    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  
}