import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class BookProvider extends ChangeNotifier {
  final BookService _service = BookService();

  List<Book> _books = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Book> get books => List.unmodifiable(_books);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void clearBooks() {
    _books = [];
    _errorMessage = null;
    notifyListeners();
  }

  // READ
  Future<void> fetchBooks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _books = await _service.fetchBooks();
    } catch (e) {
      _errorMessage = 'Gagal memuat buku: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE
  Future<void> addBook(Book book) async {
    try {
      final newBook = await _service.addBook(book);
      _books.insert(0, newBook);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal menambah buku: $e';
      notifyListeners();
    }
  }

  // UPDATE
  Future<void> updateBook(Book book) async {
    try {
      final updated = await _service.updateBook(book);
      final i = _books.indexWhere((b) => b.id == updated.id);
      if (i != -1) {
        _books[i] = updated;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Gagal memperbarui buku: $e';
      notifyListeners();
    }
  }

  // DELETE
  Future<void> deleteBook(String id) async {
    try {
      await _service.deleteBook(id);
      _books.removeWhere((b) => b.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal menghapus buku: $e';
      notifyListeners();
    }
  }
}
