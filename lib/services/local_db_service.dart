import 'package:hive/hive.dart';
import 'package:jump_adventure/models/score_model.dart';

class LocalDBService {
  static const String _boxName = 'scores';
  late Box<ScoreModel> _box;

  Future<void> init() async {
    Hive.registerAdapter(ScoreModelAdapter());
    _box = await Hive.openBox<ScoreModel>(_boxName);
  }

  Future<void> saveScore(ScoreModel score) async {
    await _box.add(score);
  }

  Future<int> getHighScore() async {
    if (_box.isEmpty) return 0;

    final scores = _box.values.toList();
    scores.sort((a, b) => b.score.compareTo(a.score));
    return scores.first.score;
  }

  Future<List<ScoreModel>> getAllScores() async {
    return _box.values.toList();
  }
} 