import 'package:firebase_database/firebase_database.dart';
import 'package:jump_adventure/models/score_model.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final String _scoresPath = 'scores';

  Future<void> saveScore(ScoreModel score) async {
    try {
      await _database.child(_scoresPath).push().set(score.toJson());
    } catch (e) {
      print('Error saving score to Firebase: $e');
      rethrow;
    }
  }

  Future<int> getHighScore() async {
    try {
      final snapshot = await _database
          .child(_scoresPath)
          .orderByChild('score')
          .limitToLast(1)
          .get();

      if (snapshot.exists) {
        final data = snapshot.value as Map;
        final score = data.values.first['score'] as int;
        return score;
      }
      return 0;
    } catch (e) {
      print('Error getting high score from Firebase: $e');
      return 0;
    }
  }
} 