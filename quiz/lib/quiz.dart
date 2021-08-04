import 'package:flutter/material.dart';
import 'package:quiz/quiz_data.dart';

import 'answer.dart';
import 'question.dart';

class Quiz extends StatelessWidget {
  final List<QuizData> quizData;
  final Function answerQuestion;
  final int questionIndex;

  Quiz(this.quizData, this.answerQuestion, this.questionIndex);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(quizData[questionIndex].question),
        ...quizData[questionIndex]
            .answers
            .map((answer) =>
                Answer(() => answerQuestion(answer.score), answer.answer))
            .toList()
      ],
    );
  }
}
