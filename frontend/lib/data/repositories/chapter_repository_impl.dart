import 'package:frontend/domain/entities/chapter.dart';
import 'package:frontend/domain/repositories/chapter_repository.dart';
import '../datasources/novel_remote_data_source.dart';
import '../datasources/novel_local_data_source.dart';

class ChapterRepositoryImpl implements ChapterRepository {
  final NovelRemoteDataSource remoteDataSource;
  final NovelLocalDataSource localDataSource;

  ChapterRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Chapter>> getChapters(String novelId) async {
    return await remoteDataSource.getChaptersByNovelId(novelId);
  }

  @override
  Future<Chapter> getChapterById(String novelId, String chapterId) async {
    return await remoteDataSource.getChapterById(novelId, chapterId);
  }

  @override
  Future<Chapter> createChapter(String novelId, Chapter chapter) async {
    // Implementation would depend on backend API
    throw UnimplementedError('createChapter not implemented yet');
  }

  @override
  Future<Chapter> updateChapter(String novelId, String chapterId, Chapter chapter) async {
    // Implementation would depend on backend API
    throw UnimplementedError('updateChapter not implemented yet');
  }

  @override
  Future<void> deleteChapter(String novelId, String chapterId) async {
    // Implementation would depend on backend API
    throw UnimplementedError('deleteChapter not implemented yet');
  }

  @override
  Future<void> updateReadingProgress(String novelId, String chapterId) async {
    await remoteDataSource.updateReadingProgress(novelId, chapterId);
  }

  @override
  Future<String?> getLastReadChapter(String novelId) async {
    return await remoteDataSource.getLastReadChapter(novelId);
  }
} 