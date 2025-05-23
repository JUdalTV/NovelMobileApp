import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/chapter.dart';

abstract class ChapterRemoteDataSource {
  Future<List<Chapter>> getChapters(String novelId);
  Future<Chapter> getChapterById(String novelId, String chapterId);
  Future<Chapter> createChapter(String novelId, Chapter chapter);
  Future<Chapter> updateChapter(String novelId, String chapterId, Chapter chapter);
  Future<void> deleteChapter(String novelId, String chapterId);
  Future<void> updateReadingProgress(String novelId, String chapterId);
  Future<String?> getLastReadChapter(String novelId);
}

class ChapterRemoteDataSourceImpl implements ChapterRemoteDataSource {
  final String baseUrl;
  final http.Client client;

  ChapterRemoteDataSourceImpl({
    required this.baseUrl,
    required this.client,
  });

  @override
  Future<List<Chapter>> getChapters(String novelId) async {
    final response = await client.get(Uri.parse('$baseUrl/novels/$novelId/chapters'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Chapter.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chapters');
    }
  }

  @override
  Future<Chapter> getChapterById(String novelId, String chapterId) async {
    final response = await client.get(Uri.parse('$baseUrl/novels/$novelId/chapters/$chapterId'));
    if (response.statusCode == 200) {
      return Chapter.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load chapter');
    }
  }

  @override
  Future<Chapter> createChapter(String novelId, Chapter chapter) async {
    final response = await client.post(
      Uri.parse('$baseUrl/novels/$novelId/chapters'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(chapter.toJson()),
    );
    if (response.statusCode == 201) {
      return Chapter.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create chapter');
    }
  }

  @override
  Future<Chapter> updateChapter(String novelId, String chapterId, Chapter chapter) async {
    final response = await client.put(
      Uri.parse('$baseUrl/novels/$novelId/chapters/$chapterId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(chapter.toJson()),
    );
    if (response.statusCode == 200) {
      return Chapter.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update chapter');
    }
  }

  @override
  Future<void> deleteChapter(String novelId, String chapterId) async {
    final response = await client.delete(Uri.parse('$baseUrl/novels/$novelId/chapters/$chapterId'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete chapter');
    }
  }

  @override
  Future<void> updateReadingProgress(String novelId, String chapterId) async {
    final response = await client.post(
      Uri.parse('$baseUrl/novels/$novelId/progress'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'chapterId': chapterId}),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update reading progress');
    }
  }

  @override
  Future<String?> getLastReadChapter(String novelId) async {
    final response = await client.get(Uri.parse('$baseUrl/novels/$novelId/progress'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['chapterId'];
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to get last read chapter');
    }
  }
} 