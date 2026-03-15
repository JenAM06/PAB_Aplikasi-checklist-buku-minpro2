import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import 'form_page.dart';
import '../models/book.dart';

class DetailPage extends StatelessWidget {
  final String bookId;
  const DetailPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final books = context.watch<BookProvider>().books;
    final bookIndex = books.indexWhere((b) => b.id == bookId);

    if (bookIndex == -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.canPop(context)) Navigator.pop(context);
      });
      return Scaffold(backgroundColor: scheme.surface);
    }

    final book = books[bookIndex];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 1,
        shadowColor: scheme.onSurface.withValues(alpha: 0.08),
        title: Text(
          'Detail Buku',
          style: TextStyle(
            color: scheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: scheme.onSurface),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: scheme.primary),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FormPage(bookToEdit: book)),
              );
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Judul & Penulis
          Text(
            book.title,
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            book.author,
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.6),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 14),

          // Chips genre
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: book.genres
                .map(
                  (g) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: scheme.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      g,
                      style: TextStyle(
                        color: scheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 20),
          Divider(color: scheme.onSurface.withValues(alpha: 0.1)),
          const SizedBox(height: 16),

          // Progress membaca
          if (book.totalPages > 0) ...[
            Text(
              'Progress Membaca',
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.7),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${book.currentPage}',
                  style: TextStyle(
                    color: scheme.primary,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' / ${book.totalPages} halaman',
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(book.progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: book.progress,
                minHeight: 10,
                backgroundColor: scheme.onSurface.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation(scheme.primary),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Rating
          Text(
            'Rating',
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.7),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ...List.generate(
                5,
                (i) => Icon(
                  i < book.rating ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFD700),
                  size: 28,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                book.rating > 0 ? '${book.rating.toInt()}/5' : 'Belum dirating',
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
              ),
            ],
          ),

          // Catatan
          if (book.notes.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Catatan',
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.7),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: scheme.onSurface.withValues(
                    alpha: isDark ? 0.1 : 0.15,
                  ),
                  width: isDark ? 1 : 1.5,
                ),
              ),
              child: Text(
                book.notes,
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.7),
                  height: 1.6,
                ),
              ),
            ),
          ],

          const SizedBox(height: 32),

          // Tombol hapus
          OutlinedButton.icon(
            onPressed: () => _konfirmasiHapus(context, book),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.redAccent,
              side: const BorderSide(color: Colors.redAccent),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.delete_outline),
            label: const Text(
              'Hapus Buku',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _konfirmasiHapus(BuildContext context, Book book) {
    final scheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: scheme.surface,
        title: Text('Hapus Buku?', style: TextStyle(color: scheme.onSurface)),
        content: Text(
          'Yakin ingin menghapus "${book.title}"?',
          style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Batal',
              style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.5)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await context.read<BookProvider>().deleteBook(book.id);
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
