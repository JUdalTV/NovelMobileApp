import 'package:flutter/material.dart';
import '../../../domain/entities/novel.dart';
import '../../../domain/entities/chapter.dart';
import '../../../domain/repositories/novel_repository.dart';
import 'chapter_screen.dart';

class ChapterListScreen extends StatefulWidget {
  final Novel novel;
  final NovelRepository novelRepository;

  const ChapterListScreen({
    super.key,
    required this.novel,
    required this.novelRepository,
  });

  @override
  State<ChapterListScreen> createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  List<Chapter> _chapters = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadChapters();
  }

  Future<void> _loadChapters() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load chapters directly from API instead of relying on embedded chapters
      final chapters = await widget.novelRepository.getChaptersByNovelId(widget.novel.id!);
      setState(() {
        _chapters = chapters;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      
      // If API call fails, try to use the chapters from novel as fallback
      if (widget.novel.chapters != null && widget.novel.chapters!.isNotEmpty) {
        setState(() {
          _chapters = widget.novel.chapters!;
          _error = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('"${widget.novel.title ?? "Untitled"}"'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadChapters,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : _chapters.isEmpty
                  ? const Center(child: Text('Không có chương nào.'))
                  : RefreshIndicator(
                      onRefresh: _loadChapters,
                      child: ListView.separated(
                        itemCount: _chapters.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final chapter = _chapters[index];
                          return ListTile(
                            title: Text(
                              chapter.title ?? 'Untitled Chapter',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: chapter.createdAt != null
                                ? Text('Ngày đăng: ${chapter.createdAt!.toLocal().toString().split(" ")[0]}')
                                : null,
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChapterScreen(
                                    novel: widget.novel,
                                    chapter: chapter,
                                    novelRepository: widget.novelRepository,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
    );
  }
} 