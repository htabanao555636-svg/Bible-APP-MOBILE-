import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/models/bookmark_model.dart';
import 'package:bible_app/services/bible_service.dart';
import 'package:bible_app/services/bookmark_service.dart';
import 'package:bible_app/utils/verse_reference.dart';

/// Bookmark toggle for any single verse, given a reference like "1 Peter 5:7".
class BookmarkButton extends StatefulWidget {
  final String reference;
  final String fallbackText;

  const BookmarkButton({
    super.key,
    required this.reference,
    required this.fallbackText,
  });

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  final _bibleService = BibleService();
  final _bookmarkService = BookmarkService();
  StreamSubscription<List<BookmarkModel>>? _sub;

  ParsedReference? _parsed;
  Set<String> _bookmarkedIds = {};

  @override
  void initState() {
    super.initState();
    _resolve();
    _sub = _bookmarkService.watchBookmarks().listen((list) {
      if (!mounted) return;
      setState(() => _bookmarkedIds = list.map((b) => b.id).toSet());
    });
  }

  @override
  void didUpdateWidget(covariant BookmarkButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reference != widget.reference) {
      _parsed = null;
      _resolve();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _resolve() async {
    final reference = widget.reference;
    final parsed = await VerseReference.parse(reference, _bibleService);
    if (!mounted || reference != widget.reference) return;
    setState(() => _parsed = parsed);
  }

  String? get _id {
    final p = _parsed;
    if (p == null) return null;
    return BookmarkModel.makeId(p.bookId, p.chapter, p.verse);
  }

  void _message(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _toggle() async {
    final p = _parsed ?? await VerseReference.parse(widget.reference, _bibleService);
    if (p == null) {
      if (mounted) _message('This verse cannot be bookmarked.');
      return;
    }

    final id = BookmarkModel.makeId(p.bookId, p.chapter, p.verse);
    final label = '${p.bookName} ${p.chapter}:${p.verse}';

    try {
      if (_bookmarkedIds.contains(id)) {
        await _bookmarkService.remove(id);
        if (mounted) _message('Removed $label from bookmarks');
      } else {
        // Save the exact KJV text from the Bible file when available
        final text =
            await _bibleService.loadVerse(p.bookId, p.chapter, p.verse) ??
                widget.fallbackText;
        await _bookmarkService.add(
          bookId: p.bookId,
          bookName: p.bookName,
          chapter: p.chapter,
          verse: p.verse,
          text: text,
        );
        if (mounted) _message('Bookmarked $label');
      }
    } catch (_) {
      if (mounted) _message('Could not update bookmark. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarked = _id != null && _bookmarkedIds.contains(_id);

    return IconButton(
      tooltip: bookmarked ? 'Remove bookmark' : 'Add to bookmarks',
      icon: Icon(
        bookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: bookmarked ? AppColors.primaryGreen : AppColors.textMuted,
      ),
      onPressed: _toggle,
    );
  }
}
