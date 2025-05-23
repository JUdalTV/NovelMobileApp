import 'package:flutter/material.dart';
import '../../widgets/novel_card.dart';
import '../../../domain/entities/novel.dart';
import '../search/search.dart';
import 'bookshelf.dart';
import '../profile/profile_screen.dart';
import 'group.dart';
import '../../../domain/repositories/novel_repository.dart';
import '../novel/novel_screen.dart';

class HomeScreen extends StatefulWidget {
  final NovelRepository novelRepository;

  const HomeScreen({
    Key? key,
    required this.novelRepository,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  
  // Mock featured novel data
  final List<Novel> featuredNovels = [
    Novel(
      id: '1',
      title: 'Đô Thị Cực Phẩm Y Thần',
      coverImage: 'assets/novel1.jpg',
      chapters: [],
    ),
    Novel(
      id: '2',
      title: 'Thành Thần Bắt Đầu Từ Thủy Hầu Tử',
      coverImage: 'assets/novel2.jpg',
      chapters: [],
    ),
    Novel(
      id: '3',
      title: 'Phân diện đại sư huynh',
      coverImage: 'assets/novel3.jpg',
      chapters: [],
    ),
  ];

  // Mock recently updated novel data
  final List<Novel> recentlyUpdatedNovels = [
    Novel(
      id: '4',
      title: 'Toàn Dân Chuyên Chức: Bị Động Cứu Thế',
      coverImage: 'assets/novel4.jpg',
      chapters: [],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Novel(
      id: '5',
      title: 'Toàn Cầu Quỷ Dị Thời Đại',
      coverImage: 'assets/novel5.jpg',
      chapters: [],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Novel(
      id: '6',
      title: 'Ta học Trầm Thần Trong Bệnh Viện T',
      coverImage: 'assets/novel6.jpg',
      chapters: [],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Novel(
      id: '7',
      title: 'Phong Yêu Vấn Đạo',
      coverImage: 'assets/novel7.jpg',
      chapters: [],
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Novel(
      id: '8',
      title: 'Bắt Đầu Với Trăm Vạn Minh Tệ',
      coverImage: 'assets/novel8.jpg',
      chapters: [],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Novel(
      id: '9',
      title: 'Thần Trò Chơi Dục Vọng',
      coverImage: 'assets/novel9.jpg',
      chapters: [],
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];
  
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
    BookshelfScreen(novelRepository: widget.novelRepository),
    NovelScreen(novelRepository: widget.novelRepository),
    SearchScreen(novelRepository: widget.novelRepository),
    ProfileScreen(),
  ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Tủ Sách',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Truyện',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Tìm Kiếm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tôi',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: false,
            snap: true,
            title: _buildSearchBar(),
            automaticallyImplyLeading: false,
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildFeaturedNovel(),
                  SizedBox(height: 16),
                  _buildCategoryButtons(),
                  _buildRecommendedSection(),
                  _buildUpdatedSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/avt.jpg'),
            radius: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(
                      novelRepository: widget.novelRepository,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tìm Kiếm Truyện ...',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.notifications_none, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildFeaturedNovel() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Image.asset(
              'assets/novel.jpg', 
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/novel.jpg',
                      width: 100,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bậc Nữ Thần Đều Là Vợ Ta',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Thiên tài ma pháp sư và cuộc phiêu lưu huyền ảo',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text('Đọc Ngay'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCategoryButton(Icons.format_list_bulleted, 'Thể Loại', Colors.purple),
          _buildCategoryButton(Icons.new_releases, 'Mới nhất', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color.withOpacity(0.9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'KHUYẾN KHÍCH ĐỌC',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.arrow_forward, color: Colors.blue),
          ],
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredNovels.length,
            itemBuilder: (context, index) {
              return NovelCard(
                novel: featuredNovels[index],
                isGridItem: true,
                novelRepository: widget.novelRepository,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpdatedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TRUYỆN MỚI CẬP NHẬT',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.arrow_forward, color: Colors.blue),
          ],
        ),
        SizedBox(height: 12),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: recentlyUpdatedNovels.length,
          itemBuilder: (context, index) {
            return NovelCard(
              novel: recentlyUpdatedNovels[index],
              isGridItem: true,
              novelRepository: widget.novelRepository,
            );
          },
        ),
      ],
    );
  }
}