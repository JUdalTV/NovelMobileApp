import 'package:flutter/material.dart';
import '../../../domain/entities/novel.dart';
import '../../../domain/repositories/novel_repository.dart';
import '../novel/novel_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final NovelRepository novelRepository;
  final String? initialQuery;

  const SearchScreen({
    super.key,
    required this.novelRepository,
    this.initialQuery,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Novel> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    
    // If there's an initial query, set it and search immediately
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _searchController.text = widget.initialQuery!;
      _searchNovels(widget.initialQuery!);
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    
    // Don't perform search on every character - debounce
    Future.delayed(const Duration(milliseconds: 500), () {
      // Only search if the text is still the same after the delay
      if (_searchController.text.isNotEmpty && mounted) {
        _searchNovels(_searchController.text);
      }
    });
  }

  Future<void> _searchNovels(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await widget.novelRepository.searchNovels(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Tìm kiếm truyện...',
            border: InputBorder.none,
          ),
          autofocus: widget.initialQuery == null,
          onSubmitted: (query) => _searchNovels(query),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _searchResults.isEmpty
                  ? const Center(child: Text('Không tìm thấy kết quả'))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final novel = _searchResults[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              novel.coverImage ?? 'https://via.placeholder.com/50x70',
                              width: 50,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 50,
                                  height: 70,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image),
                                );
                              },
                            ),
                          ),
                          title: Text(novel.title ?? 'Không có tiêu đề'),
                          subtitle: Text(novel.author ?? 'Tác giả chưa biết'),
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