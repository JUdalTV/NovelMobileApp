import 'package:flutter/material.dart';
import '../../../domain/entities/noveltype.dart';

class NovelDetailScreen extends StatelessWidget {
  final Novel novel;
  
  const NovelDetailScreen({Key? key, required this.novel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    novel.coverUrl.replaceFirst('assets/', 'assets/'),
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          novel.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.remove_red_eye, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              '10.2K',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 16),
                            Icon(Icons.favorite, color: Colors.red, size: 16),
                            SizedBox(width: 4),
                            Text(
                              '2.5K',
                              style: TextStyle(color: Colors.white),
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.add),
                          label: Text('Thêm vào tủ'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.book),
                          label: Text('Đọc từ đầu'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Giới thiệu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Đây là câu chuyện về một nhân vật chính với năng lực đặc biệt trong thế giới đầy phiêu lưu và thử thách. Hành trình của họ sẽ đưa bạn qua những khám phá bất ngờ và cuộc gặp gỡ với nhiều nhân vật thú vị.',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Danh sách chương',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildChapterList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterList() {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        int chapterNumber = novel.chapter - index;
        if (chapterNumber <= 0) return SizedBox.shrink();
        
        return ListTile(
          title: Text('Chapter $chapterNumber'),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Navigate to chapter reading screen
          },
        );
      },
    );
  }
}