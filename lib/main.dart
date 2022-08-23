import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:quickquiz/helper/functions.dart';
import 'package:quickquiz/route_services.dart';
import 'package:quickquiz/views/home.dart';
import 'package:quickquiz/views/signin.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isLoggedin = false;
  @override
  void initState() {
    checkUserLoggedInStatus();
    // TODO: implement initState
    super.initState();
  }
  checkUserLoggedInStatus() async{
    HelperFunctions.getUserLoggedInDetails().then((value) {
      setState((){
        _isLoggedin = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickQuizApp',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteServices.generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:  _isLoggedin ? const SignIn() : Home(),
    );
  }
}