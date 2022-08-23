import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickquiz/models/question_model.dart';
import 'package:quickquiz/path_constant.dart';
import 'package:quickquiz/route_services.dart';
import 'package:quickquiz/services/database.dart';
import 'package:quickquiz/views/result.dart';
import 'package:quickquiz/widgets/quiz_play_widgets.dart';
import 'package:quickquiz/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;
  const PlayQuiz(this.quizId);


  @override

  State<PlayQuiz> createState() => _PlayQuizState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
String nada = "";
class _PlayQuizState extends State<PlayQuiz> {

  DatabaseService databaseService = DatabaseService();
  late QuerySnapshot questionSnapshot;

  QuestionModel getQuestionModelFromDatasnapshot(
     DocumentSnapshot questionSnapshot){

   QuestionModel questionModel = QuestionModel();

   questionModel.question = questionSnapshot["question"];

   List<String> options = [
     questionSnapshot["option1"],
     questionSnapshot["option2"],
     questionSnapshot["option3"],
     questionSnapshot["option4"]
   ];

   options.shuffle();

   questionModel.option1 = options [0];
   questionModel.option2 = options [1];
   questionModel.option3 = options [2];
   questionModel.option4 = options [3];
   questionModel.correctOption = questionSnapshot["option1"];
   questionModel.answered = false;

   return questionModel;
 }


  @override
  void initState() {
    initDynamicLinks();
    print("${widget.quizId}");
    databaseService.getQuizData(widget.quizId).then((value){
      questionSnapshot = value;
      _notAttempted = questionSnapshot.docs.length;
      _correct = 0;
      _incorrect = 0;
      total = questionSnapshot.docs.length;
      print("$total Preguntas en este quiz");
      setState((){

      });
    });
    super.initState();
  }

  String? _linkMessage;
  bool _isCreatingLink = false;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;


