import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
  List cityList=['naogaon','dhaka','bogra','rajshahi'];
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
    String url='https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=56c6ebf76fffc33698398004b9dbf5cb';
    var res=await http.get(Uri.parse(url));
    var result=jsonDecode(res.body);
    setState(() {
      temp=result['main']['temp'];
      city=result['name'];
      humidity = result['main']['humidity'];
      pressure=result['main']['pressure'];
      sunset=result['sys']['sunset'];
      sunrise=result['sys']['sunrise'];
      visibility=result['visibility'];
    });
  }

  TextEditingController textEditingController=new TextEditingController();
   void getWeather()async{
     String url="https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=56c6ebf76fffc33698398004b9dbf5cb&fbclid=IwAR067N0t4vM8F_wu6GTcctuTFm4r5OddMkqVjf32L_CqyCG6TqkBhUx0Rg0";
     var res=await http.get(Uri.parse(url));
    var result=jsonDecode(res.body);
    setState(() {
      temp=result['main']['temp'];
      humidity = result['main']['humidity'];
      lat=result['coord']['lat'];
      lon= result['coord']['lon'];
      pressure=result['main']['pressure'];
      sunset=result['sys']['sunset'];
      sunrise=result['sys']['sunrise'];
      visibility=result['visibility'];
      // temp=result['main']['temp'];
      // humidity = result['main']['humidity'];

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
                      width:150,
                      child: DropdownButton2(
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
                  Text("city name    "+city.toString(),
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
                  Text("তাপমাত্রা : ",
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
              Expanded(child: Row(
                children: [
                  Text("আর্দ্রতা  ",style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(width:100,),
                  Text( humidity.toString(),style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),)
                ],
              )),
              Expanded(child: Row(
                children: [
                  Text("বায়ু চাপ",style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(width:100,),
                  Text(pressure!=null?pressure.toString()+" mBar":"loading",style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),)
                ],
              )),
              Expanded(child: Row(
                children: [
                  Text("দৃষ্টিসীমা",style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(width:100,),
                  Text( visibility!=null?(visibility/1000).toString()+" km":"Loading",style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),)
                ],
              )),
              Expanded(child: Row(
                children: [
                  Text("সূর্যোদয় ",style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(width:105,),
                  Text( "সূর্যাস্ত",style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),)
                ],
              )),
              Expanded(child: Row(
                children: [
                  Image.network('https://rukminim1.flixcart.com/image/416/416/jzsqky80/poster/h/y/4/medium-nature-wall-poster-sunrise-poster-poster-high-resolution-original-imafjqjyasudq8sg.jpeg?q=70'),
                  SizedBox(width:90,),
                  Image.network('https://media.istockphoto.com/id/1172427455/photo/beautiful-sunset-over-the-tropical-sea.jpg?s=612x612&w=0&k=20&c=i3R3cbE94hdu6PRWT7cQBStY_wknVzl2pFCjQppzTBg='),
                ],
              )),
              Expanded(child: Row(
                children: [
                  Text( sunrise!=null?formatted(sunrise):"loading",style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(width:40,),

                  Text(sunset!=null?formatted(sunset):"loading",style: TextStyle(
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

