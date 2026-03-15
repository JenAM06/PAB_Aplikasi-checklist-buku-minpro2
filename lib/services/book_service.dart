import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/book.dart';

class BookService {
  final _client = Supabase.instance.client;

  // Ambil user_id yang sedang login
  String get _userId {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User belum login');
    return user.id;
  }

  // READ — ambil buku milik user yang login saja
  Future<List<Book>> fetchBooks() async {
    final data = await _client
        .from('books')
        .select()
        .eq('user_id', _userId)
        .order('created_at', ascending: false);

    return data.map((e) => Book.fromJson(e)).toList();
  }

  // CREATE — tambah user_id saat insert
  Future<Book> addBook(Book book) async {
    final data = await _client
        .from('books')
        .insert({
          ...book.toJson(),
          'user_id': _userId, // tambahkan user_id
        })
        .select()
        .single();

    return Book.fromJson(data);
  }

  // UPDATE — pastikan hanya bisa update buku milik sendiri
  Future<Book> updateBook(Book book) async {
    final data = await _client
        .from('books')
        .update(book.toJson())
        .eq('id', book.id)
        .eq('user_id', _userId)
        .select()
        .single();

    return Book.fromJson(data);
  }

  // DELETE — pastikan hanya bisa hapus buku milik sendiri
  Future<void> deleteBook(String id) async {
    await _client.from('books').delete().eq('id', id).eq('user_id', _userId);
  }
}
