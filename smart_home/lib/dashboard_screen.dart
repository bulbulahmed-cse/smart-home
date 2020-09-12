import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Material item(IconData _icon, String _title, _color) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Colors.grey,
      borderRadius: BorderRadius.circular(40),
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
                        style: TextStyle(color: _color, fontSize: 20),
                      ),
                    ),
                  ),
                  Material(
                    color: _color,
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        _icon,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.width * 0.3,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StaggeredGridView.count(
        crossAxisCount: 1,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: <Widget>[
          InkWell(
              child: item(Icons.home, "Home", Colors.green),
          ),
          InkWell(
              child: item(Icons.directions_car, "Parking", Colors.blue),
          ),
        ],
        staggeredTiles: [
          StaggeredTile.extent(1, MediaQuery.of(context).size.height * .43),
          StaggeredTile.extent(1, MediaQuery.of(context).size.height * .43),
        ],
      ),
    );
  }
}
