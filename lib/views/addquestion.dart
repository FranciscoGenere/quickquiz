import 'package:flutter/material.dart';
import 'package:quickquiz/services/database.dart';
import 'package:quickquiz/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;
  AddQuestion(this.quizId);

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  late String question, option1, option2, option3, option4;
  late bool _isLoading = false;

  DatabaseService databaseService = DatabaseService();
  uploadQuestionData() async {
    if(_formKey.currentState!.validate()){

      setState((){
        _isLoading = true;
      });

      Map<String, String> questionMap ={
        "question" : question,
        "option1" : option1,
        "option2" : option2,
        "option3" : option3,
        "option4" : option4
      };
      await databaseService.addQuestionData(questionMap, widget.quizId)
          .then((value){
        setState((){
          _isLoading = false;
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
      body: _isLoading ?  Container(
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ) : Form(
        key: _formKey,
        child: Container(

          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/newquiz.gif"),
              fit: BoxFit.cover,
            ),
          ),


          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            const SizedBox(height: 25,),
            TextFormField(
              validator: (val) => val!.isEmpty ? "Ingrese una pregunta valida" : null,
              decoration: const InputDecoration(
                fillColor: Colors.white,filled: true,
                hintText: "Pregunta",
                hintStyle: TextStyle(fontSize: 20),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
              onChanged: (val){
                question = val;
              },
            ),
            const SizedBox(height: 6,),
            TextFormField(
              validator: (val) => val!.isEmpty ? "Ingrese la opcion #1" : null,
              decoration: const InputDecoration(
                fillColor: Colors.white,filled: true,
                hintText: "Opcion #1 (Respuesta correcta)",
                hintStyle: TextStyle(color: Colors.green),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
              onChanged: (val){
                option1 = val;
              },
            ),
            const SizedBox(height: 6,),
            TextFormField(
              validator: (val) => val!.isEmpty ? "Ingrese la opcion #2" : null,
              decoration: const InputDecoration(
                fillColor: Colors.white,filled: true,
                hintText: "Opcion #2",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
              onChanged: (val){
                option2 = val;
              },
            ),
            const SizedBox(height: 6,),
            TextFormField(
              validator: (val) => val!.isEmpty ? "Ingrese la opcion #3" : null,
              decoration: const InputDecoration(
                fillColor: Colors.white,filled: true,
                hintText: "Opcion #3",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
              onChanged: (val){
                option3 = val;
              },
            ),
            const SizedBox(height: 6,),
            TextFormField(
              validator: (val) => val!.isEmpty ? "Ingrese la opcion #4" : null,
              decoration: const InputDecoration(
                fillColor: Colors.white,filled: true,
                hintText: "Opcion #4",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
              ),
              onChanged: (val){
                option4 = val;
              },
            ),
            const Spacer(),
            Row(

              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: blueButton(context: context,
                    label: "Crear",
                  buttonWidth: MediaQuery.of(context).size.width/2 - 36
                  ),
                ),
                SizedBox(width: 24,),
                GestureDetector(
                  onTap: (){
                    uploadQuestionData();
                  },
                  child: blueButton(context: context,
                    label: "Agregar pregunta",
                    buttonWidth: MediaQuery.of(context).size.width/2 - 36),
                ),
              ],
            ),
            const SizedBox(height: 50,),
          ],),
        ),
      ),
    );
  }
}
