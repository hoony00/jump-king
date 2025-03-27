import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_storage.dart';

final highScoreProvider = FutureProvider<int>((ref) async {
  final highScore = await LocalStorage.instance.readInt(key: 'highScore') ?? 0;
  return highScore;
});