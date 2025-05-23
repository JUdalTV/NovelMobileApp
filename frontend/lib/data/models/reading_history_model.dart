import '../../domain/entities/reading_history.dart';
import 'novel_model.dart';

class ReadingHistoryModel {
  final NovelModel novel;
  final int minutesRead;
  final DateTime lastRead;

  ReadingHistoryModel({
    required this.novel,
    required this.minutesRead,
    required this.lastRead,
  });

  factory ReadingHistoryModel.fromJson(Map<String, dynamic> json) {
    return ReadingHistoryModel(
      novel: NovelModel.fromJson(json['novel']),
      minutesRead: json['minutesRead'] ?? 0,
      lastRead: DateTime.parse(json['lastRead']),
    );
  }

  ReadingHistory toEntity() => ReadingHistory(
    novel: novel.toEntity(),
    minutesRead: minutesRead,
    lastRead: lastRead,
  );
} 