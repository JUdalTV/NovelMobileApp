import 'package:flutter/material.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: Text('Nhóm dịch'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Tất cả'),
            Tab(text: 'Theo dõi'),
          ],
          indicatorColor: const Color.fromARGB(255, 119, 154, 248),
          labelColor: const Color.fromARGB(255, 119, 154, 248),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllGroupsList(),
          _buildFollowingGroupsList(),
        ],
      ),
    );
  }

  Widget _buildAllGroupsList() {
    // Mock data for groups
    List<Map<String, dynamic>> groups = [
      {'name': 'Hồng Miêu Translations', 'members': 15, 'novels': 28, 'following': true},
      {'name': 'Shine Team', 'members': 32, 'novels': 56, 'following': false},
      {'name': 'FF Translation', 'members': 24, 'novels': 41, 'following': true},
      {'name': 'Dark Side Team', 'members': 18, 'novels': 33, 'following': false},
      {'name': 'Light Novel VN', 'members': 45, 'novels': 72, 'following': true},
      {'name': 'Manga Project', 'members': 28, 'novels': 49, 'following': false},
      {'name': 'Otaku Club', 'members': 36, 'novels': 62, 'following': false},
      {'name': 'Novel Fans', 'members': 22, 'novels': 38, 'following': true},
    ];

    return ListView.separated(
      itemCount: groups.length,
      separatorBuilder: (context, index) => Divider(height: 1),
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.primaries[index % Colors.primaries.length],
            child: Text(
              groups[index]['name'].substring(0, 1),
              style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
          title: Text(groups[index]['name']),
          subtitle: Text('${groups[index]['members']} thành viên • ${groups[index]['novels']} truyện'),
          trailing: IconButton(
            icon: Icon(
              groups[index]['following'] ? Icons.check_circle : Icons.add_circle_outline,
              color: groups[index]['following'] ? Colors.green : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                groups[index]['following'] = !groups[index]['following'];
              });
            },
          ),
          onTap: () {
            // Navigate to group detail screen
          },
        );
      },
    );
  }

  Widget _buildFollowingGroupsList() {
    // Filtered list of followed groups
    List<Map<String, dynamic>> followedGroups = [
      {'name': 'Hồng Miêu Translations', 'members': 15, 'novels': 28, 'following': true},
      {'name': 'FF Translation', 'members': 24, 'novels': 41, 'following': true},
      {'name': 'Light Novel VN', 'members': 45, 'novels': 72, 'following': true},
      {'name': 'Novel Fans', 'members': 22, 'novels': 38, 'following': true},
    ];

    return followedGroups.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.group_off, size: 80, color: Colors.grey[300]),
                SizedBox(height: 16),
                Text(
                  'Bạn chưa theo dõi nhóm nào',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          )
        : ListView.separated(
            itemCount: followedGroups.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.primaries[index % Colors.primaries.length],
                  child: Text(
                    followedGroups[index]['name'].substring(0, 1),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(followedGroups[index]['name']),
                subtitle: Text('${followedGroups[index]['members']} thành viên • ${followedGroups[index]['novels']} truyện'),
                trailing: IconButton(
                  icon: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      followedGroups[index]['following'] = false;
                    });
                  },
                ),
                onTap: () {
                  // Navigate to group detail screen
                },
              );
            },
          );
  }

  void _showCreateGroupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tạo nhóm mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Tên nhóm',
                    hintText: 'Nhập tên nhóm dịch của bạn',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Mô tả',
                    hintText: 'Mô tả về nhóm dịch của bạn',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã tạo nhóm thành công!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text('Tạo'),
            ),
          ],
        );
      },
    );
  }
}