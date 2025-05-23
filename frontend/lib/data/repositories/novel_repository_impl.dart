import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/novel.dart';
import '../../domain/entities/chapter.dart';
import '../../domain/repositories/novel_repository.dart';
import '../datasources/novel_remote_data_source.dart';
import '../datasources/novel_local_data_source.dart';

class NovelRepositoryImpl implements NovelRepository {
  final NovelRemoteDataSource remoteDataSource;
  final NovelLocalDataSource localDataSource;

  NovelRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Novel>> getAllNovels() async {
    return await remoteDataSource.getAllNovels();
  }

  @override
  Future<List<Novel>> searchNovels(String query) async {
    return await remoteDataSource.searchNovels(query);
  }

  @override
  Future<Novel> getNovelById(String id) async {
    try {
      // Try to get novel from remote source first
      final novel = await remoteDataSource.getNovelById(id);
      
      // If successful, cache the novel locally for future offline use
      await localDataSource.cacheNovel(novel);
      
      return novel;
    } catch (e) {
      print('Remote getNovelById failed: $e. Trying local data fallback.');
      
      // Attempt to retrieve from local cache if remote fails
      final cachedNovel = await localDataSource.getCachedNovel(id);
      if (cachedNovel != null) {
        print('Found novel $id in local cache');
        return cachedNovel;
      }
      
      // If neither remote nor local cache works, throw an error
      print('Novel $id not found in local cache');
      throw Exception('Failed to load novel: $e');
    }
  }

  @override
  Future<Novel> getNovelBySlug(String slug) async {
    return await remoteDataSource.getNovelBySlug(slug);
  }

  @override
  Future<Novel> createNovel(Novel novel) async {
    return await remoteDataSource.createNovel(novel);
  }

  @override
  Future<Novel> updateNovel(String id, Novel novel) async {
    return await remoteDataSource.updateNovel(id, novel);
  }

  @override
  Future<void> deleteNovel(String id) async {
      await remoteDataSource.deleteNovel(id);
  }

  @override
  Future<String> uploadCoverImage(String id, String imagePath) async {
    return await remoteDataSource.uploadCoverImage(id, imagePath);
  }

  @override
  Future<List<Novel>> getNovels({
    int page = 1, 
    int limit = 10,
    String? category,
    String? searchQuery,
  }) async {
    try {
      final novels = await remoteDataSource.getNovels(
        page: page,
        limit: limit,
        category: category,
        searchQuery: searchQuery,
      );
      
      // Cache novels for offline access after successful fetch
      if (novels.isNotEmpty) {
        await localDataSource.cacheNovels(novels);
      }
      
      return novels;
    } catch (e) {
      print('Remote getNovels failed: $e. Trying local data fallback.');
      
      // Fallback to local cached data
      try {
        final cachedNovels = await localDataSource.getCachedNovels();
        if (cachedNovels.isEmpty) {
          throw Exception('No cached novels available');
        }
        
        // Apply filters if needed
        var filteredNovels = cachedNovels;
        
        // Filter by category if specified
        if (category != null && category.isNotEmpty) {
          filteredNovels = filteredNovels.where((novel) => 
            novel.categories?.contains(category) ?? false).toList();
        }
        
        // Filter by search query if specified
        if (searchQuery != null && searchQuery.isNotEmpty) {
          final query = searchQuery.toLowerCase();
          filteredNovels = filteredNovels.where((novel) {
            final title = novel.title?.toLowerCase() ?? '';
            final author = novel.author?.toLowerCase() ?? '';
            final description = novel.description?.toLowerCase() ?? '';
            return title.contains(query) || 
                  author.contains(query) ||
                  description.contains(query);
          }).toList();
        }
        
        // Apply pagination (simple implementation)
        final startIndex = (page - 1) * limit;
        final endIndex = startIndex + limit;
        
        if (startIndex >= filteredNovels.length) {
          return [];
        }
        
        final paginatedNovels = filteredNovels.sublist(
          startIndex, 
          endIndex > filteredNovels.length ? filteredNovels.length : endIndex
        );
        
        print('Loaded ${paginatedNovels.length} novels from local cache');
        return paginatedNovels;
      } catch (localError) {
        print('Local data fallback also failed: $localError');
        throw Exception('Failed to load novels: $e');
      }
    }
  }

  @override
  Future<List<Chapter>> getChapters(String novelId) async {
    return await remoteDataSource.getChapters(novelId);
  }

  @override
  Future<Chapter> getChapterById(String novelId, String chapterId) async {
    return await remoteDataSource.getChapterById(novelId, chapterId);
  }

