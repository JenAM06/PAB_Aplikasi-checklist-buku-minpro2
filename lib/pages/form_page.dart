import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../models/book_provider.dart';

class FormPage extends StatefulWidget {
  final Book? bookToEdit;
  const FormPage({super.key, this.bookToEdit});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleCtrl;
  late TextEditingController _authorCtrl;
  late TextEditingController _genreInputCtrl;
  late TextEditingController _notesCtrl;
  late TextEditingController _totalPagesCtrl;
  late TextEditingController _currentPageCtrl;

  List<String> _genres = [];
  double _rating = 0;

  bool get _isEditing => widget.bookToEdit != null;

  @override
  void initState() {
    super.initState();
    final b = widget.bookToEdit;
    _titleCtrl = TextEditingController(text: b?.title ?? '');
    _authorCtrl = TextEditingController(text: b?.author ?? '');
    _genreInputCtrl = TextEditingController();
    _notesCtrl = TextEditingController(text: b?.notes ?? '');
    _totalPagesCtrl = TextEditingController(
      text: b != null && b.totalPages > 0 ? '${b.totalPages}' : '',
    );
    _currentPageCtrl = TextEditingController(
      text: b != null && b.currentPage > 0 ? '${b.currentPage}' : '',
    );
    _genres = b != null ? List<String>.from(b.genres) : [];
    _rating = b?.rating ?? 0;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _genreInputCtrl.dispose();
    _notesCtrl.dispose();
    _totalPagesCtrl.dispose();
    _currentPageCtrl.dispose();
    super.dispose();
  }

  void _tambahGenre() {
    final text = _genreInputCtrl.text.trim();
    if (text.isEmpty) return;
    if (_genres.contains(text)) {
      _genreInputCtrl.clear();
      return;
    }
    setState(() {
      _genres.add(text);
      _genreInputCtrl.clear();
    });
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    // Validasi genre tidak boleh kosong
    if (_genres.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tambahkan minimal satu genre!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // Parse halaman sekali, pakai ulang di bawah
    final total = int.tryParse(_totalPagesCtrl.text) ?? 0;
    final current = int.tryParse(_currentPageCtrl.text) ?? 0;

    // Validasi halaman tidak boleh melebihi total
    if (total > 0 && current > total) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Halaman tidak boleh melebihi total halaman!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final provider = context.read<BookProvider>();
    final book = Book(
      id: _isEditing
          ? widget.bookToEdit!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      author: _authorCtrl.text.trim(),
      genres: List<String>.from(_genres),
      notes: _notesCtrl.text.trim(),
      rating: _rating,
      totalPages: total,
      currentPage: current,
    );

    if (_isEditing) {
      provider.updateBook(book);
    } else {
      provider.addBook(book);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? 'Buku berhasil diperbarui!'
              : 'Buku berhasil ditambahkan!',
        ),
        backgroundColor: const Color(0xFF9B6BFF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1530),
        title: Text(
          _isEditing ? 'Edit Buku' : 'Tambah Buku',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // TextField 1: Judul
            _buildLabel('Judul Buku'),
            _buildTextField(
              controller: _titleCtrl,
              hint: 'Contoh: Laskar Pelangi',
              icon: Icons.title,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Judul wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            // TextField 2: Penulis
            _buildLabel('Penulis'),
            _buildTextField(
              controller: _authorCtrl,
              hint: 'Contoh: Andrea Hirata',
              icon: Icons.person_outline,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Penulis wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            // TextField 3: Genre (tag input)
            _buildLabel('Genre'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _genreInputCtrl,
                    style: const TextStyle(color: Colors.white),
                    onFieldSubmitted: (_) => _tambahGenre(),
                    decoration: InputDecoration(
                      hintText: 'Ketik genre, lalu tekan +',
                      hintStyle: const TextStyle(
                        color: Colors.white30,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.category_outlined,
                        color: Color(0xFF9B6BFF),
                        size: 20,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1A1530),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF9B6BFF)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _tambahGenre,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9B6BFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_genres.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _genres
                    .map(
                      (g) => Chip(
                        label: Text(
                          g,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: const Color(
                          0xFF9B6BFF,
                        ).withValues(alpha: 0.2),
                        side: const BorderSide(
                          color: Color(0xFF9B6BFF),
                          width: 1,
                        ),
                        deleteIcon: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white54,
                        ),
                        onDeleted: () => setState(() => _genres.remove(g)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 20),

            // TextField 4 & 5: Halaman
            _buildLabel('Halaman'),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _totalPagesCtrl,
                    hint: 'Total halaman',
                    icon: Icons.book_outlined,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _currentPageCtrl,
                    hint: 'Halaman terakhir yang dibaca',
                    icon: Icons.book_outlined,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Rating Bintang
            _buildLabel('Rating'),
            Row(
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => setState(() => _rating = i + 1.0),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      i < _rating ? Icons.star : Icons.star_border,
                      color: const Color(0xFFFFD700),
                      size: 34,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // TextField 6: Catatan
            _buildLabel('Catatan / Ulasan'),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1530),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: TextFormField(
                controller: _notesCtrl,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Tulis ulasan atau catatan...',
                  hintStyle: TextStyle(color: Colors.white30),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(14),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Simpan
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9B6BFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _isEditing ? 'Simpan Perubahan' : 'Tambah ke Koleksi',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF9B6BFF), size: 20),
        filled: true,
        fillColor: const Color(0xFF1A1530),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF9B6BFF)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}
