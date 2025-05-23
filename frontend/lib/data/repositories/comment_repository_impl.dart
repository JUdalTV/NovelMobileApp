import '../../domain/entities/comment.dart';
import '../../domain/repositories/comment_repository.dart';
import '../datasources/comment_remote_data_source.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;

  CommentRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<Comment>> getNovelComments(String novelId) async {
    try {
      return await remoteDataSource.getNovelComments(novelId);
    } catch (e) {
      throw Exception('Failed to get novel comments: $e');
    }
  }

  @override
  Future<List<Comment>> getChapterComments(String novelId, String chapterId) async {
    try {
      return await remoteDataSource.getChapterComments(novelId, chapterId);
    } catch (e) {
      throw Exception('Failed to get chapter comments: $e');
    }
  }

  @override
  Future<Comment> createComment(String novelId, String? chapterId, String content) async {
    try {
      return await remoteDataSource.createComment(novelId, chapterId, content);
    } catch (e) {
      throw Exception('Failed to create comment: $e');
    }
  }

  @override
  Future<Comment> updateComment(String novelId, String commentId, String content) async {
    try {
      return await remoteDataSource.updateComment(novelId, commentId, content);
    } catch (e) {
      throw Exception('Failed to update comment: $e');
    }
  }

  @override
  Future<void> deleteComment(String novelId, String commentId) async {
    try {
      await remoteDataSource.deleteComment(novelId, commentId);
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }
} 