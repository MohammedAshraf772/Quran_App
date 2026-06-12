import 'package:flutter/material.dart';
import 'package:quran_app/features/bookmark/bookmark_model.dart';

import '../../../../core/services/local_storage_service.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<BookmarkModel> bookmarks = [];

  @override
  void initState() {
    super.initState();
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    bookmarks = await LocalStorageService.getBookmarks();

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body:
          bookmarks.isEmpty
              ? const Center(child: Text('No Saved Surahs'))
              : ListView.builder(
                itemCount: bookmarks.length,
                itemBuilder: (context, index) {
                  final item = bookmarks[index];

                  return ListTile(
                    title: Text(item.surahName),
                    subtitle: Text(item.englishName),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await LocalStorageService.removeBookmark(
                          item.surahNumber,
                        );

                        loadBookmarks();
                      },
                    ),
                  );
                },
              ),
    );
  }
}
