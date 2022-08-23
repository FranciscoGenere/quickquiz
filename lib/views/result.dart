import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickquiz/widgets/widgets.dart';


class Results extends StatefulWidget {
 final int correct, incorrect, total;
 Results({required this.correct, required this.incorrect, required this.total});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/lobby6.gif"),
              fit: BoxFit.cover,
            ),
          ),
        padding: EdgeInsets.symmetric(horizontal: 24),
        height: MediaQuery.of(context).size.height,
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(widget.correct == (widget.total))...[
              Text("${widget.correct}/${widget.total}", style: const TextStyle(fontSize: 35, color: Colors.white),),
              const SizedBox(height: 8,),
              const Text("ACERTASTE TODAS, INCREIBLE!", style: TextStyle(fontSize: 20, color: Colors
                  .green, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,),
              Text("Respondiste ${widget.correct} preguntas correctamente"
                  " y ${widget.incorrect} incorrectamente", style: const TextStyle(fontSize: 20, color: Colors
                  .grey),
                textAlign: TextAlign.center,),
              const SizedBox(height: 14,),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: blueButton(context: context, label: "Ir al inicio", buttonWidth: MediaQuery.of(context).size.width/2),)
            ],
            if((widget.correct > (widget.total/2)) && widget.correct != widget.total)...[
              Text("${widget.correct}/${widget.total}", style: const TextStyle(fontSize: 35, color: Colors.white),),
              const SizedBox(height: 8,),
              const Text("FELICIDADES ACERTASTE MAS DE LA MITAD!", style: TextStyle(fontSize: 20, color: Colors
                  .blue, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,),
              Text("Respondiste ${widget.correct} preguntas correctamente"
                  " y ${widget.incorrect} incorrectamente", style: const TextStyle(fontSize: 20, color: Colors
                  .grey),
                textAlign: TextAlign.center,),
              const SizedBox(height: 14,),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: blueButton(context: context, label: "Ir al inicio", buttonWidth: MediaQuery.of(context).size.width/2),)
            ],
            if(widget.correct == (widget.total/2))...[
              Text("${widget.correct}/${widget.total}", style: const TextStyle(fontSize: 35, color: Colors.white),),
              const SizedBox(height: 8,),
              const Text("ACERTASTE LA MITAD, PERO PUEDES MEJORAR!", style: TextStyle(fontSize: 20, color: Colors
                  .orange, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,),
              Text("Respondiste ${widget.correct} preguntas correctamente"
                  " y ${widget.incorrect} incorrectamente", style: const TextStyle(fontSize: 20, color: Colors
                  .grey),
                textAlign: TextAlign.center,),
              const SizedBox(height: 14,),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: blueButton(context: context, label: "Ir al inicio", buttonWidth: MediaQuery.of(context).size.width/2),)
            ],
            if((widget.correct < (widget.total/2)) && widget.correct != widget.total)...[
              Text("${widget.correct}/${widget.total}", style: const TextStyle(fontSize: 35, color: Colors.white),),
              const SizedBox(height: 8,),
              const Text("ACERTASTE MENOS DE LA MITAD!", style: TextStyle(fontSize: 20, color: Colors
                  .red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,),
              Text("Respondiste ${widget.correct} preguntas correctamente"
                  " y ${widget.incorrect} incorrectamente", style: const TextStyle(fontSize: 20, color: Colors
                  .grey),
                textAlign: TextAlign.center,),
              const SizedBox(height: 14,),
              GestureDetector(
                onTap: (){
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    SystemNavigator.pop();
                  }
                },
                child: blueButton(context: context, label: "Ir al inicio", buttonWidth: MediaQuery.of(context).size.width/2),
              ),

            ]
            ],),)
      ),
    );
  }
}
