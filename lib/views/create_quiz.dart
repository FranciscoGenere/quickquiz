import 'package:flutter/material.dart';
import 'package:quickquiz/services/database.dart';
import 'package:quickquiz/views/addquestion.dart';
import 'package:quickquiz/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({Key? key}) : super(key: key);

  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  late String quizImageUrl, quizTitle, quizDescription, quizId;
  DatabaseService databaseService = DatabaseService();

  bool _isLoading = false;

  createQuizOnline() async{
    if (_formKey.currentState!.validate()){

      setState((){
        _isLoading = true;
      });

      quizId = randomAlphaNumeric(16);

      Map<String,String> quizMap = {
        "quizId" : quizId,
        "quizImgUrl" :quizImageUrl,
        "quizTitle" : quizTitle,
        "quizDesc" : quizDescription
      };
       await databaseService.addQuizData(quizMap, quizId).then((value){
         setState((){
           _isLoading = false;
           Navigator.pushReplacement(context, MaterialPageRoute(
               builder: (context)=> AddQuestion(
                quizId
               )
           ));
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
        iconTheme: const IconThemeData(color: Colors.black87),
        brightness: Brightness.light,
      ),
      body: _isLoading ? Container(
        child: const Center(child: CircularProgressIndicator(),),
      ) : Form(
        key: _formKey,
          child: Container(

            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/newquiz.gif"),
                fit: BoxFit.cover,
              ),
            ),



            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              const SizedBox(height: 25,),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Ingrese un enlace valido" : null,
                decoration: const InputDecoration(
                  fillColor: Colors.white,filled: true,
                  hintText: "Enlace de la imagen (Opcional)",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                onChanged: (val){
                  quizImageUrl = val;
                },
              ),
              const SizedBox(height: 6,),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Ingrese un titulo valido" : null,
                decoration: const InputDecoration(
                  fillColor: Colors.white,filled: true,
                  hintText: "Titulo",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                onChanged: (val){
                  quizTitle = val;
                },
              ),
              const SizedBox(height: 6,),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Ingrese una descripcion valida" : null,
                decoration: const InputDecoration(
                  fillColor: Colors.white,filled: true,
                  hintText: "Descripcion",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                onChanged: (val){
                  quizDescription = val;
                },
              ),
              const Spacer(),
              GestureDetector(
                onTap: (){
                  createQuizOnline();
                },
                  child: blueButton(
                    context: context,
                    label: "Crear Quiz"
                  )),
              const SizedBox(height: 50,),
            ],),
          ),
        ),
    );
  }
}
