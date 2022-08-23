import 'package:flutter/material.dart';

class OptionTitle extends StatefulWidget {
  final String option, description, correctAnswer, optionSelected;
  OptionTitle({required this.optionSelected, required this.correctAnswer, required this.description, required this.option});

  @override
  State<OptionTitle> createState() => _OptionTitleState();
}

class _OptionTitleState extends State<OptionTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              border: Border.all(
                  color: widget.description == widget.optionSelected
                  ? widget.optionSelected == widget.correctAnswer
                      ? Colors.green.withOpacity(0.7)
                      : Colors.red.withOpacity(0.7)
                      : Colors.grey, width: 1.4),
              borderRadius: BorderRadius.circular(30)
            ),
            alignment: Alignment.center,
            child: Text("${widget.option}", style: TextStyle(
              color: widget.optionSelected == widget.description?
              widget.correctAnswer == widget.optionSelected ? Colors.green.withOpacity(0.7):
              Colors.red
              : Colors.grey
            ),),
          ),
          const SizedBox(width: 8,),
          Text(widget.description, style: const TextStyle(
            fontSize: 16, color: Colors.black87
          ),)
        ],
      ),
    );
  }
}
