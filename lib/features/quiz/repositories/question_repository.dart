import '../../../data/questions/questions_data.dart';
import '../models/question.dart';

class QuestionRepository {
  QuestionRepository({List<Question>? questions})
    : _questions = List.unmodifiable(questions ?? loadQuestions());

  final List<Question> _questions;

  List<Question> getAll() => _questions;

  Question? getById(String id) {
    for (final q in _questions) {
      if (q.id == id) return q;
    }
    return null;
  }

  int get length => _questions.length;
}
