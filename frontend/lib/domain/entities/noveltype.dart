class Novel {
  final String id;
  final String title;
  final String coverUrl;
  final int chapter;
  final bool isNew;
  
  Novel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.chapter,
    this.isNew = false,
  });
}
