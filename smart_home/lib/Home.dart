import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/Drawer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_database/firebase_database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _light='on',_fan='off',_pump='on';

  var _flame='',_gas='',_temperature='',_smoke='',_humidity='';
  var _email='';

  var index;

  Material details(_icon,_title,_value,_color) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Colors.grey,
      borderRadius: BorderRadius.circular(10),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _title,
                        style: TextStyle(color: _color, fontSize: 14,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Material(
                    color: _color,
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ImageIcon(
                        AssetImage(_icon),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _value,
                        style: TextStyle(color: _color, fontSize: 13,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEmail();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text("Home"),
       ),
      drawer: Drawers(),
      body: StaggeredGridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: <Widget>[
          //details start
          InkWell(
            child: StaggeredGridView.count(
              primary: false,
              shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),

                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                children: <Widget>[
                  InkWell(
                    child: details('assets/fire.png', "Flame", _flame == '0'? 'Not Detected':'Detected',Colors.red),
                  ),
                  InkWell(
                    child: details('assets/humidity.png', "Humidity", _humidity+'%',Colors.green),
                  ),
                  InkWell(
                    child: details('assets/smoke.png', "Smoke", _smoke== '0'? 'Not Detected':'Detected',Colors.amber),
                  ),

                  InkWell(
                    child: details('assets/gas.png', "Gas", _gas== '0'? 'Not Detected':'Detected',Colors.blue),
                  ),
                  InkWell(
                    child: details('assets/temperature.png', "Temperature", _temperature+" °C",Colors.grey),
                  ),
                ],staggeredTiles: [
              StaggeredTile.extent(1, 135),
              StaggeredTile.extent(1, 135),
              StaggeredTile.extent(1, 135),
              StaggeredTile.extent(1, 135),
              StaggeredTile.extent(2, 135),
            ],)
          ),//details end
          InkWell(
            child: details('assets/light.png', "Light", _light,_light=='on'?Colors.blue:Colors.red),
            onTap: (){
              getUpdate('whiteled',_light);
              print(_light);

            },
          ),//button
          InkWell(
            child: details('assets/fan.png', "Fan", _fan,_fan=='on'?Colors.blue:Colors.red),
            onTap: (){
              getUpdate('fan',_fan);
            },
          ),//button
          InkWell(
            child: details('assets/pump.png',"pump",_pump, _pump=='on'?Colors.blue:Colors.red),
            onTap: (){
              getUpdate('pump', _pump);

            },
          ),//button
        ],
        staggeredTiles: [
          StaggeredTile.extent(3, 450),
          StaggeredTile.extent(1, 135),
          StaggeredTile.extent(1, 135),
          StaggeredTile.extent(1, 135),
        ],
      ),
    );
  }

  void getData() {
    DatabaseReference reference= FirebaseDatabase.instance.reference();
    reference.child('Flats').onValue.listen((event) {
      var data= event.snapshot;
      var datas= data.value;
      for(var v=1;v<datas.length;v++){
        if(datas[v]['email']==_email){
          //print(datas[v]['temperature']);
          setState(() {
            index=v;
            _flame=datas[v]['flam'].toString();
            _gas=datas[v]['gas'].toString();
            _temperature=datas[v]['temperature'].toString();
            _humidity=datas[v]['humidity'].toString();
            _smoke=datas[v]['smoke'].toString();
            _fan=datas[v]['switch']['fan'].toString();
            _pump=datas[v]['switch']['pump'].toString();
            _light=datas[v]['switch']['whiteled'].toString();
          });

        }
      }
    });

  }
  void getUpdate(type,state){

    if(index!=null){
      print(index);
      DatabaseReference reference= FirebaseDatabase.instance.reference();
      reference.child('Flats/'+index.toString()+'/switch').update({
        type.toString(): state=='off'?'on':'off'
      });
    }


  }

  void getEmail() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      _email=user.email;

      print(_email);
    });
  }
}
