import 'package:flutter/material.dart';
import '../../../domain/entities/novel.dart';
import '../../../domain/repositories/novel_repository.dart';
import '../../../data/repositories/novel_repository_impl.dart';
import 'novel_detail_screen.dart';
import '../../widgets/novel_card.dart';
import '../search/search.dart';

class NovelScreen extends StatefulWidget {
  final NovelRepository novelRepository;

  const NovelScreen({
    super.key,
    required this.novelRepository,
  });

  @override
  State<NovelScreen> createState() => _NovelScreenState();
}

class _NovelScreenState extends State<NovelScreen> with SingleTickerProviderStateMixin {
  List<Novel> _novels = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedCategory;
  int _currentPage = 1;
  bool _hasMore = true;
  late TabController _tabController;
  final List<String> _categories = ['Tất cả', 'Tiên hiệp', 'Kiếm hiệp', 'Ngôn tình', 'Đô thị', 'Huyền huyễn', 'Xuyên không'];
  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _scrollController.addListener(_onScroll);
    _loadNovels();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedCategory = _tabController.index == 0 ? null : _categories[_tabController.index];
        _currentPage = 1;
        _novels = [];
        _hasMore = true;
      });
      _loadNovels(refresh: true);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadNovels();
    }
  }

  Future<void> _loadNovels({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _hasMore = true;
        _novels = [];
      });
    }

    if (!_hasMore || _isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final novels = await widget.novelRepository.getNovels(
        page: _currentPage,
        limit: 10,
        category: _selectedCategory == 'Tất cả' ? null : _selectedCategory,
        searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
      );

      setState(() {
        if (refresh) {
          _novels = novels;
        } else {
          _novels.addAll(novels);
        }
        _hasMore = novels.length == 10;
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      _currentPage = 1;
      _novels = [];
      _hasMore = true;
      _selectedCategory = null;
      _tabController.animateTo(0);
    });
    _loadNovels(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text('Thư viện truyện', 
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              floating: true,
              pinned: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(
                          novelRepository: widget.novelRepository,
                        ),
                      ),
                    );
                  },
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: _categories.map((cat) => Tab(text: cat)).toList(),
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.label,
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ];
        },
        body: _buildNovelGrid(),
      ),
    );
  }

  Widget _buildNovelGrid() {
    if (_isLoading && _novels.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _novels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Không thể tải truyện: $_error',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _loadNovels(refresh: true),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_novels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book,
              size: 120,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _selectedCategory == null ? 
                'Không tìm thấy truyện nào' : 
                'Không tìm thấy truyện thể loại $_selectedCategory',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hãy thử với thể loại khác',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadNovels(refresh: true),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 24,
        ),
        itemCount: _novels.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _novels.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final novel = _novels[index];
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
              );
            },
          );
        },
      ),
    );
  }
}

class NovelSearchDelegate extends SearchDelegate {
  final Function(String) onSearch;
  final NovelRepository novelRepository;
  List<String> _searchHistory = [];
  bool _isLoading = true;
  
  NovelSearchDelegate({
    required this.onSearch,
    required this.novelRepository,
  }) {
    _loadSearchHistory();
  }
  
  Future<void> _loadSearchHistory() async {
    _isLoading = true;
    _searchHistory = await _getSearchHistory();
    _isLoading = false;
  }

  @override
  String get searchFieldLabel => 'Tìm kiếm truyện...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      _saveSearchQuery(query);
      
      // Navigate to search screen instead of updating the current screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreen(
              novelRepository: novelRepository,
              initialQuery: query,
            ),
          ),
        ).then((_) {
          close(context, null);
        });
      });
    }
    
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      if (_isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (_searchHistory.isEmpty) {
        return const Center(
          child: Text(
            'Không có lịch sử tìm kiếm',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tìm kiếm gần đây',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                if (_searchHistory.isNotEmpty)
                  TextButton(
                    onPressed: () async {
                      await _clearSearchHistory();
                      _searchHistory = [];
                      showSearch(
                        context: context,
                        delegate: NovelSearchDelegate(
                          onSearch: onSearch,
                          novelRepository: novelRepository,
                        ),
                      );
                      close(context, null);
                    },
                    child: const Text('Xóa'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchHistory.length,
              itemBuilder: (context, index) {
                final term = _searchHistory[index];
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(term),
                  trailing: IconButton(
                    icon: const Icon(Icons.call_made, size: 16),
                    onPressed: () {
                      query = term;
                      showResults(context);
                    },
                  ),
                  onTap: () {
                    query = term;
                    showResults(context);
                  },
                );
              },
            ),
          ),
        ],
      );
    } else {
      final suggestedCategories = [
        'Tiên hiệp', 'Kiếm hiệp', 'Ngôn tình', 'Đô thị', 'Huyền huyễn', 'Xuyên không'
      ].where((category) => category.toLowerCase().contains(query.toLowerCase())).toList();
      
      return ListView.builder(
        itemCount: suggestedCategories.length,
        itemBuilder: (context, index) {
          final suggestion = suggestedCategories[index];
          return ListTile(
            leading: const Icon(Icons.category),
            title: Text(suggestion),
            subtitle: const Text('Thể loại'),
            onTap: () {
              query = suggestion;
              showResults(context);
            },
          );
        },
      );
    }
  }
  
  Future<List<String>> _getSearchHistory() async {
    final novelLocalDataSource = (novelRepository as NovelRepositoryImpl).localDataSource;
    return await novelLocalDataSource.getSearchHistory();
  }
  
  Future<void> _saveSearchQuery(String query) async {
    final novelLocalDataSource = (novelRepository as NovelRepositoryImpl).localDataSource;
    await novelLocalDataSource.addSearchHistory(query);
  }
  
  Future<void> _clearSearchHistory() async {
    final novelLocalDataSource = (novelRepository as NovelRepositoryImpl).localDataSource;
    await novelLocalDataSource.clearSearchHistory();
  }
} 