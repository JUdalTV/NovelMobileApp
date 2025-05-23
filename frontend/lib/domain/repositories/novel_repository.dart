import '../entities/novel.dart';
import '../entities/chapter.dart';

abstract class NovelRepository {
  Future<List<Novel>> getAllNovels();
  Future<List<Novel>> searchNovels(String query);
  Future<Novel> getNovelById(String id);
  Future<Novel> getNovelBySlug(String slug);
  Future<Novel> createNovel(Novel novel);
  Future<Novel> updateNovel(String id, Novel novel);
  Future<void> deleteNovel(String id);
  Future<String> uploadCoverImage(String id, String imagePath);

  Future<List<Novel>> getNovels({
    int page = 1,
    int limit = 10,
    String? category,
    String? searchQuery,
  });

  Future<List<Chapter>> getChapters(String novelId);

  Future<Chapter> getChapterById(String novelId, String chapterId);

  Future<void> bookmarkNovel(String novelId);

  Future<void> unbookmarkNovel(String novelId);

  Future<List<Novel>> getBookmarkedNovels();

  Future<void> updateReadingProgress(String novelId, String chapterId);

  Future<String?> getLastReadChapter(String novelId);

  Future<List<Novel>> getRecentlyReadNovels();

  Future<List<Chapter>> getChaptersByNovelId(String novelId);

  Future<Chapter> getChapterByNovelAndNumber(String novelId, int chapterNumber);
}

class NovelListResponse {
  final List<Novel> items;
  final int total;

  NovelListResponse({
    required this.items,
    required this.total,
  });
} 