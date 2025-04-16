import 'package:flutter/material.dart';
import '../../../domain/entities/noveltype.dart';
import '../../widgets/novel.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Novel> searchResults = [];
  bool _isSearching = false;
  
  // Mock data for search results
  final List<Novel> allNovels = [
    Novel(id: '1', title: 'Đô Thị Cực Phẩm Y Thần', coverUrl: 'assets/covers/novel1.jpg', chapter: 246),
    Novel(id: '2', title: 'Thành Thần Bắt Đầu Từ Thủy Hầu Tử', coverUrl: 'assets/covers/novel2.jpg', chapter: 30),
    Novel(id: '3', title: 'Phân diện đại sư huynh', coverUrl: 'assets/covers/novel3.jpg', chapter: 202),
    Novel(id: '4', title: 'Toàn Dân Chuyên Chức: Bị Động Cứu Thế', coverUrl: 'assets/covers/novel4.jpg', chapter: 76),
    Novel(id: '5', title: 'Toàn Cầu Quỷ Dị Thời Đại', coverUrl: 'assets/covers/novel5.jpg', chapter: 462),
    Novel(id: '6', title: 'Ta học Trầm Thần Trong Bệnh Viện T', coverUrl: 'assets/covers/novel6.jpg', chapter: 209),
    // Add more novel data
  ];

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      searchResults = allNovels
          .where((novel) => novel.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _performSearch,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Tìm Kiếm Truyện ...',
            hintStyle: TextStyle(color: const Color.fromARGB(179, 0, 0, 0)),
            border: InputBorder.none,
          ),
          style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _performSearch('');
            },
          ),
        ],
      ),
      body: _isSearching
          ? (searchResults.isEmpty
              ? Center(child: Text('Không tìm thấy kết quả'))
              : GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    return NovelGridItem(novel: searchResults[index]);
                  },
                ))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 80, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'Nhập tên truyện để tìm kiếm',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
    );
  }
}
