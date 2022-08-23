import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickquiz/views/home.dart';
import 'package:quickquiz/views/play_quiz.dart';
import 'package:quickquiz/views/signin.dart';

class RouteServices{
  static Route<dynamic> generateRoute(RouteSettings routeSettings){
    final args = routeSettings.arguments;
    switch (routeSettings.name){
      case "/home":
        return CupertinoPageRoute(builder: (_){
          return  Home();
        });
      case "/?link=https://www.google.com&apn=com.example.quickquiz":
        return CupertinoPageRoute(builder: (context){
          return const SignIn();
        });
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        appBar: AppBar(title: const Text("Pagina no encontrada"),),
      );
    });
  }
}