  Future<void> initDynamicLinks() async{
    dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri uri = dynamicLinkData.link;
      final queryParams = uri.queryParameters;
      if(queryParams.isNotEmpty){
        Navigator.pushNamed(context, dynamicLinkData.link.path);
      }
    });
  }
  Future<void> _createDynamicLink(bool short, String link)async{
    setState((){
      _isCreatingLink = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(link: Uri.parse(kUriPrefix + link), uriPrefix: kUriPrefix, androidParameters: const AndroidParameters(packageName: "com.example.quickquiz", minimumVersion: 0));
    Uri url;
    if (short){
      final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    }else{
      url = await dynamicLinks.buildLink(parameters);
    }
    setState((){
    _isCreatingLink = false;
    _linkMessage = url.toString();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black54
        ),
        brightness: Brightness.light,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async{
                  if (_linkMessage!=null){
                    await launch(_linkMessage!);
                  }
                },

                child: Text(_linkMessage ?? "", textAlign: TextAlign.left, style: const TextStyle(color: Colors.blue,
                ),
                ),
                onLongPress: (){
                  Clipboard.setData(ClipboardData(text: _linkMessage));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Link Copiado", textAlign: TextAlign.center,)));
                  },
              ),

              ButtonBar(
                alignment: MainAxisAlignment.start, buttonPadding: const EdgeInsets.only(right: 0, bottom: 0),
                children:<Widget> [
                  GestureDetector(
                    onTap: (){
                      setState((){

                      });
                    },

                    child: Positioned(
                        child:  Container(
                          width: 225.0,
                          child: Image.network("https://www.cargopedia.net/img/icon-validare-300.png",
                            height: 50),
                        ),
                    ),
                  ),


                  ElevatedButton(onPressed: !_isCreatingLink ? ()=> _createDynamicLink(
                      false, kQuizpageLink):null,
                      child: const Text("Compartir"),style: ElevatedButton.styleFrom(primary: Colors.black,),
                  ),
                ],
              ),
              //AQUI EL FEEDBACK

              SingleChildScrollView(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 2),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          onPressed: () => null,
                          child: Text("$total Total",
                              style: const TextStyle(fontSize: 14),
                          )
                      ),
                      const SizedBox(width: 2),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          onPressed: () => null,
                          child: Text(
                              "$_correct Correctas",
                              style: const TextStyle(fontSize: 14)
                          )
                      ),

                      const SizedBox(width: 2),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          onPressed: () => null,
                          child: Text(
                              "$_incorrect Incorrectas",
                              style: const TextStyle(fontSize: 14)
                          )
                      ),

                      const SizedBox(width: 2),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          onPressed: () => null,
                          child: Text(
                              "$_notAttempted Vacias",
                              style: const TextStyle(fontSize: 14)
                          )
                      ),
                    ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5), //apply padding to all four sides
              ),

            questionSnapshot == null ?
                Container(
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ):
                ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: questionSnapshot.docs.length,
                  itemBuilder: (context, index){
                    return QuizPlayTile(
                      questionModel: getQuestionModelFromDatasnapshot(
                          questionSnapshot.docs[index]),
                      index: index,
                    );
                  }
                )
            ],),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder:(context) => Results(
                correct: _correct,
                incorrect: _incorrect,
                total: total,
              ),
          ),
          );
        },
      ),

    );
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;
  QuizPlayTile({required this.questionModel, required this.index});

  @override
  State<QuizPlayTile> createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {

  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text("P${widget.index+1} ${widget.questionModel.question} ", style: const TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),),
        const SizedBox(height: 12,),
        GestureDetector(
          onTap: () async{
            if(!widget.questionModel.answered){
              //Correcta
              if (widget.questionModel.option1 == widget.questionModel.correctOption){
                optionSelected = widget.questionModel.option1;
                widget.questionModel.answered = true;
                _correct = _correct +1;
                _notAttempted = _notAttempted -1;
                print("${widget.questionModel.correctOption}");

                setState((){

                });
              }else{
                optionSelected = widget.questionModel.option1;
                widget.questionModel.answered = true;
                _incorrect = _incorrect + 1;
                _notAttempted = _notAttempted -1;
                setState((){

                });
              }
            }
          },
          child: OptionTitle(
            correctAnswer: widget.questionModel.correctOption,
            description: widget.questionModel.option1,
            option: "A",
            optionSelected: optionSelected,
              ),
        ),
       const SizedBox(height: 4,
        ),

        GestureDetector(
          onTap: (){
            if(!widget.questionModel.answered){
              //Correcta
              if (widget.questionModel.option2 == widget.questionModel.correctOption){
                optionSelected = widget.questionModel.option2;
                widget.questionModel.answered = true;
                _correct = _correct +1;
                _notAttempted = _notAttempted -1;
                print("${widget.questionModel.correctOption}");
                setState((){

                });
              }else{
                optionSelected = widget.questionModel.option2;
                widget.questionModel.answered = true;
                _incorrect = _incorrect + 1;
                _notAttempted = _notAttempted -1;
                setState((){

                });
              }
            }
          },
          child: OptionTitle(
            correctAnswer: widget.questionModel.correctOption,
            description: widget.questionModel.option2,
            option: "B",
            optionSelected: optionSelected,
          ),
        ),
        const SizedBox(height: 4,
        ),

        GestureDetector(
          onTap: (){
            if(!widget.questionModel.answered){
              //Correcta
              if (widget.questionModel.option3 == widget.questionModel.correctOption){
                optionSelected = widget.questionModel.option3;
                widget.questionModel.answered = true;
                _correct = _correct +1;
                _notAttempted = _notAttempted -1;
                print("${widget.questionModel.correctOption}");
                setState((){

                });
              }else{
                optionSelected = widget.questionModel.option3;
                widget.questionModel.answered = true;
                _incorrect = _incorrect + 1;
                _notAttempted = _notAttempted -1;
                setState((){

                });
              }
            }
          },
          child: OptionTitle(
            correctAnswer: widget.questionModel.correctOption,
            description: widget.questionModel.option3,
            option: "C",
            optionSelected: optionSelected,
          ),
        ),
          const SizedBox(height: 4,
        ),

        GestureDetector(
          onTap: (){
            if(!widget.questionModel.answered){
              //Correcta
              if (widget.questionModel.option4 == widget.questionModel.correctOption){
                optionSelected = widget.questionModel.option4;
                widget.questionModel.answered = true;
                _correct = _correct +1;
                _notAttempted = _notAttempted -1;
                print("${widget.questionModel.correctOption}");
                setState((){

                });
              }else{
                optionSelected = widget.questionModel.option4;
                widget.questionModel.answered = true;
                _incorrect = _incorrect + 1;
                _notAttempted = _notAttempted -1;
                setState((){

                });
              }
            }
          },
          child: OptionTitle(
            correctAnswer: widget.questionModel.correctOption,
            description: widget.questionModel.option4,
            option: "D",
            optionSelected: optionSelected,
          ),
        ),
          const SizedBox(height: 20,)

      ],),
    );
  }
}


