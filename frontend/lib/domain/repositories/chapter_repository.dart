import '../entities/chapter.dart';

abstract class ChapterRepository {
  Future<List<Chapter>> getChapters(String novelId);
  Future<Chapter> getChapterById(String novelId, String chapterId);
  Future<Chapter> createChapter(String novelId, Chapter chapter);
  Future<Chapter> updateChapter(String novelId, String chapterId, Chapter chapter);
  Future<void> deleteChapter(String novelId, String chapterId);
  Future<void> updateReadingProgress(String novelId, String chapterId);
  Future<String?> getLastReadChapter(String novelId);
} 