import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/models/bible_book_model.dart';
import 'package:bible_app/services/bible_service.dart';
import 'package:bible_app/screens/bible/chapter_reader_screen.dart';
import 'package:bible_app/screens/bible/bible_search_screen.dart';
import 'package:bible_app/screens/bookmarks/bookmarks_screen.dart';

class BibleBooksScreen extends StatefulWidget {
  const BibleBooksScreen({super.key});

  @override
  State<BibleBooksScreen> createState() => _BibleBooksScreenState();
}

class _BibleBooksScreenState extends State<BibleBooksScreen> {
  final _bibleService = BibleService();
  String _testament = 'old';
  List<BibleBookModel> _books = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final books = await _bibleService.loadBooks();
    setState(() {
      _books = books;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _books.where((b) => b.testament == _testament).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bible'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BibleSearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            tooltip: 'Bookmarks',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BookmarksScreen()),
              );
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _TestamentToggle(
                          label: 'Old Testament',
                          selected: _testament == 'old',
                          onTap: () => setState(() => _testament = 'old'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _TestamentToggle(
                          label: 'New Testament',
                          selected: _testament == 'new',
                          onTap: () => setState(() => _testament = 'new'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final book = filtered[index];
                      return ListTile(
                        title: Text(book.name),
                        trailing: Icon(Icons.chevron_right, color: AppColors.textMuted),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChapterReaderScreen(
                                bookId: book.id,
                                bookName: book.name,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _TestamentToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TestamentToggle({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen : AppColors.cardCream,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textDark,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
