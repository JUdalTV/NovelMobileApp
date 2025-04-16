import 'package:flutter/material.dart';
import '../../widgets/novel.dart';
import '../../../domain/entities/noveltype.dart';
import 'search.dart';
import 'bookshelf.dart';
import '../reader/profile.dart';
import 'world.dart';
import 'group.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // Default to 'Truyện' tab
  final TextEditingController _searchController = TextEditingController();
  
  // Mock featured novel data
  final List<Novel> featuredNovels = [
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

  // Mock recently updated novel data
  final List<Novel> recentlyUpdatedNovels = [
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
    Novel(
      id: '6',
      title: 'Ta học Trầm Thần Trong Bệnh Viện T',
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
    Novel(
      id: '9',
      title: 'Thần Trò Chơi Dục Vọng',
      coverUrl: 'lib/data/assets/novel9.jpg',
      chapter: 86,
      isNew: true,
    ),
  ];
  
  final List<Widget> _pages = [
    BookshelfScreen(),
    Center(child: Text('Home Content')), // Will be replaced
    WorldScreen(),
    GroupsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 1 
          ? _buildHomeContent() 
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Tủ Sách'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Truyện'),
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Thế Giới'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Nhóm dịch'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tôi'),
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
            backgroundImage: AssetImage('lib/data/assets/avt.jpg'),
            radius: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
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
              'lib/data/assets/novel.jpg', 
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
                      'lib/data/assets/novel.jpg',
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
    return Container(
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
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredNovels.length,
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                margin: EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          featuredNovels[index].coverUrl.replaceFirst('assets/', 'assets/'),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      featuredNovels[index].title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Chapter ${featuredNovels[index].chapter}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
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
            return NovelGridItem(novel: recentlyUpdatedNovels[index]);
          },
        ),
      ],
    );
  }
}