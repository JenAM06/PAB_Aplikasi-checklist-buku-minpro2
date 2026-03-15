import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
import '../providers/theme_provider.dart';
import 'detail_page.dart';
import 'form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<BookProvider>().fetchBooks();
    });
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 1,
        shadowColor: scheme.onSurface.withValues(alpha: 0.08),
        title: const Text(
          'Jeje BookShelf',
          style: TextStyle(
            color: Color(0xFF9B6BFF),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDark ? Icons.light_mode : Icons.dark_mode,
              color: scheme.primary,
            ),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: scheme.primary),
            onPressed: _logout,
          ),
        ],
      ),

      body: _buildBody(provider, scheme),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: scheme.primary,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FormPage()),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah Buku',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildBody(BookProvider provider, ColorScheme scheme) {
    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator(color: scheme.primary));
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              color: scheme.onSurface.withValues(alpha: 0.4),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.4),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.read<BookProvider>().fetchBooks(),
              child: Text('Coba Lagi', style: TextStyle(color: scheme.primary)),
            ),
          ],
        ),
      );
    }

    if (provider.books.isEmpty) {
      return Center(
        child: Text(
          'Belum ada buku.\nTambahkan buku pertamamu!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: scheme.onSurface.withValues(alpha: 0.4),
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.books.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '${provider.books.length} buku tersimpan',
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.4),
                fontSize: 13,
              ),
            ),
          );
        }
        return _BookCard(book: provider.books[index - 1]);
      },
    );
  }
}

class _BookCard extends StatelessWidget {
  final Book book;
  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final double progress = book.progress;
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: scheme.surface,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isDark ? 0 : 2,
      shadowColor: scheme.onSurface.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isDark
            ? BorderSide.none
            : BorderSide(
                color: scheme.onSurface.withValues(alpha: 0.08),
                width: 1,
              ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(bookId: book.id)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          book.author,
                          style: TextStyle(
                            color: scheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: scheme.onSurface.withValues(alpha: 0.3),
                      size: 20,
                    ),
                    onPressed: () => _konfirmasiHapus(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: book.genres
                          .map(
                            (g) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: scheme.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: scheme.primary.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                g,
                                style: TextStyle(
                                  color: scheme.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  if (book.rating > 0)
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < book.rating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFFFD700),
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),

              if (book.totalPages > 0) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hal. ${book.currentPage} / ${book.totalPages}',
                      style: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: scheme.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: scheme.onSurface.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation(scheme.primary),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _konfirmasiHapus(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: scheme.surface,
        title: Text('Hapus Buku?', style: TextStyle(color: scheme.onSurface)),
        content: Text(
          'Yakin ingin menghapus "${book.title}"?',
          style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.5)),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<BookProvider>().deleteBook(book.id);
              Navigator.pop(context);
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
