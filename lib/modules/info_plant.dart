import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:piot/modules/auto-watering.dart';
import 'package:piot/modules/watering.dart';
import 'size_config.dart';
import 'home_page.dart';
import 'dart:io';

final double rating = 3.5;
class PlantInfo extends StatefulWidget{
  final Plant plant;
  final Function(Plant) removePlant;


  PlantInfo({required this.plant, required this.removePlant});

  @override
  _PlantInfoState createState() => _PlantInfoState();
}

class _PlantInfoState extends State<PlantInfo> {


  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text("Are you sure you want to delete " + widget.plant.name + " ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform the desired action
                // e.g., save the plant data
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context);
              },
              child: Text('Proceed'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(

          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Icon(Icons.arrow_back_ios, size: 20, ),
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          SizedBox(width: 15,),
                          InkWell(
                            child: SizedBox(
                              width: getProportionateScreenWidth(80),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Image.asset("images/watering.jpg"),
                              ),
                            ),
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AutowateringPage(),
                                  ));

                            },
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(238),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: widget.plant.img ? Image.file(File(widget.plant.image)) : Image.asset("images/" + widget.plant.name! + ".jpg"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: getProportionateScreenWidth(20)),
                  padding: EdgeInsets.only(top: getProportionateScreenWidth(20)),
                  width: 1000,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                      Padding(padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20)),
                        child: Text(
                          widget.plant.name!,
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w500, color: Colors.white,),
                        )
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.all(getProportionateScreenWidth(15)),
                          width: getProportionateScreenWidth(110),
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20)
                            )
                          ),
                          child: Text(

                                widget.plant.position!,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white,),
                           )
                          ),
                        ),
                      Container(
                        margin: EdgeInsets.only(left: getProportionateScreenWidth(15)),
                          child: Text("Plant Health", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white,))),

                      Container(
                          margin: EdgeInsets.only(top: getProportionateScreenWidth(5), left: getProportionateScreenWidth(10)),
                          padding: EdgeInsets.only(top: getProportionateScreenWidth(5)),
                          width: 220,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40)
                              )
                          ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IgnorePointer(
                              child: RatingBar.builder(
                                  minRating: 1,
                                  allowHalfRating: true,
                                  initialRating: rating,
                                  itemBuilder: (context, index) {
                                    switch (index) {
                                      case 0:
                                        return Icon(
                                          Icons.sentiment_very_dissatisfied,
                                          color: Colors.red,
                                        );
                                      case 0:
                                        return Icon(
                                          Icons.sentiment_very_dissatisfied,
                                          color: Colors.red,
                                        );
                                      case 1:
                                        return Icon(
                                          Icons.sentiment_dissatisfied,
                                          color: Colors.redAccent,
                                        );
                                      case 2:
                                        return Icon(
                                          Icons.sentiment_neutral,
                                          color: Colors.amber,
                                        );
                                      case 3:
                                        return Icon(
                                          Icons.sentiment_satisfied,
                                          color: Colors.lightGreen,
                                        );
                                      case 4:
                                        return Icon(
                                          Icons.sentiment_very_satisfied,
                                          color: Colors.green,
                                        );
                                      default:
                                        return Text(" ");
                                    }
                                  },
                                  onRatingUpdate: (rating) {print(rating);}),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: getProportionateScreenWidth(5), left: getProportionateScreenWidth(10)),
                        padding: EdgeInsets.only(top: getProportionateScreenWidth(5)),
                        width: 220,
                        height: 120,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)
                            )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 5,),
                                Image.asset("images/humidity.jpg", height: 25, width: 25, fit: BoxFit.cover,),
                                SizedBox(height: 8,),
                                Image.asset("images/sun.jpg", height: 25, width: 25, fit: BoxFit.cover,),
                                SizedBox(height:8,),
                                Image.asset("images/temperature.jpg", height: 38, width: 25, fit: BoxFit.cover,),
                              ],
                            ),
                            SizedBox(width: 15,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 7,),
                                Text("Humidity:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                                SizedBox(height: 14,),
                                Text("Exposure:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                                SizedBox(height: 15,),
                                Text("Temperature:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                              ],
                            ),
                            SizedBox(width: 8,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 7,),
                                Text(widget.plant.humidity!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                                SizedBox(height: 14,),
                                Text(widget.plant.exposure!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                                SizedBox(height: 15,),
                                Text(widget.plant.temperature! + "°", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                              ],
                            )

                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          widget.removePlant(widget.plant);
                          _showAlertDialog(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: getProportionateScreenWidth(15), left: getProportionateScreenWidth(10), right: getProportionateScreenWidth(10)),
                          padding: EdgeInsets.only(top: getProportionateScreenWidth(5)),
                          width: 500,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40)
                              )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 5,),
                              Text("Delete Plant", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white,))
                            ],
                          ),
                        ),
                      ),





                    ],
                  ),
                )
              ],
            ),
          ),

      )
    );
  }
}