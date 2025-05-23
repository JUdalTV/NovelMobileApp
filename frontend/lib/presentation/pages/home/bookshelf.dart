// screens/bookshelf_screen.dart
import 'package:flutter/material.dart';
import '../../../domain/entities/novel.dart';
import '../../../domain/repositories/novel_repository.dart';
import '../../widgets/novel_card.dart';
import '../novel/novel_detail_screen.dart';

class BookshelfScreen extends StatefulWidget {
  final NovelRepository novelRepository;

  const BookshelfScreen({
    Key? key,
    required this.novelRepository,
  }) : super(key: key);

  @override
  State<BookshelfScreen> createState() => _BookshelfScreenState();
}

class _BookshelfScreenState extends State<BookshelfScreen> {
  List<Novel> _recommendedNovels = [];
  List<Novel> _recentlyRead = [];
  List<Novel> _followedNovels = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBookshelf();
  }

  Future<void> _loadBookshelf() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Biến theo dõi tình trạng tải dữ liệu
    bool hasLoadedAnyData = false;

    // 1. Tải truyện đề xuất (mới nhất)
    try {
      final allNovels = await widget.novelRepository.getAllNovels();
      final recentNovels = List<Novel>.from(allNovels)
        ..sort((a, b) => (b.createdAt ?? DateTime.now())
            .compareTo(a.createdAt ?? DateTime.now()));
      
      if (mounted) {
        setState(() {
          _recommendedNovels = recentNovels.take(5).toList();
          hasLoadedAnyData = true;
        });
      }
    } catch (e) {
      print('Lỗi khi tải truyện đề xuất: $e');
      // Không set lỗi toàn màn hình, chỉ log
    }
    
    // 2. Tải truyện đã đọc gần đây
    try {
      final recentlyReadNovels = await widget.novelRepository.getRecentlyReadNovels();
      if (mounted) {
        setState(() {
          _recentlyRead = recentlyReadNovels;
          hasLoadedAnyData = true;
        });
      }
    } catch (e) {
      print('Lỗi khi tải truyện đã đọc: $e');
      // Không set lỗi toàn màn hình, chỉ log
    }
    
    // 3. Tải truyện đã đánh dấu theo dõi
    try {
      final bookmarkedNovels = await widget.novelRepository.getBookmarkedNovels();
      if (mounted) {
        setState(() {
          _followedNovels = bookmarkedNovels;
          hasLoadedAnyData = true;
        });
      }
    } catch (e) {
      print('Lỗi khi tải truyện theo dõi: $e');
      // Không set lỗi toàn màn hình, chỉ log
    }
    
    if (mounted) {
      setState(() {
        _isLoading = false;
        // Chỉ hiển thị lỗi chung nếu không tải được dữ liệu nào
        if (!hasLoadedAnyData) {
          _error = 'Không thể tải dữ liệu. Vui lòng thử lại sau.';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tủ Sách Của Tôi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBookshelf,
            tooltip: 'Làm mới',
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
                        onPressed: _loadBookshelf,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadBookshelf,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recommended Section (Đề xuất)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Đề xuất',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 300,
                                child: _recommendedNovels.isEmpty
                                    ? const Center(
                                        child: Text('Không có truyện đề xuất'),
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _recommendedNovels.length,
                                        itemBuilder: (context, index) {
                                          final novel = _recommendedNovels[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 16),
                                            child: NovelCard(
                                              novel: novel,
                                              width: 200,
                                              height: 300,
                                              novelRepository: widget.novelRepository,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => NovelDetailScreen(
                                                      novel: novel,
                                                      novelRepository: widget.novelRepository,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Recently Read Section (Đã Đọc)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Đã Đọc',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 300,
                                child: _recentlyRead.isEmpty
                                    ? const Center(
                                        child: Text('Chưa có truyện nào đã đọc'),
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _recentlyRead.length,
                                        itemBuilder: (context, index) {
                                          final novel = _recentlyRead[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 16),
                                            child: NovelCard(
                                              novel: novel,
                                              width: 200,
                                              height: 300,
                                              novelRepository: widget.novelRepository,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => NovelDetailScreen(
                                                      novel: novel,
                                                      novelRepository: widget.novelRepository,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),

                        // Followed Novels Section (Theo Dõi)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Theo Dõi',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 300,
                                child: _followedNovels.isEmpty
                                    ? const Center(
                                        child: Text('Chưa theo dõi truyện nào'),
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _followedNovels.length,
                                        itemBuilder: (context, index) {
                                          final novel = _followedNovels[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 16),
                                            child: NovelCard(
                                              novel: novel,
                                              width: 200,
                                              height: 300,
                                              novelRepository: widget.novelRepository,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => NovelDetailScreen(
                                                      novel: novel,
                                                      novelRepository: widget.novelRepository,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
