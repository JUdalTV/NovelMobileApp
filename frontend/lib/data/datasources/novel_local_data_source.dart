import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/novel.dart';
import '../../domain/entities/chapter.dart';
import '../models/novel_model.dart';

abstract class NovelLocalDataSource {
  Future<void> cacheNovels(List<Novel> novels);
  Future<List<Novel>> getCachedNovels();
  Future<void> cacheNovel(Novel novel);
  Future<Novel?> getCachedNovel(String id);
  Future<void> cacheChapters(String novelId, List<Chapter> chapters);
  Future<List<Chapter>> getCachedChapters(String novelId);
  Future<void> cacheChapter(String novelId, Chapter chapter);
  Future<Chapter?> getCachedChapter(String novelId, String chapterId);
  Future<void> cacheBookmarkedNovel(String novelId);
  Future<void> removeBookmarkedNovel(String novelId);
  Future<List<String>> getBookmarkedNovelIds();
  Future<void> cacheLastReadChapter(String novelId, String chapterId);
  Future<String?> getLastReadChapter(String novelId);
  
  // Thêm các phương thức cho lịch sử tìm kiếm
  Future<void> addSearchHistory(String query);
  Future<List<String>> getSearchHistory();
  Future<void> clearSearchHistory();
  
  // Thêm các phương thức cho truyện đã đọc gần đây
  Future<void> addRecentNovel(String novelId);
  Future<List<String>> getRecentNovelIds();
  Future<void> clearRecentNovels();
}

class NovelLocalDataSourceImpl implements NovelLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String CACHED_NOVELS = 'CACHED_NOVELS';
  static const String CACHED_NOVEL_PREFIX = 'CACHED_NOVEL_';
  static const String CACHED_CHAPTERS_PREFIX = 'CACHED_CHAPTERS_';
  static const String CACHED_CHAPTER_PREFIX = 'CACHED_CHAPTER_';
  static const String BOOKMARKED_NOVELS = 'BOOKMARKED_NOVELS';
  static const String LAST_READ_CHAPTER_PREFIX = 'LAST_READ_CHAPTER_';
  static const String SEARCH_HISTORY = 'SEARCH_HISTORY';
  static const String RECENT_NOVELS = 'RECENT_NOVELS';
  static const int MAX_SEARCH_HISTORY = 10; // Giới hạn số lượng lịch sử tìm kiếm
  static const int MAX_RECENT_NOVELS = 20; // Giới hạn số lượng truyện đã đọc gần đây

  NovelLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheNovels(List<Novel> novels) async {
    final List<Map<String, dynamic>> jsonList = novels
        .map((novel) => (novel as NovelModel).toJson())
        .toList();
    await sharedPreferences.setString(
      CACHED_NOVELS,
      json.encode(jsonList),
    );
  }

  @override
  Future<List<Novel>> getCachedNovels() async {
    final jsonString = sharedPreferences.getString(CACHED_NOVELS);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => NovelModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> cacheNovel(Novel novel) async {
    await sharedPreferences.setString(
      CACHED_NOVEL_PREFIX + novel.id!,
      json.encode((novel as NovelModel).toJson()),
    );
  }

  @override
  Future<Novel?> getCachedNovel(String id) async {
    final jsonString = sharedPreferences.getString(CACHED_NOVEL_PREFIX + id);
    if (jsonString != null) {
      return NovelModel.fromJson(json.decode(jsonString));
    } else {
      return null;
    }
  }

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
  Future<void> cacheBookmarkedNovel(String novelId) async {
    final bookmarkedNovels = await getBookmarkedNovelIds();
    if (!bookmarkedNovels.contains(novelId)) {
      bookmarkedNovels.add(novelId);
      await sharedPreferences.setStringList(
        BOOKMARKED_NOVELS,
        bookmarkedNovels,
      );
    }
  }

  @override
  Future<void> removeBookmarkedNovel(String novelId) async {
    final bookmarkedNovels = await getBookmarkedNovelIds();
    bookmarkedNovels.remove(novelId);
    await sharedPreferences.setStringList(
      BOOKMARKED_NOVELS,
      bookmarkedNovels,
    );
  }

  @override
  Future<List<String>> getBookmarkedNovelIds() async {
    return sharedPreferences.getStringList(BOOKMARKED_NOVELS) ?? [];
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
  
  // Phương thức thêm một từ khóa vào lịch sử tìm kiếm
  @override
  Future<void> addSearchHistory(String query) async {
    if (query.isEmpty) return;
    
    final searchHistory = await getSearchHistory();
    
    // Xóa query trùng lặp (nếu có)
    searchHistory.remove(query);
    
    // Thêm query mới vào đầu danh sách
    searchHistory.insert(0, query);
    
    // Giữ danh sách trong giới hạn
    if (searchHistory.length > MAX_SEARCH_HISTORY) {
      searchHistory.removeLast();
    }
    
    // Lưu lịch sử
    await sharedPreferences.setStringList(SEARCH_HISTORY, searchHistory);
  }
  
  // Phương thức lấy danh sách lịch sử tìm kiếm
  @override
  Future<List<String>> getSearchHistory() async {
    return sharedPreferences.getStringList(SEARCH_HISTORY) ?? [];
  }
  
  // Phương thức xóa lịch sử tìm kiếm
  @override
  Future<void> clearSearchHistory() async {
    await sharedPreferences.remove(SEARCH_HISTORY);
  }

  // Phương thức thêm một truyện vào danh sách đã đọc gần đây
  @override
  Future<void> addRecentNovel(String novelId) async {
    if (novelId.isEmpty) return;
    
    final recentNovels = await getRecentNovelIds();
    
    // Xóa novelId trùng lặp (nếu có) để đưa lên đầu danh sách
    recentNovels.remove(novelId);
    
    // Thêm novelId mới vào đầu danh sách
    recentNovels.insert(0, novelId);
    
    // Giữ danh sách trong giới hạn
    if (recentNovels.length > MAX_RECENT_NOVELS) {
      recentNovels.removeLast();
    }
    
    // Lưu danh sách
    await sharedPreferences.setStringList(RECENT_NOVELS, recentNovels);
  }
  
  // Phương thức lấy danh sách ID truyện đã đọc gần đây
  @override
  Future<List<String>> getRecentNovelIds() async {
    return sharedPreferences.getStringList(RECENT_NOVELS) ?? [];
  }
  
  // Phương thức xóa danh sách truyện đã đọc gần đây
  @override
  Future<void> clearRecentNovels() async {
    await sharedPreferences.remove(RECENT_NOVELS);
  }
} 