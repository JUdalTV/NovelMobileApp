import 'package:frontend/data/models/novel_model.dart';

import '../../domain/entities/novel.dart';

class FavoriteNovelModel {
  final NovelModel novel;
  final DateTime followedAt;

  FavoriteNovelModel({
    required this.novel,
    required this.followedAt,
  });

  factory FavoriteNovelModel.fromJson(Map<String, dynamic> json) {
    return FavoriteNovelModel(
      novel: NovelModel.fromJson(json['novel']),
      followedAt: DateTime.parse(json['followedAt']),
    );
  }

  Novel toEntity() => novel.toEntity();
} 