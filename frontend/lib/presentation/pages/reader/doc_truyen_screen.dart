import 'package:flutter/material.dart';
import '../../../domain/entities/chapter.dart';

class DocTruyenScreen extends StatefulWidget {
  final Chapter chapter;

  const DocTruyenScreen({
    Key? key,
    required this.chapter,
  }) : super(key: key);

  @override
  State<DocTruyenScreen> createState() => _DocTruyenScreenState();
}

class _DocTruyenScreenState extends State<DocTruyenScreen> {
  double _fontSize = 18.0;
  double _lineHeight = 1.5;
  Color _backgroundColor = Colors.white;
  Color _textColor = Colors.black87;
  bool _showSettings = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _textColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: _textColor),
            onPressed: () {
              setState(() {
                _showSettings = !_showSettings;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Chapter Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chapter.title ?? 'Chương chưa đặt tên',
                  style: TextStyle(
                    fontSize: _fontSize + 4,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.chapter.content ?? 'Chưa có nội dung.',
                  style: TextStyle(
                    fontSize: _fontSize,
                    height: _lineHeight,
                    color: _textColor,
                  ),
                ),
              ],
            ),
          ),

          // Reading Settings Panel
          if (_showSettings)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: _backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Font Size Slider
                    Row(
                      children: [
                        const Icon(Icons.text_fields),
                        Expanded(
                          child: Slider(
                            value: _fontSize,
                            min: 14,
                            max: 24,
                            divisions: 10,
                            label: _fontSize.round().toString(),
                            onChanged: (value) {
                              setState(() {
                                _fontSize = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Line Height Slider
                    Row(
                      children: [
                        const Icon(Icons.format_line_spacing),
                        Expanded(
                          child: Slider(
                            value: _lineHeight,
                            min: 1.0,
                            max: 2.0,
                            divisions: 10,
                            label: _lineHeight.toStringAsFixed(1),
                            onChanged: (value) {
                              setState(() {
                                _lineHeight = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Theme Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildThemeButton(
                          Colors.white,
                          Colors.black87,
                          'Sáng',
                        ),
                        _buildThemeButton(
                          const Color(0xFFF5E6D3),
                          const Color(0xFF2C1810),
                          'Vàng nhạt',
                        ),
                        _buildThemeButton(
                          Colors.black,
                          Colors.white70,
                          'Tối',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  // TODO: Navigate to previous chapter
                },
              ),
              Text(
                'Chương ${widget.chapter.chapterNumber ?? 1}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  // TODO: Navigate to next chapter
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeButton(Color bgColor, Color txtColor, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _backgroundColor = bgColor;
          _textColor = txtColor;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            color: _backgroundColor == bgColor ? Colors.blue : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: txtColor,
            fontWeight: _backgroundColor == bgColor ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
} 