  @override
  Future<void> bookmarkNovel(String novelId) async {
    try {
      // Lưu bookmarked novel vào local storage thay vì gọi API
      await localDataSource.cacheBookmarkedNovel(novelId);
      
      // Sau khi đã lưu cục bộ thành công, thử cập nhật trên server (không bắt buộc)
      try {
        await remoteDataSource.bookmarkNovel(novelId);
      } catch (e) {
        print('Không thể đồng bộ bookmark lên server: $e');
        // Lỗi khi gọi API không gây ảnh hưởng đến việc lưu cục bộ
      }
    } catch (e) {
      throw Exception('Failed to bookmark novel: $e');
    }
  }

  @override
  Future<void> unbookmarkNovel(String novelId) async {
    try {
      // Xóa bookmarked novel khỏi local storage thay vì gọi API
      await localDataSource.removeBookmarkedNovel(novelId);
      
      // Sau khi đã xóa cục bộ thành công, thử cập nhật trên server (không bắt buộc)
      try {
        await remoteDataSource.unbookmarkNovel(novelId);
      } catch (e) {
        print('Không thể đồng bộ unbookmark lên server: $e');
        // Lỗi khi gọi API không gây ảnh hưởng đến việc xóa cục bộ
      }
    } catch (e) {
      throw Exception('Failed to unbookmark novel: $e');
    }
  }

  @override
  Future<List<Novel>> getBookmarkedNovels() async {
    try {
      // Lấy danh sách ID truyện đã đánh dấu từ local storage
      final bookmarkedIds = await localDataSource.getBookmarkedNovelIds();
      
      if (bookmarkedIds.isEmpty) {
        return [];
      }
      
      // Lấy thông tin chi tiết từng novel theo ID
      List<Novel> bookmarkedNovels = [];
      for (String id in bookmarkedIds) {
        try {
          // Thử lấy novel từ cache trước
          final cachedNovel = await localDataSource.getCachedNovel(id);
          
          if (cachedNovel != null) {
            bookmarkedNovels.add(cachedNovel);
          } else {
            // Nếu không có trong cache, thử lấy từ server
            try {
              final novel = await remoteDataSource.getNovelById(id);
              bookmarkedNovels.add(novel);
              
              // Cache lại novel để dùng cho lần sau
              await localDataSource.cacheNovel(novel);
            } catch (e) {
              print('Không thể lấy thông tin novel từ server: $e');
            }
          }
        } catch (e) {
          print('Lỗi khi xử lý novel có ID $id: $e');
        }
      }
      
      return bookmarkedNovels;
    } catch (e) {
      throw Exception('Failed to get bookmarked novels: $e');
    }
  }

  @override
  Future<void> updateReadingProgress(String novelId, String chapterId) async {
      await remoteDataSource.updateReadingProgress(novelId, chapterId);
  }

  @override
  Future<String?> getLastReadChapter(String novelId) async {
      return await remoteDataSource.getLastReadChapter(novelId);
  }

  @override
  Future<List<Novel>> getRecentlyReadNovels() async {
    try {
      final novelIds = await localDataSource.getRecentNovelIds();
      
      if (novelIds.isEmpty) {
        print('No recently read novel IDs found in local storage');
        return [];
      }
      
      // Lấy thông tin chi tiết của từng tiểu thuyết
      List<Novel> recentlyReadNovels = [];
      List<String> failedIds = [];
      
      for (String id in novelIds) {
        try {
          // Try loading from cache first
          Novel? novel = await localDataSource.getCachedNovel(id);
          
          if (novel == null) {
            // If not in cache, try from remote
            try {
              novel = await remoteDataSource.getNovelById(id);
              // Cache it for next time
              await localDataSource.cacheNovel(novel);
            } catch (remoteError) {
              print('Remote fetch failed for novel ID: $id - Error: $remoteError');
              failedIds.add(id);
              continue; // Skip to next novel
            }
          }
          
          recentlyReadNovels.add(novel);
        } catch (e) {
          print('Không thể lấy thông tin tiểu thuyết có ID: $id - Lỗi: $e');
          failedIds.add(id);
        }
      }
      
      // Nếu quá nhiều tiểu thuyết không thể tải được, có thể là vấn đề về kết nối
      if (failedIds.isNotEmpty) {
        print('Một số tiểu thuyết (${failedIds.length}/${novelIds.length}) không thể tải. Sẽ thử lại sau.');
        // We could add code here to schedule a retry later
      }
      
      return recentlyReadNovels;
    } catch (e) {
      print('Lỗi khi lấy danh sách tiểu thuyết đã đọc: $e');
      return [];
    }
  }

  @override
  Future<List<Chapter>> getChaptersByNovelId(String novelId) async {
    return await remoteDataSource.getChaptersByNovelId(novelId);
    }

  @override
  Future<Chapter> getChapterByNovelAndNumber(String novelId, int chapterNumber) async {
    return await remoteDataSource.getChapterByNovelAndNumber(novelId, chapterNumber);
  }
} 