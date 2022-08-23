import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickquiz/helper/functions.dart';
import 'package:quickquiz/services/auth.dart';
import 'package:quickquiz/views/home.dart';
import 'package:quickquiz/views/signup.dart';
import 'package:firebase_core/firebase_core.dart';

import '../widgets/widgets.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _formKey = GlobalKey<FormState>();
  late String email, password;
  AuthService authService = AuthService();

  late bool _isLoading = false;

  signIn() async{
    if (_formKey.currentState!.validate()){
      setState((){
        _isLoading = true;
      });
      authService.signInEmailAndPass(email, password).then((val)  {
        if (val != null) {
          setState((){
            _isLoading = false;
          });
          // HelperFunctions.saveUserLoggedInDetails(isLoggedin: true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) =>  Home()

          ),);
        }

        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user !=null){
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) =>  Home()

            ),);
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),

      extendBodyBehindAppBar: true, // PONER EN SIGNUP
      body: _isLoading ? Container(
        child: const Center (child: CircularProgressIndicator(),),
      ): Form(
        key: _formKey,
        child: Container(
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //       image: NetworkImage(
          //           'https://i.pinimg.com/originals/52/51/73/5251733725a0bdaf48a237686ab04bc4.jpg'
          //       ),
          //   )
          // ),

          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/fondo1.2.png"),
              fit: BoxFit.fill,
            ),
          ),

          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60), //ESTE ES EL MARGEN DEL FONDO VA 24
          child: Column(
            children: [
              const Spacer(),
              Image.asset('assets/images/logoquiz.png',
                height: 100,
                width: 100,
              ),
              const Spacer(),
              TextFormField(
                style: const TextStyle(color: Colors.black), //TEXTO DE ADENTRO
                validator: (val){ return val!.isEmpty ? "Ingrese un correo valido" : null;},
                decoration: const InputDecoration(
                  fillColor: Colors.white,filled: true,
                  hintText: "Correo Electronico",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                onChanged: (val){
                  email = val;
                },
              ),
              const SizedBox(height: 6,),
              TextFormField(
                style: const TextStyle(color: Colors.black), //TEXTO DE ADENTRO
                obscureText: true,
                validator: (val){ return val!.isEmpty ? "Ingrese una contraseña valida" : null;},
                decoration: const InputDecoration(
                  fillColor: Colors.white,filled: true,
                    hintText: "Contraseña",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                onChanged: (val){
                  password = val;
                },
              ),
              const SizedBox(height: 24,), //TENIA UN 24


              GestureDetector(
                onTap: (){
                  signIn();
                },
                child: SingleChildScrollView(
                  child: blueButton(
                      context: context,
                      label: "Iniciar sesion"),
                ),

              ),

              const SizedBox(height: 18,),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  const Text("No tienes una cuenta? ", style: TextStyle(
                    fontSize: 15.5
                  ),),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context)=> const SignUp()
                      ));
                    },
                    child: const Text("Regístrate", style: TextStyle(
                        fontSize: 15.5, decoration: TextDecoration.underline, color: Colors.orange, fontWeight: FontWeight. bold
                    ),),
                  )
                ],
              ),
              const SizedBox(height: 100,),
            ],),
        ),
      ),
    );
  }
}
