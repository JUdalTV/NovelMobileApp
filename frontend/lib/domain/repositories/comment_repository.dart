import '../entities/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> getNovelComments(String novelId);
  Future<List<Comment>> getChapterComments(String novelId, String chapterId);
  Future<Comment> createComment(String novelId, String? chapterId, String content);
  Future<Comment> updateComment(String novelId, String commentId, String content);
  Future<void> deleteComment(String novelId, String commentId);
} 