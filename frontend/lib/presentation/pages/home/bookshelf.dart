// screens/bookshelf_screen.dart
import 'package:flutter/material.dart';
import '../../../domain/entities/noveltype.dart';
import '../../widgets/novel.dart';

class BookshelfScreen extends StatefulWidget {
  @override
  _BookshelfScreenState createState() => _BookshelfScreenState();
}

class _BookshelfScreenState extends State<BookshelfScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data for saved novel
  final List<Novel> savedNovels = [
    Novel(
      id: '1',
      title: 'Đô Thị Cực Phẩm Y Thần',
      coverUrl: 'lib/data/assets/novel1.jpg',
      chapter: 246,
    ),
    Novel(
      id: '2',
      title: 'Thành Thần Bắt Đầu Từ Thủy Hầu Tử',
      coverUrl: 'lib/data/assets/novel2.jpg',
      chapter: 30,
    ),
    Novel(
      id: '3',
      title: 'Phân diện đại sư huynh',
      coverUrl: 'lib/data/assets/novel3.jpg',
      chapter: 202,
    ),
  ];

  // Mock data for recently read novel
  final List<Novel> recentlyReadNovels = [
    Novel(
      id: '4',
      title: 'Toàn Dân Chuyên Chức: Bị Động Cứu Thế',
      coverUrl: 'lib/data/assets/novel4.jpg',
      chapter: 76,
      isNew: true,
    ),
    Novel(
      id: '5',
      title: 'Toàn Cầu Quỷ Dị Thời Đại',
      coverUrl: 'lib/data/assets/novel5.jpg',
      chapter: 462,
      isNew: true,
    ),
  ];

  // Mock data for followed novel
  final List<Novel> followedNovels = [
    Novel(
      id: '6',
      title: 'Ta học Trầm Thần Trong Bệnh Viện Tâm Thần',
      coverUrl: 'lib/data/assets/novel6.jpg',
      chapter: 209,
      isNew: true,
    ),
    Novel(
      id: '7',
      title: 'Phong Yêu Vấn Đạo',
      coverUrl: 'lib/data/assets/novel7.jpg',
      chapter: 146,
      isNew: true,
    ),
    Novel(
      id: '8',
      title: 'Bắt Đầu Với Trăm Vạn Minh Tệ',
      coverUrl: 'lib/data/assets/novel8.jpg',
      chapter: 228,
      isNew: true,
    ),
  ];

  // Mock data for downloaded novel
  final List<Novel> downloadedNovels = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tủ Sách'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Tất cả'),
            Tab(text: 'Vừa xem'),
            Tab(text: 'Theo dõi'),
            Tab(text: 'Tải về'),
          ],
          indicatorColor: const Color.fromARGB(255, 119, 154, 248),
          labelColor: const Color.fromARGB(255, 119, 154, 248),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNovelGrid(savedNovels),
          _buildNovelGrid(recentlyReadNovels),
          _buildNovelGrid(followedNovels),
          downloadedNovels.isEmpty
              ? _buildEmptyView('Không có truyện đã tải')
              : _buildNovelGrid(downloadedNovels),
        ],
      ),
    );
  }

  Widget _buildNovelGrid(List<Novel> novels) {
    return novels.isEmpty
        ? _buildEmptyView('Chưa có truyện nào trong thư mục này')
        : GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: novels.length,
            itemBuilder: (context, index) {
              return NovelGridItem(novel: novels[index]);
            },
          );
  }

  Widget _buildEmptyView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book, size: 80, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
