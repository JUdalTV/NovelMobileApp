import 'package:flutter/material.dart';
import '../../../domain/entities/novel.dart';
import '../../../domain/entities/chapter.dart';
import '../../../domain/repositories/novel_repository.dart';

class ChapterScreen extends StatefulWidget {
  final Novel novel;
  final Chapter chapter;
  final NovelRepository novelRepository;

  const ChapterScreen({
    super.key,
    required this.novel,
    required this.chapter,
    required this.novelRepository,
  });

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  late Chapter _chapter;
  bool _isLoading = false;
  String? _error;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _chapter = widget.chapter;
    _currentIndex = widget.novel.chapters?.indexWhere((c) => c.id == widget.chapter.id) ?? 0;
    _loadChapterContent();
  }

  Future<void> _loadChapterContent() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      print('Loading chapter content for novel ${widget.novel.id}, chapter number: ${_chapter.chapterNumber}');
      
      // Kiểm tra nếu chapterNumber chưa được set đúng
      final chapterNumber = _chapter.chapterNumber ?? 1;
      
      final chapter = await widget.novelRepository.getChapterByNovelAndNumber(
        widget.novel.id!,
        chapterNumber,
      );
      
      print('Chapter loaded: ${chapter.title}, content length: ${chapter.content?.length ?? 0}');
      
      setState(() {
        _chapter = chapter;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading chapter: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _goToChapter(int index) async {
    if (index < 0 || index >= (widget.novel.chapters?.length ?? 0)) return;

    setState(() {
      _currentIndex = index;
      _isLoading = true;
      _error = null;
    });

    try {
      final chapter = widget.novel.chapters![index];
      final fullChapter = await widget.novelRepository.getChapterByNovelAndNumber(
        widget.novel.id!,
        chapter.chapterNumber ?? 0,
      );
      setState(() {
        _chapter = fullChapter;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_chapter.title ?? 'Untitled Chapter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Danh sách chương',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Container(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: ListView(
                    children: [
                      Text(
                        widget.novel.title ?? 'Untitled Novel',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _chapter.title ?? 'Untitled Chapter',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _chapter.content ?? 'Không có nội dung.',
                        style: const TextStyle(fontSize: 18, height: 1.7),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: widget.novel.chapters != null && widget.novel.chapters!.length > 1
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: _currentIndex > 0
                        ? () => _goToChapter(_currentIndex - 1)
                        : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Trước'),
                  ),
                  Text('Chương ${_currentIndex + 1}/${widget.novel.chapters!.length}'),
                  ElevatedButton.icon(
                    onPressed: _currentIndex < widget.novel.chapters!.length - 1
                        ? () => _goToChapter(_currentIndex + 1)
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Sau'),
                  ),
                ],
              ),
            )
          : null,
    );
  }
} 