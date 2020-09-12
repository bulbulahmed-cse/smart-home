import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_home/Farming.dart';
import 'package:smart_home/Home.dart';
import 'package:smart_home/LoginScreen.dart';
import 'package:smart_home/Parking.dart';

class Drawers extends StatefulWidget {
  @override
  _DrawersState createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  var _email='',_name='';
  void getData() async {
    getEmail();
    DatabaseReference reference= FirebaseDatabase.instance.reference();
    reference.child('Flats').onValue.listen((event) {
      var data= event.snapshot;
      var datas= data.value;
      for(var v=1;v<datas.length;v++){
        if(datas[v]['email']==_email){
          //print(datas[v]['temperature']);
          setState(() {

            _name=datas[v]['personal_details']['name'].toString();

          });

        }
      }
    });

  }
  void getEmail() async {
    setState(() {
      FirebaseAuth.instance
          .authStateChanges()
          .listen((User user) {
        _email=user.email;
        print(_email);
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(

            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: ()=>Navigator.pop(context),
                  ),
                ),
                ListTile(
                  title: Text(_name),
                  subtitle: Text(_email),
                  leading: Icon(Icons.account_circle,size: 70,),
                ),
              ],
            )
            ),

          ListTile(
            title: Text('Home'),
            leading: Icon(Icons.home),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.push(context, MaterialPageRoute(builder: (context) => Home(),));
            },
          ),
          ListTile(
            title: Text('Parking'),
            leading: Icon(Icons.directions_car),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Parking(),));
              // Update the state of the app
              // ...
              // Then close the drawer
              
            },
          ),
          ListTile(
            title: Text('Farming'),
            leading: ImageIcon(
              AssetImage('assets/agriculture.png'),
              color: Colors.black38,
              size: 20,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Farming(),));
              // Update the state of the app
              // ...
              // Then close the drawer

            },
          ),
          ListTile(
            title: Text('Log Out'),
            leading: Icon(Icons.close),
            onTap: () async {
              await FirebaseAuth.instance.signOut();

              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  LoginScreen()), (Route<dynamic> route) => false);
              // Update the state of the app
              // ...
              // Then close the drawer

            },
          ),
        ],
      ),
    );
  }
}
