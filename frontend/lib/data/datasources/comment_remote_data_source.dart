import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/comment.dart';

abstract class CommentRemoteDataSource {
  Future<List<Comment>> getNovelComments(String novelId);
  Future<List<Comment>> getChapterComments(String novelId, String chapterId);
  Future<Comment> createComment(String novelId, String? chapterId, String content);
  Future<Comment> updateComment(String novelId, String commentId, String content);
  Future<void> deleteComment(String novelId, String commentId);
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final String baseUrl;
  final http.Client client;

  CommentRemoteDataSourceImpl({
    required this.baseUrl,
    required this.client,
  });

  @override
  Future<List<Comment>> getNovelComments(String novelId) async {
    final response = await client.get(Uri.parse('$baseUrl/novels/$novelId/comments'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  @override
  Future<List<Comment>> getChapterComments(String novelId, String chapterId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/novels/$novelId/chapters/$chapterId/comments'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  @override
  Future<Comment> createComment(String novelId, String? chapterId, String content) async {
    final response = await client.post(
      Uri.parse('$baseUrl/novels/$novelId/comments'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'chapterId': chapterId,
        'content': content,
      }),
    );
    if (response.statusCode == 201) {
      return Comment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create comment');
    }
  }

  @override
  Future<Comment> updateComment(String novelId, String commentId, String content) async {
    final response = await client.put(
      Uri.parse('$baseUrl/novels/$novelId/comments/$commentId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'content': content}),
    );
    if (response.statusCode == 200) {
      return Comment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update comment');
    }
  }

  @override
  Future<void> deleteComment(String novelId, String commentId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/novels/$novelId/comments/$commentId'),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete comment');
    }
  }
} 