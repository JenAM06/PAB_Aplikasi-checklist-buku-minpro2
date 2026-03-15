import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';

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
  bool _isSaving = false;

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

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    if (_genres.isEmpty) {
      _showSnackbar('Tambahkan minimal satu genre!', isError: true);
      return;
    }

    final total = int.tryParse(_totalPagesCtrl.text) ?? 0;
    final current = int.tryParse(_currentPageCtrl.text) ?? 0;

    if (total <= 0) {
      _showSnackbar('Total halaman wajib diisi!', isError: true);
      return;
    }

    if (current > total) {
      _showSnackbar(
        'Halaman sekarang tidak boleh melebihi total halaman!',
        isError: true,
      );
      return;
    }

    setState(() => _isSaving = true);

    final provider = context.read<BookProvider>();
    final book = Book(
      id: _isEditing ? widget.bookToEdit!.id : '',
      title: _titleCtrl.text.trim(),
      author: _authorCtrl.text.trim(),
      genres: List<String>.from(_genres),
      notes: _notesCtrl.text.trim(),
      rating: _rating,
      totalPages: total,
      currentPage: current,
    );

    if (_isEditing) {
      await provider.updateBook(book);
    } else {
      await provider.addBook(book);
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    Navigator.pop(context);
    _showSnackbar(
      _isEditing ? 'Buku berhasil diperbarui!' : 'Buku berhasil ditambahkan!',
    );
  }

  void _showSnackbar(String message, {bool isError = false}) {
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : scheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        title: Text(
          _isEditing ? 'Edit Buku' : 'Tambah Buku',
          style: TextStyle(
            color: scheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // TextField 1: Judul
            _buildLabel('Judul Buku', scheme),
            _buildTextField(
              controller: _titleCtrl,
              hint: 'Contoh: Laskar Pelangi',
              icon: Icons.title,
              scheme: scheme,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Judul wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            // TextField 2: Penulis
            _buildLabel('Penulis', scheme),
            _buildTextField(
              controller: _authorCtrl,
              hint: 'Contoh: Andrea Hirata',
              icon: Icons.person_outline,
              scheme: scheme,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Penulis wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            // TextField 3: Genre (tag input)
            _buildLabel('Genre', scheme),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _genreInputCtrl,
                    style: TextStyle(color: scheme.onSurface),
                    onFieldSubmitted: (_) => _tambahGenre(),
                    decoration: InputDecoration(
                      hintText: 'Ketik genre, lalu tekan +',
                      hintStyle: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.3),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.category_outlined,
                        color: scheme.primary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: scheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: scheme.onSurface.withValues(alpha: 0.1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: scheme.onSurface.withValues(alpha: 0.1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: scheme.primary),
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
                      color: scheme.primary,
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
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: scheme.primary.withValues(alpha: 0.2),
                        side: BorderSide(color: scheme.primary, width: 1),
                        deleteIcon: Icon(
                          Icons.close,
                          size: 14,
                          color: scheme.onSurface.withValues(alpha: 0.5),
                        ),
                        onDeleted: () => setState(() => _genres.remove(g)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 20),

            // TextField 4 & 5: Halaman
            _buildLabel('Halaman', scheme),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _totalPagesCtrl,
                    hint: 'Total halaman',
                    icon: Icons.book_outlined,
                    scheme: scheme,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _currentPageCtrl,
                    hint: 'Halaman ke-',
                    icon: Icons.my_location_outlined,
                    scheme: scheme,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Rating Bintang
            _buildLabel('Rating', scheme),
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
            _buildLabel('Catatan / Ulasan', scheme),
            Container(
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: scheme.onSurface.withValues(alpha: 0.1),
                ),
              ),
              child: TextFormField(
                controller: _notesCtrl,
                maxLines: 4,
                style: TextStyle(color: scheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Tulis ulasan atau catatan...',
                  hintStyle: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.3),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Simpan
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  disabledBackgroundColor: scheme.primary.withValues(
                    alpha: 0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
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

  Widget _buildLabel(String text, ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: scheme.onSurface.withValues(alpha: 0.7),
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
    required ColorScheme scheme,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: TextStyle(color: scheme.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: scheme.onSurface.withValues(alpha: 0.3),
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: scheme.primary, size: 20),
        filled: true,
        fillColor: scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: scheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: scheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary),
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
