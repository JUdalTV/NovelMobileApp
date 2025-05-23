import 'package:flutter/material.dart';
import '../../../domain/entities/novel.dart';
import '../../../domain/repositories/novel_repository.dart';
import '../../widgets/novel_card.dart';
import '../novel/novel_detail_screen.dart';

class HistoryNovelScreen extends StatefulWidget {
  final NovelRepository novelRepository;

  const HistoryNovelScreen({
    Key? key,
    required this.novelRepository,
  }) : super(key: key);

  @override
  State<HistoryNovelScreen> createState() => _HistoryNovelScreenState();
}

class _HistoryNovelScreenState extends State<HistoryNovelScreen> {
  List<Novel> _recentlyReadNovels = [];
  bool _isLoading = true;
  String? _error;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _loadRecentlyReadNovels();
  }

  Future<void> _loadRecentlyReadNovels() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final novels = await widget.novelRepository.getRecentlyReadNovels();
      setState(() {
        _recentlyReadNovels = novels;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có muốn xóa toàn bộ lịch sử đọc không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Xóa'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        // Giả định rằng có một phương thức clearRecentNovels trong LocalDataSource
        // Vì chúng ta không có phương thức này trong Repository, bạn có thể thêm nó sau
        final novelRepositoryImpl = widget.novelRepository as dynamic;
        await novelRepositoryImpl.localDataSource.clearRecentNovels();
        
        setState(() {
          _recentlyReadNovels = [];
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã xóa lịch sử đọc')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi khi xóa lịch sử: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử đọc'),
        elevation: 0,
        actions: [
          if (_recentlyReadNovels.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearHistory,
              tooltip: 'Xóa lịch sử',
            ),
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
                        onPressed: _loadRecentlyReadNovels,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : _recentlyReadNovels.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 72,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Chưa có lịch sử đọc',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Truyện bạn đọc sẽ hiện ở đây',
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
                      onRefresh: _loadRecentlyReadNovels,
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
      itemCount: _recentlyReadNovels.length,
      itemBuilder: (context, index) {
        final novel = _recentlyReadNovels[index];
        return NovelCard(
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
            ).then((_) => _loadRecentlyReadNovels());
          },
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _recentlyReadNovels.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final novel = _recentlyReadNovels[index];
        return ListTile(
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
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 4),
                  Text('Đọc gần đây'),
                ],
              ),
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NovelDetailScreen(
                  novel: novel,
                  novelRepository: widget.novelRepository,
                ),
              ),
            ).then((_) => _loadRecentlyReadNovels());
          },
        );
      },
    );
  }
} 