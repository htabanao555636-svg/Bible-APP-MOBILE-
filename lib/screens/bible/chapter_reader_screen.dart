import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/models/bookmark_model.dart';
import 'package:bible_app/providers/font_size_provider.dart';
import 'package:bible_app/services/bible_service.dart';
import 'package:bible_app/services/bookmark_service.dart';
import 'package:bible_app/widgets/bible/verse_tile.dart';

class ChapterReaderScreen extends StatefulWidget {
  final String bookId;
  final String bookName;
  final int initialChapter;
  final int? focusVerse;

  const ChapterReaderScreen({
    super.key,
    required this.bookId,
    required this.bookName,
    this.initialChapter = 1,
    this.focusVerse,
  });

  @override
  State<ChapterReaderScreen> createState() => _ChapterReaderScreenState();
}

class _ChapterReaderScreenState extends State<ChapterReaderScreen> {
  final _bibleService = BibleService();
  final _bookmarkService = BookmarkService();
  StreamSubscription<List<BookmarkModel>>? _bookmarkSub;
  Timer? _highlightTimer;

  List<List<String>>? _chapters;
  Set<String> _bookmarkedIds = {};
  int _currentChapter = 1;
  bool _loading = true;
  int? _highlightVerse;
  final Map<int, GlobalKey> _verseKeys = {};

  @override
  void initState() {
    super.initState();
    _currentChapter = widget.initialChapter;
    _load();

    _bookmarkSub = _bookmarkService.watchBookmarks().listen((list) {
      if (!mounted) return;
      setState(() => _bookmarkedIds = list.map((b) => b.id).toSet());
    });
  }

  @override
  void dispose() {
    _bookmarkSub?.cancel();
    _highlightTimer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final chapters = await _bibleService.loadBookChapters(widget.bookId);
    if (!mounted) return;

    setState(() {
      _chapters = chapters;
      _loading = false;
      if (widget.focusVerse != null) _highlightVerse = widget.focusVerse;
    });

    if (chapters != null && widget.focusVerse != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToFocusVerse());
      _highlightTimer = Timer(const Duration(milliseconds: 2500), () {
        if (mounted) setState(() => _highlightVerse = null);
      });
    }
  }

  void _scrollToFocusVerse() {
    final verse = widget.focusVerse;
    if (verse == null) return;
    final ctx = _verseKeys[verse]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 400),
        alignment: 0.25,
      );
    }
  }

  GlobalKey _keyFor(int verse) => _verseKeys.putIfAbsent(verse, () => GlobalKey());

  void _goToChapter(int chapter) {
    if (_chapters == null) return;
    if (chapter < 1 || chapter > _chapters!.length) return;

    _highlightTimer?.cancel();
    setState(() {
      _currentChapter = chapter;
      _verseKeys.clear();
      _highlightVerse = null;
    });
  }

  String _idFor(int verse) => BookmarkModel.makeId(widget.bookId, _currentChapter, verse);

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _toggleBookmark(int verse, String text) async {
    final reference = '${widget.bookName} $_currentChapter:$verse';
    final isBookmarked = _bookmarkedIds.contains(_idFor(verse));

    try {
      if (isBookmarked) {
        await _bookmarkService.remove(_idFor(verse));
        if (mounted) _showMessage('Removed $reference from bookmarks');
      } else {
        await _bookmarkService.add(
          bookId: widget.bookId,
          bookName: widget.bookName,
          chapter: _currentChapter,
          verse: verse,
          text: text,
        );
        if (mounted) _showMessage('Bookmarked $reference');
      }
    } catch (_) {
      if (mounted) _showMessage('Could not update bookmark. Please try again.');
    }
  }

  void _showVerseSheet(int verse) {
    final text = _chapters![_currentChapter - 1][verse - 1];
    final reference = '${widget.bookName} $_currentChapter:$verse';
    final isBookmarked = _bookmarkedIds.contains(_idFor(verse));

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reference,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 10),
              Text('"$text"', style: const TextStyle(fontSize: 15, height: 1.5)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(isBookmarked
                    ? Icons.bookmark_remove_outlined
                    : Icons.bookmark_add_outlined),
                label: Text(isBookmarked ? 'Remove bookmark' : 'Add to bookmarks'),
                onPressed: () {
                  Navigator.pop(sheetContext);
                  _toggleBookmark(verse, text);
                },
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.copy_outlined),
                  label: const Text('Copy verse'),
                  onPressed: () async {
                    Navigator.pop(sheetContext);
                    await Clipboard.setData(ClipboardData(text: '"$text"\n$reference'));
                    if (mounted) _showMessage('Copied $reference');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFontSizeSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => AnimatedBuilder(
        animation: FontSizeController.instance,
        builder: (context, _) {
          final current = FontSizeController.instance.level;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Text Size',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 16),
                  for (final level in FontSizeLevel.values)
                    RadioListTile<FontSizeLevel>(
                      value: level,
                      groupValue: current,
                      activeColor: AppColors.primaryGreen,
                      title: Text(level.label,
                          style: TextStyle(fontSize: 15 * level.scale)),
                      onChanged: (value) {
                        if (value != null) {
                          FontSizeController.instance.setLevel(value);
                        }
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.bookName),
        actions: [
          IconButton(
            icon: const Text('Aa', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: _showFontSizeSheet,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _chapters == null
              ? _LoadError(bookName: widget.bookName)
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () => _goToChapter(_currentChapter - 1),
                          ),
                          DropdownButton<int>(
                            value: _currentChapter,
                            underline: const SizedBox(),
                            items: List.generate(
                              _chapters!.length,
                              (i) => DropdownMenuItem(
                                  value: i + 1, child: Text('Chapter ${i + 1}')),
                            ),
                            onChanged: (value) {
                              if (value != null) _goToChapter(value);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () => _goToChapter(_currentChapter + 1),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: AnimatedBuilder(
                        animation: FontSizeController.instance,
                        builder: (context, _) {
                          final fontSize = 15 * FontSizeController.instance.scale;
                          return ListView(
                            padding: const EdgeInsets.all(16),
                            children: List.generate(
                                _chapters![_currentChapter - 1].length, (index) {
                              final verse = index + 1;
                              return VerseTile(
                                key: _keyFor(verse),
                                number: verse,
                                text: _chapters![_currentChapter - 1][index],
                                fontSize: fontSize,
                                bookmarked: _bookmarkedIds.contains(_idFor(verse)),
                                highlighted: _highlightVerse == verse,
                                onTap: () => _showVerseSheet(verse),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _LoadError extends StatelessWidget {
  final String bookName;
  const _LoadError({required this.bookName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_outlined, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(
              '$bookName text could not be loaded.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
