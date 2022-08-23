import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickquiz/helper/functions.dart';
import 'package:quickquiz/services/auth.dart';
import 'package:quickquiz/views/home.dart';
import 'package:quickquiz/views/signin.dart';
import 'package:quickquiz/widgets/widgets.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  late String name, email, password;
  AuthService authService = AuthService();
  late bool _isLoading = false;
  signUp() async{
    if (_formKey.currentState!.validate()){
      setState((){
        _isLoading = true;
      });
       await authService.signUpWithEmailAndPassword( email, password).then((value){
        if (value == null){
          setState((){
            _isLoading = false;
          });
          HelperFunctions.saveUserLoggedInDetails(isLoggedin: true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) =>  Home()
          ));
        }
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
        elevation: 0.0, systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      extendBodyBehindAppBar: true,
      body: _isLoading ? Container(
        child: const Center (child: CircularProgressIndicator(),),
      ): Form(
        key: _formKey,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/fondo1.3.png"),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 60), //ESTABA EN MARGIN
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
                validator: (val){ return val!.isEmpty ? "Ingrese un nombre valido" : null;},
                decoration: const InputDecoration(
                  fillColor: Colors.white,filled: true,
                    hintText: "Nombre",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                onChanged: (val){
                  name = val;
                },
              ),
              const SizedBox(height: 6,),
              TextFormField(
                style: const TextStyle(color: Colors.black), //TEXTO DE ADENTRO
                validator: (val){ return val!.isEmpty ? "Ingrese un correo valido" : null;},
                decoration: const InputDecoration(
                  fillColor: Colors.white,filled: true,
                    hintText: "Correo Electronico",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
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
              const SizedBox(height: 24,),
              GestureDetector(
                onTap: (){
                  signUp();
                },
                child: blueButton(
                    context: context,
                    label: "Regístrate"),
              ),
              const SizedBox(height: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  const Text("Ya tienes una cuenta? ", style: TextStyle(fontSize: 15.5 ),),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context)=> const SignIn()
                      ));
                    },
                    child: const Text("Inicia Sesion", style: TextStyle(
                        fontSize: 15.5, decoration: TextDecoration.underline, color: Colors.blue, fontWeight: FontWeight. bold
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
