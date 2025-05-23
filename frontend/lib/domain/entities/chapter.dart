import 'package:equatable/equatable.dart';

class Chapter extends Equatable {
  final String? id;
  final String? novelId;
  final String? title;
  final String? content;
  final int? chapterNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Chapter({
    this.id,
    this.novelId,
    this.title,
    this.content,
    this.chapterNumber,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        novelId,
        title,
        content,
        chapterNumber,
        createdAt,
        updatedAt,
      ];

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      novelId: json['novelId'],
      title: json['title'],
      content: json['content'],
      chapterNumber: json['chapterNumber'],
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
      'novelId': novelId,
      'title': title,
      'content': content,
      'chapterNumber': chapterNumber,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
} 