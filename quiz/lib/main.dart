import 'package:flutter/material.dart';
import 'package:quiz/answer.dart';
import 'package:quiz/quiz_data.dart';

import 'question.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;

  var _quizData = [
    QuizData("What's your favorite color?", ["Red", "Green", "Blue"]),
    QuizData(
        "What's your favorite animal?", ["Cat", "Dog", "Bird", "Elephant"]),
    QuizData("Who won the European Championship of Football in 2021?",
        ["England", "Germany", "Italy", "Denmark", "Spain"])
  ];

  void _answerQuestion() {
    setState(() {
      if (_questionIndex + 1 == _quizData.length) {
        _questionIndex = 0;
      } else {
        _questionIndex++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Quiz App"),
        ),
        body: Column(
          children: [
            Question(_quizData[_questionIndex].question),
            ..._quizData[_questionIndex]
                .answers
                .map((answer) => Answer(_answerQuestion, answer))
                .toList()
          ],
        ),
      ),
    );
  }
}
