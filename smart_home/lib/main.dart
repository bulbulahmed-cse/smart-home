import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/Home.dart';
import 'package:smart_home/LoginScreen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _connection = false;
  bool _toast=false;
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    !_connection ? checkConnectivity() : checkUser();


    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  checkUser() async {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      // print(user.email);
      if (user == null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ));
      }
    });
  }

  void checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        print('connected');
        _connection = true;
      });
    } else {
      if(_toast == false){
        noInternetToast();
        _toast = true;
      }
      setState(() {
        _connection = false;
      });
    }
  }

  noInternetToast(){
    Fluttertoast.showToast(
        msg: "No Internet",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
