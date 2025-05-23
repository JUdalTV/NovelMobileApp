import 'package:equatable/equatable.dart';
import 'chapter.dart';

class Novel extends Equatable {
  final String? id;
  final String? title;
  final String? author;
  final String? description;
  final String? coverImage;
  final List<String>? categories;
  final List<Chapter>? chapters;
  final double? rating;
  final int? viewCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Novel({
    this.id,
    this.title,
    this.author,
    this.description,
    this.coverImage,
    this.categories,
    this.chapters,
    this.rating,
    this.viewCount,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, title, author, description, coverImage, categories, chapters, rating, viewCount, createdAt, updatedAt];

  factory Novel.fromJson(Map<String, dynamic> json) {
    return Novel(
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
} 