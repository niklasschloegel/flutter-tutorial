import 'package:flutter/material.dart';
import 'quiz_data.dart';
import 'result.dart';

import 'quiz.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;
  var _score = 0;

  final _quizData = [
    QuizData("What's your favorite color?",
        [AnswerData("Red", 7), AnswerData("Green", 3), AnswerData("Blue", 1)]),
    QuizData("What's your favorite animal?", [
      AnswerData("Cat", 1),
      AnswerData("Dog", 2),
      AnswerData("Bird", 20),
      AnswerData("Elephant", 33)
    ]),
    QuizData("Who won the European Championship of Football in 2021?", [
      AnswerData("England", 5),
      AnswerData("Italy", 1),
      AnswerData("Denmark", 8),
      AnswerData("Paraguay", 40),
      AnswerData("Germany", 3)
    ])
  ];

  void _answerQuestion(int score) {
    _score += score;
    setState(() => _questionIndex++);
  }

  void _reset() {
    setState(() {
      _score = 0;
      _questionIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Quiz App"),
        ),
        body: _questionIndex < _quizData.length
            ? Quiz(_quizData, _answerQuestion, _questionIndex)
            : Result(_score, _reset),
      ),
    );
  }
}
