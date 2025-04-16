import 'package:flutter/material.dart';
import '../../domain/entities/noveltype.dart';
import '../pages/novel/noveldetail.dart';

class NovelGridItem extends StatelessWidget {
  final Novel novel;
  
  const NovelGridItem({Key? key, required this.novel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NovelDetailScreen(novel: novel),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    novel.coverUrl.replaceFirst('assets/', 'assets/'),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                if (novel.isNew)
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'mới',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Text(
            novel.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Text(
            'Chapter ${novel.chapter}',
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}