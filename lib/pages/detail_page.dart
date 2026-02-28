import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book_provider.dart';
import 'form_page.dart';

class DetailPage extends StatelessWidget {
  final String bookId;
  const DetailPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final books = context.watch<BookProvider>().books;
    final bookIndex = books.indexWhere((b) => b.id == bookId);

    // Jika buku sudah dihapus → kembali otomatis
    if (bookIndex == -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });

      return const Scaffold(backgroundColor: Color(0xFF0F0B1F));
    }

    final book = books[bookIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0F0B1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1530),
        title: const Text(
          'Detail Buku',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF9B6BFF)),
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            book.author,
            style: const TextStyle(color: Colors.white60, fontSize: 16),
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
                      color: const Color(0xFF9B6BFF).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      g,
                      style: const TextStyle(
                        color: Color(0xFF9B6BFF),
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 20),
          const Divider(color: Colors.white12),
          const SizedBox(height: 16),

          // Progress membaca
          if (book.totalPages > 0) ...[
            const Text(
              'Progress Membaca',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${book.currentPage}',
                  style: const TextStyle(
                    color: Color(0xFF6BFFD8),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' / ${book.totalPages} halaman',
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const Spacer(),
                Text(
                  '${(book.progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Colors.white,
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
                backgroundColor: Colors.white10,
                valueColor: const AlwaysStoppedAnimation(Color(0xFF6BFFD8)),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Rating
          const Text(
            'Rating',
            style: TextStyle(
              color: Colors.white70,
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
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),

          // Catatan
          if (book.notes.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'Catatan',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1530),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Text(
                book.notes,
                style: const TextStyle(color: Colors.white70, height: 1.6),
              ),
            ),
          ],

          const SizedBox(height: 32),

          // Tombol hapus dengan konfirmasi
          OutlinedButton.icon(
            onPressed: () {
              _konfirmasiHapus(context, book);
            },
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

  void _konfirmasiHapus(BuildContext context, dynamic book) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1A1530),
        title: const Text('Hapus Buku?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Yakin ingin menghapus "${book.title}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // tutup dialog dulu
              context.read<BookProvider>().deleteBook(book.id);
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
