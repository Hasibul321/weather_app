import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
void main() {
  runApp(
    MaterialApp(
      home:myApp(),
  ));
}
class myApp extends StatefulWidget {
  const myApp({Key? key}) : super(key: key);

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  var temp,humidity,lat,lon,local,city;

  //location

  void locator()async{
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat=position.latitude.toStringAsFixed(2);
      lon=position.longitude.toStringAsFixed(2);
    });
  }

  void getLocation()async{
    String url='https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=56c6ebf76fffc33698398004b9dbf5cb';
    var res=await http.get(Uri.parse(url));
    var result=jsonDecode(res.body);
    setState(() {
      temp=result['main']['temp'];
      local=result['name'];
    });
  }

  TextEditingController textEditingController=new TextEditingController();
   void getWeather()async{
     String url="https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=56c6ebf76fffc33698398004b9dbf5cb&fbclid=IwAR067N0t4vM8F_wu6GTcctuTFm4r5OddMkqVjf32L_CqyCG6TqkBhUx0Rg0";
     var res=await http.get(Uri.parse(url));
    var result=jsonDecode(res.body);
    setState(() {
      temp=result['main']['temp'];
    });
  }
  void setCity(){
     setState((){
       city=textEditingController.text;
     });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWeather();
    setCity();
    locator();
    getLocation();
  }
  @override
  Widget build(BuildContext context) {
    var dt=DateFormat("yyyy-MM-dd hh-mm a").format(DateTime.now());
    return Scaffold(
      body:SafeArea(
        child: Container(
          padding:EdgeInsets.all(34),
          child: Column(

            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width:150,
                      child: TextField(
                        style: TextStyle(
                          fontSize: 30,
                        ),
                        controller: textEditingController,
                        decoration: InputDecoration(
                          hintText: "city name",
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: Colors.blue,
                        textColor: Colors.black87,
                        child: Text("location",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: (){
                              locator();
                              getLocation();
                    }),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text("latitude :"+lat.toString()

                    ),
                    SizedBox(width:90,),
                    Text("longitude "+lon.toString()),
                  ],
                ),
              ),
              Expanded(child: Row(
                children: [
                  Text("city name"+local.toString()),
                ],
              )),
              Expanded(child: Row(
                children: [
                  MaterialButton(
                      color: Colors.blue,
                      textColor: Colors.black87,
                      child: Text("GetWeather",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: (){
                          setCity();
                          getWeather();
                  })
                ],
              )),
              Text(dt,style: TextStyle(fontSize: 20,),),
              Expanded(child: Row(
                children: [
                  Text("temp",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(width:100,),
                  Text(temp.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
                ],
              )),
              Expanded(child: Row(
                children: [
                  Text("humidity ",style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),)
                ],
              ))
            ],
          ),
        ),
      )
    );
  }
}

