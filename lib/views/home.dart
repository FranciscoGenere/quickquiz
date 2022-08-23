import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:quickquiz/prueba.dart';
import 'package:quickquiz/services/database.dart';
import 'package:quickquiz/views/create_quiz.dart';
import 'package:quickquiz/views/play_quiz.dart';
import 'package:quickquiz/views/signin.dart';
import 'package:quickquiz/views/signup.dart';
import 'package:quickquiz/widgets/widgets.dart';


class Home extends StatefulWidget {
  CollectionReference recipes = FirebaseFirestore.instance.collection('Recipes');

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Stream quizStream;
  DatabaseService databaseService = DatabaseService();

  Widget quizList(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder<dynamic>(
        stream: quizStream,
        builder: (context, snapshot){
          return snapshot.data == null
              ? Container(
            child: const CircularProgressIndicator(),
          ):
              ListView.builder(
                  itemCount: snapshot.data.docs.length, //PROBLEMAS SUPUESTAMENTE CORREGIDOS POr AQUI
                  itemBuilder: (context, index){
                return QuizTitle(
                  imgUrl: snapshot.data.docs[index].data()["quizImgUrl"],
                  desc: snapshot.data.docs[index].data()["quizDesc"],
                  title: snapshot.data.docs[index].data()["quizTitle"],
                  quizid: snapshot.data.docs[index].data()["quizId"],
                );
              });
        },
      ),
    );
  }

  @override
  void initState() {
    databaseService.getQuizezData().then((val){
      setState((){
        quizStream = val;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: appBar(context),
        leading: IconButton(
          onPressed: () {
         showSearch(
             context: context,
             delegate: MySearchDelegate(),);
          },
          icon: const Icon(Icons.search), color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,

        actions: [
          IconButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=> const SignIn()
            ));
          },

              icon: const Icon(Icons.logout),color: Colors.black), const SizedBox(width: 10.0),

        ],
      ),
      body: quizList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => const CreateQuiz()
          ));
        },
      ),
    );
  }
}

// Widget getAppBarNotSearching(String title, String imgUrl, String desc, String quizid, Function startSearchFunction) {
//   return AppBar(
//     title: Text(title),
//     actions: <Widget>[
//       IconButton(
//           icon: const Icon(Icons.search),
//           onPressed: () {
//             startSearchFunction();
//           }),
//     ],
//   );
// }


class QuizTitle extends StatelessWidget {
 final String imgUrl;
 final String title;
 final String desc;
 final String quizid;
  QuizTitle({required this.imgUrl, required this.title, required this.desc, required this.quizid});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder:(context) =>  PlayQuiz(quizid)
        ));
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/lobby3.gif"), //CUANDO LA IMAGEN DEL QUIZ AUN NO CARGA
            fit: BoxFit.fill,
          ),
        ),

        margin: const EdgeInsets.only(bottom: 8),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular
                (8),
              child: Image.network(imgUrl, width: MediaQuery.of
                (context).size.width - 48, fit: BoxFit.cover,),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular
                  (8),color: Colors.black26,

              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .center,
                children: [
                  Text(title, style: const TextStyle
                    (color: Colors.white, fontSize: 17, fontWeight:
                  FontWeight.w500),),
                  const SizedBox(height: 6,),
                  Text(desc, style: const TextStyle
                    (color: Colors.white, fontSize: 14, fontWeight:
                  FontWeight.w400),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  static const routeName = '/extractArguments';
  List<String> searchResults = [
    'Videojuegos',
    'Tecnología',
    'Música',
    'Ciencia',
  ];

  @override
  Widget? buildLeading(BuildContext context) =>
      IconButton(
          onPressed: () => close(context, null),
          icon: const Icon(Icons.arrow_back));

  @override
  List<Widget>? buildActions(BuildContext context) =>
      [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            }, icon: const Icon(Icons.clear))
      ];

  @override
  Widget buildResults(BuildContext context) => Container(
    margin: const EdgeInsets.only(left: 27.0, right: 27.0),
    child: StreamBuilder<dynamic>(
        builder: (context, snapshot){
          // final args = ModalRoute.of(context)!.settings.arguments as QuizTitle;
          return snapshot.data == null
              ? Container(
              //child: QuizTitle(title: 'Videojuegos', desc: 'Preguntas sobre distintos videojuegos', imgUrl: 'https://images.unsplash.com/photo-1585620385456-4759f9b5c7d9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80', quizid: '51415U5E80OB4Eg1')
          ):
          ListView.builder(
              itemCount: snapshot.data.docs.length, //PROBLEMAS SUPUESTAMENTE CORREGIDOS POr AQUI
              itemBuilder: (context, index){
                return QuizTitle(
                  imgUrl: snapshot.data.docs[index].data()["quizImgUrl"],
                  desc: snapshot.data.docs[index].data()["quizDesc"],
                  title: snapshot.data.docs[index].data()["quizTitle"],
                  quizid: snapshot.data.docs[index].data()["quizId"],
                );
              });
        },
      ),

  );


  @override
  String get searchFieldLabel => "Buscar quiz";
  @override
  Widget buildSuggestions(BuildContext context) {

    List<String> suggestions = searchResults.where((searchResult) {
    final result  = searchResult.toLowerCase();
    final input = query.toLowerCase();
    return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];

        return ListTile(
          title: Text(suggestion),
          onTap: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              SystemNavigator.pop();
            }
            print(suggestion);
            // print(query);
            if (suggestion=='Videojuegos'){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BVideojuegos()));
            }
            if (suggestion=='Tecnología'){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BTecnologia()));
            }
            if (suggestion=='Música') {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BMusica()));
            }
            if (suggestion=='Ciencia'){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BCiencia()));
            }
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}

