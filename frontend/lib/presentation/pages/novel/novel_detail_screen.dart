import 'package:flutter/material.dart';
import 'package:frontend/data/repositories/novel_repository_impl.dart';
import '../../../domain/entities/novel.dart';
import '../../../domain/entities/chapter.dart';
import '../../../domain/repositories/novel_repository.dart';
import 'chapter_list_screen.dart';
import 'chapter_screen.dart';

class NovelDetailScreen extends StatefulWidget {
  final Novel novel;
  final NovelRepository novelRepository;

  const NovelDetailScreen({
    super.key,
    required this.novel,
    required this.novelRepository,
  });

  @override
  State<NovelDetailScreen> createState() => _NovelDetailScreenState();
}

class _NovelDetailScreenState extends State<NovelDetailScreen> {
  late Novel _novel;
  bool _isLoading = false;
  bool _isLoadingChapters = false;
  bool _isBookmarked = false;
  String? _error;
  List<Chapter> _chapters = [];

  @override
  void initState() {
    super.initState();
    _novel = widget.novel;
    _loadChapters();
    _trackNovelView();
    _checkBookmarkStatus();
  }

  Future<void> _loadNovelDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final novel = await widget.novelRepository.getNovelById(_novel.id!);
      setState(() {
        _novel = novel;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadChapters() async {
    setState(() {
      _isLoadingChapters = true;
    });

    try {
      final chapters = await widget.novelRepository.getChaptersByNovelId(_novel.id!);
      setState(() {
        _chapters = chapters;
        _isLoadingChapters = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingChapters = false;
      });
      // Fallback to chapters from novel object if API fails
      if (_novel.chapters != null) {
        _chapters = _novel.chapters!;
      }
    }
  }

  Future<void> _trackNovelView() async {
    if (_novel.id != null) {
      try {
        // Add this novel to recently read list
        final novelRepositoryImpl = widget.novelRepository as NovelRepositoryImpl;
        await novelRepositoryImpl.localDataSource.addRecentNovel(_novel.id!);
      } catch (e) {
        print('Error tracking novel view: $e');
      }
    }
  }

  Future<void> _checkBookmarkStatus() async {
    if (_novel.id != null) {
      try {
        final novelRepositoryImpl = widget.novelRepository as NovelRepositoryImpl;
        final bookmarkedIds = await novelRepositoryImpl.localDataSource.getBookmarkedNovelIds();
        if (mounted) {
          setState(() {
            _isBookmarked = bookmarkedIds.contains(_novel.id);
          });
        }
      } catch (e) {
        print('Error checking bookmark status: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : CustomScrollView(
                  slivers: [
                    // App Bar with Cover Image
                    SliverAppBar(
                      expandedHeight: 300,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              _novel.coverImage ?? 'https://via.placeholder.com/400x600',
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withAlpha(179), // 0.7 * 255 ≈ 179
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _novel.title ?? 'Untitled',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.visibility,
                                        color: Colors.white70,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${_novel.viewCount ?? 0} lượt xem',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        (_novel.rating ?? 0).toStringAsFixed(1),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Novel Details
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Author
                            Row(
                              children: [
                                const Icon(Icons.person, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  _novel.author ?? 'Unknown Author',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Description
                            const Text(
                              'Mô tả',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _novel.description ?? 'No description available.',
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      try {
                                        if (_isBookmarked) {
                                          await widget.novelRepository.unbookmarkNovel(_novel.id!);
                                          if (mounted) {
                                            setState(() {
                                              _isBookmarked = false;
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Đã xóa khỏi thư viện')),
                                            );
                                          }
                                        } else {
                                          await widget.novelRepository.bookmarkNovel(_novel.id!);
                                          if (mounted) {
                                            setState(() {
                                              _isBookmarked = true;
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Đã thêm vào thư viện')),
                                            );
                                          }
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Lỗi: ${e.toString()}')),
                                          );
                                        }
                                      }
                                    },
                                    icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                                    label: Text(_isBookmarked ? 'Xóa khỏi thư viện' : 'Thêm vào thư viện'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      backgroundColor: _isBookmarked ? Colors.grey : null,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChapterListScreen(
                                            novel: _novel,
                                            novelRepository: widget.novelRepository,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.menu_book),
                                    label: const Text('Đọc'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Chapters
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Danh sách chương',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChapterListScreen(
                                          novel: _novel,
                                          novelRepository: widget.novelRepository,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Xem tất cả'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _isLoadingChapters
                                ? const Center(child: CircularProgressIndicator())
                                : _chapters.isEmpty
                                    ? const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Text('Chưa có chương nào'),
                                        ),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: _chapters.length > 5 ? 5 : _chapters.length,
                                        itemBuilder: (context, index) {
                                          final chapter = _chapters[index];
                                          return ListTile(
                                            title: Text(chapter.title ?? 'Untitled Chapter'),
                                            trailing: const Icon(Icons.chevron_right),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ChapterScreen(
                                                    novel: _novel,
                                                    chapter: chapter,
                                                    novelRepository: widget.novelRepository,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
} 