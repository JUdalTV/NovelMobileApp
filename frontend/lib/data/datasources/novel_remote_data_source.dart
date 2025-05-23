import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../domain/entities/novel.dart';
import '../models/novel_model.dart';
import '../../domain/entities/chapter.dart';
import '../../config/api_config.dart';

abstract class NovelRemoteDataSource {
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
  Future<List<Chapter>> getChaptersByNovelId(String novelId);
  Future<Chapter> getChapterByNovelAndNumber(String novelId, int chapterNumber);
}

class NovelRemoteDataSourceImpl implements NovelRemoteDataSource {
  final String baseUrl;
  final http.Client client;

  NovelRemoteDataSourceImpl({
    required this.baseUrl,
    required this.client,
  });

  @override
  Future<List<Novel>> getAllNovels() async {
    final response = await client.get(Uri.parse('$baseUrl/novels'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
        final List<dynamic> novelsList = jsonResponse['data'];
        return novelsList.map((json) => NovelModel.fromJson(json)).toList();
      } else if (jsonResponse is List) {
        return jsonResponse.map((json) => NovelModel.fromJson(json)).toList();
      }
      throw Exception('Unexpected response format');
    } else {
      throw Exception('Failed to load novels');
    }
  }

  @override
  Future<List<Novel>> searchNovels(String query) async {
    final response = await client.get(
      Uri.parse('$baseUrl/novels/search').replace(queryParameters: {'q': query}),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
        final List<dynamic> novelsList = jsonResponse['data'];
        return novelsList.map((json) => NovelModel.fromJson(json)).toList();
      } else if (jsonResponse is List) {
        return jsonResponse.map((json) => NovelModel.fromJson(json)).toList();
      }
      throw Exception('Unexpected response format');
    } else {
      throw Exception('Failed to search novels');
    }
  }

  @override
  Future<Novel> getNovelById(String id) async {
    int retries = 0;
    SocketException? lastSocketError;
    Exception? lastException;
    
    // Try primary URL first
    while (retries <= ApiConfig.maxRetries) {
      try {
        print('Fetching novel with ID: $id (attempt ${retries + 1})');
        final uri = Uri.parse('$baseUrl/novels/$id');
        print('Request URL: $uri');
        
        final response = await client.get(uri)
          .timeout(Duration(milliseconds: ApiConfig.connectionTimeout), 
            onTimeout: () {
              print('Connection timeout while fetching novel ID: $id');
              throw SocketException('Connection timed out');
            });
            
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
            return NovelModel.fromJson(jsonResponse['data']);
          } else {
            return NovelModel.fromJson(jsonResponse);
          }
        } else {
          print('API Error: ${response.statusCode} ${response.body}');
          throw Exception('Failed to load novel: Server responded with ${response.statusCode}');
        }
      } on SocketException catch (e) {
        lastSocketError = e;
        retries++;
        if (retries <= ApiConfig.maxRetries) {
          print('Network error when fetching novel ID $id (attempt $retries): $e. Retrying in ${ApiConfig.retryDelay * retries}ms...');
          await Future.delayed(Duration(milliseconds: ApiConfig.retryDelay * retries));
        } else {
          // All retries failed with primary URL, try fallback URLs
          print('All primary URL attempts failed, trying fallback URLs');
          lastException = Exception('Network error with primary URL after ${retries} attempts: $e');
          break; // Break out to try fallback URLs
        }
      } on FormatException catch (e) {
        print('Data format error when fetching novel ID $id: $e');
        throw Exception('Invalid data format received from server');
      } catch (e) {
        print('Unexpected error when fetching novel ID $id: $e');
        throw Exception('Failed to load novel: $e');
      }
    }
    
    // If primary URL failed, try fallback URLs
    if (retries > ApiConfig.maxRetries) {
      for (final fallbackUrl in ApiConfig.fallbackUrls) {
        try {
          print('Trying fallback URL: $fallbackUrl for novel ID: $id');
          final uri = Uri.parse('$fallbackUrl/novels/$id');
          
          final response = await client.get(uri)
            .timeout(Duration(milliseconds: ApiConfig.connectionTimeout), 
              onTimeout: () {
                print('Connection timeout with fallback URL: $fallbackUrl');
                throw SocketException('Connection timed out');
              });
              
          if (response.statusCode == 200) {
            final jsonResponse = json.decode(response.body);
            if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
              return NovelModel.fromJson(jsonResponse['data']);
            } else {
              return NovelModel.fromJson(jsonResponse);
            }
          }
        } catch (e) {
          print('Fallback URL $fallbackUrl failed: $e');
          // Continue to next fallback URL
        }
      }
    }
    
    // If all URLs failed, throw the last exception
    throw lastException ?? Exception('Failed to load novel: All server connections failed');
  }

  @override
  Future<Novel> getNovelBySlug(String slug) async {
    final response = await client.get(Uri.parse('$baseUrl/novels/slug/$slug'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
        return NovelModel.fromJson(jsonResponse['data']);
      } else {
        return NovelModel.fromJson(jsonResponse);
      }
    } else {
      throw Exception('Failed to load novel');
    }
  }

  @override
  Future<Novel> createNovel(Novel novel) async {
    final response = await client.post(
      Uri.parse('$baseUrl/novels'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode((novel as NovelModel).toJson()),
    );
    if (response.statusCode == 201) {
      return NovelModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create novel');
    }
  }

  @override
  Future<Novel> updateNovel(String id, Novel novel) async {
    final response = await client.put(
      Uri.parse('$baseUrl/novels/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode((novel as NovelModel).toJson()),
    );
    if (response.statusCode == 200) {
      return NovelModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update novel');
    }
  }

  @override
  Future<void> deleteNovel(String id) async {
    final response = await client.delete(Uri.parse('$baseUrl/novels/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete novel');
    }
  }

  @override
  Future<String> uploadCoverImage(String id, String imagePath) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/novels/$id/cover'),
    );
    request.files.add(await http.MultipartFile.fromPath('coverImage', imagePath));
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);
      return jsonResponse['coverImage'];
    } else {
      throw Exception('Failed to upload cover image');
    }
  }

  @override
  Future<List<Novel>> getNovels({
    int page = 1,
    int limit = 10,
    String? category,
    String? searchQuery,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (category != null) 'category': category,
      if (searchQuery != null) 'search': searchQuery,
    };
    
    print('Making API request with params: $queryParams');
    
    int retries = 0;
    SocketException? lastSocketError;
    
    while (retries <= ApiConfig.maxRetries) {
      try {
        final uri = Uri.parse('$baseUrl/novels').replace(queryParameters: queryParams);
        print('Request URL: $uri (attempt ${retries + 1})');
        
        final response = await client.get(uri)
          .timeout(Duration(milliseconds: ApiConfig.connectionTimeout), 
            onTimeout: () {
              print('Connection timeout while fetching novels');
              throw SocketException('Connection timed out');
            });
            
        print('Response status: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          print('Response data received');
          if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
            final List<dynamic> novelsList = jsonResponse['data'];
            print('Found ${novelsList.length} novels');
            return novelsList.map((json) => NovelModel.fromJson(json)).toList();
          } else if (jsonResponse is List) {
            print('Found ${jsonResponse.length} novels (list response)');
            return jsonResponse.map((json) => NovelModel.fromJson(json)).toList();
          }
          throw Exception('Unexpected response format');
        } else {
          print('API Error: ${response.statusCode} ${response.body}');
          throw Exception('Failed to load novels: Server responded with ${response.statusCode}');
        }
      } on SocketException catch (e) {
        lastSocketError = e;
        retries++;
        if (retries <= ApiConfig.maxRetries) {
          print('Network error when fetching novels (attempt $retries): $e. Retrying in ${ApiConfig.retryDelay * retries}ms...');
          await Future.delayed(Duration(milliseconds: ApiConfig.retryDelay * retries));
        } else {
          print('Network error when fetching novels: All retry attempts failed: $e');
          throw Exception('Network error after ${retries} attempts: Please check your connection');
        }
      } on FormatException catch (e) {
        print('Data format error when fetching novels: $e');
        throw Exception('Invalid data format received from server');
      } catch (e) {
        print('Unexpected error when fetching novels: $e');
        throw Exception('Failed to load novels: $e');
      }
    }
    
    // This should never be reached due to the loop conditions, but adding as a safeguard
    throw Exception('Network error after ${retries} attempts: ${lastSocketError}');
  }

  @override
  Future<List<Chapter>> getChapters(String novelId) async {
    final response = await client.get(Uri.parse('$baseUrl/novels/$novelId/chapters'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
        final List<dynamic> chaptersList = jsonResponse['data'];
        return chaptersList.map((json) => Chapter.fromJson(json)).toList();
      } else if (jsonResponse is List) {
        return jsonResponse.map((json) => Chapter.fromJson(json)).toList();
      }
      throw Exception('Unexpected response format');
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
  Future<void> bookmarkNovel(String novelId) async {
    final response = await client.post(Uri.parse('$baseUrl/novels/$novelId/bookmark'));
    if (response.statusCode != 204) {
      throw Exception('Failed to bookmark novel');
    }
  }

  @override
  Future<void> unbookmarkNovel(String novelId) async {
    final response = await client.delete(Uri.parse('$baseUrl/novels/$novelId/bookmark'));
    if (response.statusCode != 204) {
      throw Exception('Failed to unbookmark novel');
    }
  }

  @override
  Future<List<Novel>> getBookmarkedNovels() async {
    final response = await client.get(Uri.parse('$baseUrl/novels/bookmarked'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
        final List<dynamic> novelsList = jsonResponse['data'];
        return novelsList.map((json) => NovelModel.fromJson(json)).toList();
      } else if (jsonResponse is List) {
        return jsonResponse.map((json) => NovelModel.fromJson(json)).toList();
      }
      throw Exception('Unexpected response format');
    } else {
      throw Exception('Failed to load bookmarked novels');
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

  @override
  Future<List<Chapter>> getChaptersByNovelId(String novelId) async {
    final response = await client.get(Uri.parse('$baseUrl/novels/$novelId/chapters'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
        final List<dynamic> chaptersList = jsonResponse['data'];
        return chaptersList.map((json) => Chapter.fromJson(json)).toList();
      } else if (jsonResponse is List) {
        return jsonResponse.map((json) => Chapter.fromJson(json)).toList();
      }
      throw Exception('Unexpected response format');
    } else {
      throw Exception('Failed to load chapters');
    }
  }

  @override
  Future<Chapter> getChapterByNovelAndNumber(String novelId, int chapterNumber) async {
    print('Calling API: $baseUrl/novels/$novelId/chapters/number/$chapterNumber');
    final response = await client.get(
      Uri.parse('$baseUrl/novels/$novelId/chapters/number/$chapterNumber'),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
        return Chapter.fromJson(jsonResponse['data']);
      } else {
        return Chapter.fromJson(jsonResponse);
      }
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception('Failed to load chapter: ${errorResponse['message'] ?? 'Unknown error'}');
    }
  }
} 