class BVideojuegos extends StatelessWidget {
  const BVideojuegos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: appBar(context),
          leading: IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(),);
            },
            icon: const Icon(Icons.search), color: Colors.black,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          brightness: Brightness.light,

          actions: [
            IconButton(onPressed: (){
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context)=>  Home()
              ));
            },

                icon: const Icon(Icons.arrow_back),color: Colors.black), const SizedBox(width: 10.0),

          ],
        ),
        body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: QuizTitle(title: 'Videojuegos', desc: 'Preguntas sobre distintos videojuegos', imgUrl: 'https://images.unsplash.com/photo-1585620385456-4759f9b5c7d9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80', quizid: '51415U5E80OB4Eg1'))
    );
  }
}
class BTecnologia extends StatelessWidget {
  const BTecnologia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: appBar(context),
          leading: IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(),);
            },
            icon: const Icon(Icons.search), color: Colors.black,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          brightness: Brightness.light,

          actions: [
            IconButton(onPressed: (){
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context)=>  Home()
              ));
            },

                icon: const Icon(Icons.arrow_back),color: Colors.black), const SizedBox(width: 10.0),

          ],
        ),
        body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: QuizTitle(title: 'Tecnología', desc: 'Preguntas de tecnologia', imgUrl: 'https://images.unsplash.com/photo-1488590528505-98d2b5aba04b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80', quizid: '5851724784459204'))
    );
  }
}

class BMusica extends StatelessWidget {
  const BMusica({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: appBar(context),
          leading: IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(),);
            },
            icon: const Icon(Icons.search), color: Colors.black,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          brightness: Brightness.light,

          actions: [
            IconButton(onPressed: (){
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context)=> Home()
              ));
            },

                icon: const Icon(Icons.arrow_back),color: Colors.black), const SizedBox(width: 10.0),

          ],
        ),
        body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: QuizTitle(title: 'Música', desc: 'Que tanto sabes de música', imgUrl: 'https://images.unsplash.com/photo-1477233534935-f5e6fe7c1159?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80', quizid: 'Nt1b604jx4gwdf0u'))
    );
  }
}

class BCiencia extends StatelessWidget {
  const BCiencia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: appBar(context),
          leading: IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(),);
            },
            icon: const Icon(Icons.search), color: Colors.black,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          brightness: Brightness.light,

          actions: [
            IconButton(onPressed: (){
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context)=>  Home()
              ));
            },

                icon: const Icon(Icons.arrow_back),color: Colors.black), const SizedBox(width: 10.0),

          ],
        ),
        body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: QuizTitle(title: 'Ciencia', desc: 'Demuestra que tanto sabes de ciencia', imgUrl: 'https://images.unsplash.com/photo-1576086213369-97a306d36557?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80', quizid: 'zdshAggSKwodEWUf'))
    );
  }
}
