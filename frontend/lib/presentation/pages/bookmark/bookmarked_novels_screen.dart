import 'package:flutter/material.dart';
import '../../../domain/entities/novel.dart';
import '../../../domain/repositories/novel_repository.dart';
import '../../widgets/novel_card.dart';
import '../novel/novel_detail_screen.dart';

class BookmarkedNovelsScreen extends StatefulWidget {
  final NovelRepository novelRepository;

  const BookmarkedNovelsScreen({
    Key? key,
    required this.novelRepository,
  }) : super(key: key);

  @override
  State<BookmarkedNovelsScreen> createState() => _BookmarkedNovelsScreenState();
}

class _BookmarkedNovelsScreenState extends State<BookmarkedNovelsScreen> {
  List<Novel> _bookmarkedNovels = [];
  bool _isLoading = true;
  String? _error;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarkedNovels();
  }

  Future<void> _loadBookmarkedNovels() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final novels = await widget.novelRepository.getBookmarkedNovels();
      setState(() {
        _bookmarkedNovels = novels;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _removeBookmark(Novel novel) async {
    try {
      await widget.novelRepository.unbookmarkNovel(novel.id!);
      setState(() {
        _bookmarkedNovels.removeWhere((item) => item.id == novel.id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa "${novel.title}" khỏi danh sách theo dõi'),
            action: SnackBarAction(
              label: 'Hoàn tác',
              onPressed: () async {
                await widget.novelRepository.bookmarkNovel(novel.id!);
                _loadBookmarkedNovels();
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đã đánh dấu'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            tooltip: _isGridView ? 'Chế độ danh sách' : 'Chế độ lưới',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadBookmarkedNovels,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : _bookmarkedNovels.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            size: 72,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Bạn chưa đánh dấu truyện nào',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Đánh dấu truyện bạn thích để đọc sau',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.explore),
                            label: const Text('Khám phá truyện'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadBookmarkedNovels,
                      child: _isGridView ? _buildGridView() : _buildListView(),
                    ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
      ),
      itemCount: _bookmarkedNovels.length,
      itemBuilder: (context, index) {
        final novel = _bookmarkedNovels[index];
        return Stack(
          children: [
            NovelCard(
              novel: novel,
              novelRepository: widget.novelRepository,
              isGridItem: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NovelDetailScreen(
                      novel: novel,
                      novelRepository: widget.novelRepository,
                    ),
                  ),
                ).then((_) => _loadBookmarkedNovels());
              },
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red[400],
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.bookmark_remove, color: Colors.white),
                  iconSize: 20,
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  onPressed: () => _removeBookmark(novel),
                  tooltip: 'Bỏ theo dõi',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _bookmarkedNovels.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final novel = _bookmarkedNovels[index];
        return Dismissible(
          key: Key(novel.id!),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Xác nhận'),
                  content: Text('Bỏ theo dõi truyện "${novel.title}"?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Xóa'),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) {
            _removeBookmark(novel);
          },
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                novel.coverImage ?? 'https://via.placeholder.com/80x120',
                width: 60,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  );
                },
              ),
            ),
            title: Text(
              novel.title ?? 'Không có tiêu đề',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Tác giả: ${novel.author ?? 'Không rõ'}'),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.remove_red_eye, size: 16),
                    const SizedBox(width: 4),
                    Text('${novel.viewCount ?? 0}'),
                    const SizedBox(width: 16),
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${novel.rating ?? 0}'),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.bookmark_remove),
              color: Colors.red,
              onPressed: () => _removeBookmark(novel),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NovelDetailScreen(
                    novel: novel,
                    novelRepository: widget.novelRepository,
                  ),
                ),
              ).then((_) => _loadBookmarkedNovels());
            },
          ),
        );
      },
    );
  }
} 