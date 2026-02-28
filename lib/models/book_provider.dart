import 'package:flutter/foundation.dart';
import 'book.dart';

class BookProvider extends ChangeNotifier {
  final List<Book> _books = [];
  List<Book> get books => List.unmodifiable(_books);

  void addBook(Book book) {
    _books.add(book);
    notifyListeners();
  }

  void updateBook(Book updated) {
    final i = _books.indexWhere((b) => b.id == updated.id);
    if (i != -1) {
      _books[i] = updated;
      notifyListeners();
    }
  }

  void deleteBook(String id) {
    _books.removeWhere((b) => b.id == id);
    notifyListeners();
  }
}
