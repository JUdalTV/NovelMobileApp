import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/chapter.dart';

abstract class ChapterLocalDataSource {
  Future<void> cacheChapters(String novelId, List<Chapter> chapters);
  Future<List<Chapter>> getCachedChapters(String novelId);
  Future<void> cacheChapter(String novelId, Chapter chapter);
  Future<Chapter?> getCachedChapter(String novelId, String chapterId);
  Future<void> cacheLastReadChapter(String novelId, String chapterId);
  Future<String?> getLastReadChapter(String novelId);
}

class ChapterLocalDataSourceImpl implements ChapterLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String CACHED_CHAPTERS_PREFIX = 'CACHED_CHAPTERS_';
  static const String CACHED_CHAPTER_PREFIX = 'CACHED_CHAPTER_';
  static const String LAST_READ_CHAPTER_PREFIX = 'LAST_READ_CHAPTER_';

  ChapterLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheChapters(String novelId, List<Chapter> chapters) async {
    final List<Map<String, dynamic>> jsonList = chapters
        .map((chapter) => chapter.toJson())
        .toList();
    await sharedPreferences.setString(
      CACHED_CHAPTERS_PREFIX + novelId,
      json.encode(jsonList),
    );
  }

  @override
  Future<List<Chapter>> getCachedChapters(String novelId) async {
    final jsonString = sharedPreferences.getString(CACHED_CHAPTERS_PREFIX + novelId);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Chapter.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> cacheChapter(String novelId, Chapter chapter) async {
    await sharedPreferences.setString(
      CACHED_CHAPTER_PREFIX + novelId + '_' + chapter.id!,
      json.encode(chapter.toJson()),
    );
  }

  @override
  Future<Chapter?> getCachedChapter(String novelId, String chapterId) async {
    final jsonString = sharedPreferences.getString(
      CACHED_CHAPTER_PREFIX + novelId + '_' + chapterId,
    );
    if (jsonString != null) {
      return Chapter.fromJson(json.decode(jsonString));
    } else {
      return null;
    }
  }

  @override
  Future<void> cacheLastReadChapter(String novelId, String chapterId) async {
    await sharedPreferences.setString(
      LAST_READ_CHAPTER_PREFIX + novelId,
      chapterId,
    );
  }

  @override
  Future<String?> getLastReadChapter(String novelId) async {
    return sharedPreferences.getString(LAST_READ_CHAPTER_PREFIX + novelId);
  }
} 