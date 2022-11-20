import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

void main() {
  runApp(
    MaterialApp(
      home:splashScreen(),
  ));
}
class splashScreen extends StatelessWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/weather.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("HamroMasum",
            style: TextStyle(
              color: Colors.black54,
            ),),
            MaterialButton(
          child: Text("Home Screen"),
                color: Colors.blue,
                
                onPressed: (){
            Navigator.push(context, 
            MaterialPageRoute(builder: (context)=>myApp()),
                  );
                })
          ],
        ),
      )
    );
  }
}


class myApp extends StatefulWidget {
  const myApp({Key? key}) : super(key: key);

  @override
  State<myApp> createState() => _myAppState();
}


class _myAppState extends State<myApp> {
  List cityList=['Naogaon','Dhaka','Bogra','Rajshahi'];
  String?selectedValue;
  var temp,humidity,lat,lon,local,city,pressure,sunset,sunrise,visibility;
  //
  // var date = DateTime.fromMillisecondsSinceEpoch(1000*1668730987);
  // var formt = new DateFormat('HH:mm a').format(date);
  //location

  void locator()async{
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat=position.latitude.toStringAsFixed(4);
      lon=position.longitude.toStringAsFixed(4);
    });
  }

  void getLocation()async{
   String url = "http://api.weatherapi.com/v1/forecast.json?key=23e30e09626240998a133605222011 &q="+lat+","+lon+"&days=7&aqi=yes&alerts=no";
    var res=await http.get(Uri.parse(url));
    var result=jsonDecode(res.body);
    //print(result['location']['name']);
    setState(() {
      temp=result['current']['temp_c'];
      city=result['location']['name'];

    });
  }

  TextEditingController textEditingController=new TextEditingController();
   void getWeather()async{
     String url = "http://api.weatherapi.com/v1/forecast.json?key=23e30e09626240998a133605222011 &q="+city+"&days=7&aqi=yes&alerts=no";
     var res=await http.get(Uri.parse(url));
    var result=jsonDecode(res.body);
    setState(() {
      temp=result['current']['temp_c'];
      lat=result['location']['lat'];
      lon= result['location']['lon'];


    });
  }
  // void setCity(){
  //    setState((){
  //      city=textEditingController.text;
  //    });
  //
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWeather();
    //setCity();
    locator();
    getLocation();
  }
  @override
  Widget build(BuildContext context) {
    var dt=DateFormat("dd MMMM , yy       hh-mm a").format(DateTime.now());
    return Scaffold(
      backgroundColor: Colors.cyanAccent,

      appBar: AppBar(
        title: Text("Weather App",),
        backgroundColor: Colors.blue,
      ),

      body:SafeArea(
        child: Container(
          padding:EdgeInsets.all(34),
          child: Column(

            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width:140,
                      child: SizedBox(
                        height:100,
                        width:90,

                        child: DropdownButton2(
                          alignment: AlignmentDirectional.center,
                          hint: Text(
                            'Select city',
                            style: TextStyle(
                              fontSize: 24,
                              color: Theme
                                  .of(context)
                                  .hintColor,
                            ),
                          ),
                          items: cityList
                              .map((item) =>
                              DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ))
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as String;
                              city=selectedValue;
                            });
                          },
                          buttonHeight: 40,
                          buttonWidth: 140,
                          itemHeight: 40,
                        ),
                      ),
                    ),
                    SizedBox(width:10,),
                    ElevatedButton(
                      onPressed: () {
                        locator();
                        getLocation();
                      },
                      child: Row(
                        children: [
                          Text("Location",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                      Icon(
                        Icons.add,
                        size: 24.0,
                      ),
                      ]
                      ),// <-- Text
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text("lat: "+lat.toString(),
                style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
                    ),
                    SizedBox(width:10,),
                    Text("long : "+lon.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),),
                  ],
                ),
              ),
              Expanded(child: Row(
                children: [
                  Text("City name   "+city.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
                ],
              )),
              Expanded(child: Row(
                children: [
                  SizedBox(width: 60,),
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
                          // setCity();
                          getWeather();
                  })
                ],
              )),
              Text(dt,style: TextStyle(fontSize: 20,),),
              Expanded(child: Row(
                children: [
                  Text("Temp : ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(width:10,),
                  Text(temp.toString() +" °C",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
                  SizedBox(width:10,),
                  Text(temp!=null?((temp*9+180)/5).toStringAsFixed(2) +" °F":"loading",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
                ],
              )),


            ],
          ),
        ),
      )
    );
  }
}

String formatted(timeStamp) {
  final DateTime date1 = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
  return DateFormat('hh:mm:ss a').format(date1);
}

