class AnswerData {
  final String answer;
  final int score;

  AnswerData(this.answer, this.score);
}

class QuizData {
  final String question;
  final List<AnswerData> answers;

  QuizData(this.question, this.answers);
}
