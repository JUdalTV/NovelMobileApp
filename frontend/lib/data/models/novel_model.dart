import '../../domain/entities/novel.dart';
import '../../domain/entities/chapter.dart';

class NovelModel extends Novel {
  const NovelModel({
    String? id,
    String? title,
    String? author,
    String? description,
    String? coverImage,
    List<String>? categories,
    List<Chapter>? chapters,
    double? rating,
    int? viewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          title: title,
          author: author,
          description: description,
          coverImage: coverImage,
          categories: categories,
          chapters: chapters,
          rating: rating,
          viewCount: viewCount,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory NovelModel.fromJson(Map<String, dynamic> json) {
    return NovelModel(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      coverImage: json['coverImage'],
      categories: List<String>.from(json['categories'] ?? []),
      chapters: (json['chapters'] as List?)
          ?.map((chapter) => Chapter.fromJson(chapter))
          .toList(),
      rating: json['rating']?.toDouble(),
      viewCount: json['viewCount'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'coverImage': coverImage,
      'categories': categories,
      'chapters': chapters?.map((chapter) => chapter.toJson()).toList(),
      'rating': rating,
      'viewCount': viewCount,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Novel toEntity() {
    return Novel(
      id: id,
      title: title,
      author: author,
      description: description,
      coverImage: coverImage,
      categories: categories,
      chapters: chapters,
      rating: rating,
      viewCount: viewCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
} 