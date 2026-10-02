import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/models/bookmark_model.dart';
import 'package:bible_app/services/bookmark_service.dart';
import 'package:bible_app/screens/bible/chapter_reader_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = BookmarkService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Bookmarks')),
      body: StreamBuilder<List<BookmarkModel>>(
        stream: service.watchBookmarks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Could not load bookmarks.',
                  style: TextStyle(color: AppColors.textMuted)),
            );
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final bookmarks = snapshot.data!;
          if (bookmarks.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No bookmarks yet.\nTap any verse in the Bible and choose "Add to bookmarks".',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted, height: 1.5),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: bookmarks.length,
            separatorBuilder: (_, _) => SizedBox(height: 10),
            itemBuilder: (context, index) {
              final b = bookmarks[index];
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChapterReaderScreen(
                        bookId: b.bookId,
                        bookName: b.bookName,
                        initialChapter: b.chapter,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 14, 8, 14),
                  decoration: BoxDecoration(
                    color: AppColors.cardCream,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              b.reference,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '"${b.text}"',
                              style: TextStyle(height: 1.5),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline,
                            color: AppColors.textMuted),
                        tooltip: 'Remove',
                        onPressed: () => service.remove(b.id),
                      ),
                    ],
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
