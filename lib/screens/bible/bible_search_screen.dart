import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/models/bible_search_result.dart';
import 'package:bible_app/services/bible_service.dart';
import 'package:bible_app/utils/verse_reference.dart';
import 'package:bible_app/screens/bible/chapter_reader_screen.dart';

class BibleSearchScreen extends StatefulWidget {
  const BibleSearchScreen({super.key});

  @override
  State<BibleSearchScreen> createState() => _BibleSearchScreenState();
}

class _BibleSearchScreenState extends State<BibleSearchScreen> {
  final _bibleService = BibleService();
  final _controller = TextEditingController();
  Timer? _debounce;

  String _query = '';
  bool _searching = false;
  List<BibleSearchResult>? _results;
  ParsedReference? _directMatch;
  String? _directMatchText;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () => _runSearch(value));
    setState(() {}); // shows/hides the clear button
  }

  Future<void> _runSearch(String value) async {
    final trimmed = value.trim();

    if (trimmed.length < 2) {
      setState(() {
        _query = trimmed;
        _results = null;
        _directMatch = null;
        _directMatchText = null;
        _searching = false;
      });
      return;
    }

    setState(() {
      _query = trimmed;
      _searching = true;
    });

    final parsed = await VerseReference.parse(trimmed, _bibleService);
    String? directText;
    if (parsed != null) {
      directText = await _bibleService.loadVerse(parsed.bookId, parsed.chapter, parsed.verse);
    }

    final results = await _bibleService.search(trimmed);

    if (!mounted || _controller.text.trim() != trimmed) return;

    setState(() {
      _directMatch = directText != null ? parsed : null;
      _directMatchText = directText;
      _results = results;
      _searching = false;
    });
  }

  void _openVerse(String bookId, String bookName, int chapter, int verse) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChapterReaderScreen(
          bookId: bookId,
          bookName: bookName,
          initialChapter: chapter,
          focusVerse: verse,
        ),
      ),
    );
  }

  List<TextSpan> _highlighted(String text, String query) {
    if (query.isEmpty) return [TextSpan(text: text)];

    final spans = <TextSpan>[];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    var start = 0;
    var index = lowerText.indexOf(lowerQuery);

    while (index != -1) {
      if (index > start) spans.add(TextSpan(text: text.substring(start, index)));
      spans.add(TextSpan(
        text: text.substring(index, index + lowerQuery.length),
        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
      ));
      start = index + lowerQuery.length;
      index = lowerText.indexOf(lowerQuery, start);
    }
    if (start < text.length) spans.add(TextSpan(text: text.substring(start)));
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onChanged,
          style: TextStyle(color: AppColors.textDark, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search the Bible...',
            hintStyle: TextStyle(color: AppColors.textMuted),
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _controller.clear();
                _debounce?.cancel();
                setState(() {
                  _query = '';
                  _results = null;
                  _directMatch = null;
                  _directMatchText = null;
                });
              },
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_query.length < 2) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Type at least 2 letters to search verses,\nor enter a reference like "John 3:16".',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, height: 1.5),
          ),
        ),
      );
    }

    if (_searching) {
      return const Center(child: CircularProgressIndicator());
    }

    final results = _results ?? [];
    if (results.isEmpty && _directMatch == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No verses found for "$_query".',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_directMatch != null && _directMatchText != null) ...[
          Text('Go to reference',
              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          _ResultCard(
            reference:
                '${_directMatch!.bookName} ${_directMatch!.chapter}:${_directMatch!.verse}',
            spans: [TextSpan(text: _directMatchText)],
            onTap: () => _openVerse(_directMatch!.bookId, _directMatch!.bookName,
                _directMatch!.chapter, _directMatch!.verse),
          ),
          const SizedBox(height: 20),
        ],
        if (results.isNotEmpty) ...[
          Text('${results.length} result${results.length == 1 ? '' : 's'}',
              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          ...results.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ResultCard(
                  reference: '${r.bookName} ${r.chapter}:${r.verse}',
                  spans: _highlighted(r.text, _query),
                  onTap: () => _openVerse(r.bookId, r.bookName, r.chapter, r.verse),
                ),
              )),
        ],
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String reference;
  final List<TextSpan> spans;
  final VoidCallback onTap;

  const _ResultCard({required this.reference, required this.spans, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardCream,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reference,
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
            const SizedBox(height: 6),
            RichText(
              text: TextSpan(
                style: TextStyle(color: AppColors.textDark, height: 1.5),
                children: spans,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
