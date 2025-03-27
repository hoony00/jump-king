import 'package:hive/hive.dart';

class ScoreModel extends HiveObject {
  final int score;
  final DateTime date;
  final bool isServerMode;

  ScoreModel({
    required this.score,
    required this.date,
    required this.isServerMode,
  });

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      score: json['score'] as int,
      date: DateTime.parse(json['date'] as String),
      isServerMode: json['isServerMode'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'date': date.toIso8601String(),
      'isServerMode': isServerMode,
    };
  }
}

class ScoreModelAdapter extends TypeAdapter<ScoreModel> {
  @override
  final int typeId = 0;

  @override
  ScoreModel read(BinaryReader reader) {
    return ScoreModel(
      score: reader.readInt(),
      date: DateTime.parse(reader.readString()),
      isServerMode: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, ScoreModel obj) {
    writer.writeInt(obj.score);
    writer.writeString(obj.date.toIso8601String());
    writer.writeBool(obj.isServerMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
} 