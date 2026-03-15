import 'dart:convert';

class Book {
  final String id;
  String title;
  String author;
  List<String> genres;
  String notes;
  double rating;
  int totalPages;
  int currentPage;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genres,
    this.notes = '',
    this.rating = 0,
    this.totalPages = 0,
    this.currentPage = 0,
  });

  double get progress {
    if (totalPages <= 0) return 0;
    return (currentPage / totalPages).clamp(0.0, 1.0);
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    List<String> parseGenres(dynamic value) {
      if (value == null || value.toString().isEmpty) return [];
      try {
        return List<String>.from(jsonDecode(value.toString()));
      } catch (_) {
        return [];
      }
    }

    return Book(
      id: json['id'].toString(),
      title: json['title'].toString(),
      author: json['author'].toString(),
      genres: parseGenres(json['genres']),
      notes: json['notes']?.toString() ?? '',
      rating: (json['rating'] as num).toDouble(),
      totalPages: (json['total_pages'] as num).toInt(),
      currentPage: (json['current_page'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'genres': jsonEncode(genres),
      'notes': notes,
      'rating': rating,
      'total_pages': totalPages,
      'current_page': currentPage,
    };
  }
}
