import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_home/Drawer.dart';

class Parking extends StatefulWidget {
  @override
  _ParkingState createState() => _ParkingState();
}

class _ParkingState extends State<Parking> {
  var _component1 = '',
      _component2 = '',
      _component3 = '',
      _component4 = '',
      _component5 = '',
      _component6 = '',
      _component7 = '',
      _component8 = '';

  Material details(_component, _value) {
    return Material(
      color: _value == 'Empty' ? Colors.red : Colors.blue,
      elevation: 14.0,
      shadowColor: Colors.grey,
      borderRadius: BorderRadius.circular(10),
      child: Center(
        child: ListTile(
          title: Text(
            _component,
            style: TextStyle(color: Colors.white),textAlign: TextAlign.center,
          ),
          subtitle: Text(_value,style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: <Widget>[
          InkWell(
            child: details('Compartment1', _component1),
          ),
          InkWell(
            child: details('Compartment2', _component2),
          ),
          InkWell(
            child: details('Compartment3', _component3),
          ),
          InkWell(
            child: details('Compartment4', _component4),
          ),
          InkWell(
            child: details('Compartment5', _component5),
          ),
          InkWell(
            child: details('Compartment6', _component6),
          ),
          InkWell(
            child: details('Compartment7', _component7),
          ),
          InkWell(
            child: details('Compartment8', _component8),
          ),
        ],
        staggeredTiles: [
          StaggeredTile.extent(1, 150),
          StaggeredTile.extent(1, 150),
          StaggeredTile.extent(1, 150),
          StaggeredTile.extent(1, 150),
          StaggeredTile.extent(1, 150),
          StaggeredTile.extent(1, 150),
          StaggeredTile.extent(1, 150),
          StaggeredTile.extent(1, 150),
        ],
      ),
    );
  }

  void getData() {
    DatabaseReference reference = FirebaseDatabase.instance.reference();
    reference.child('parking/1').onValue.listen((event) {
      var data = event.snapshot;
      var datas = data.value;
      print(datas);
      setState(() {
        _component1 = datas['stole_1'].toString();
        _component2 = datas['stole_2'].toString();
        _component3 = datas['stole_3'].toString();
        _component5 = datas['stole_5'].toString();
        _component4 = datas['stole_4'].toString();
        _component6 = datas['stole_6'].toString();
        _component7 = datas['stole_7'].toString();
        _component8 = datas['stole_8'].toString();
      });
    });
  }
}
