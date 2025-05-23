class Comment {
  final String? id;
  final String? userId;
  final String? novelId;
  final String? chapterId;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? username;
  final String? avatar;

  Comment({
    this.id,
    this.userId,
    this.novelId,
    this.chapterId,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.username,
    this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'novelId': novelId,
      'chapterId': chapterId,
      'content': content,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'username': username,
      'avatar': avatar,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['userId'],
      novelId: json['novelId'],
      chapterId: json['chapterId'],
      content: json['content'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      username: json['username'],
      avatar: json['avatar'],
    );
  }
} 