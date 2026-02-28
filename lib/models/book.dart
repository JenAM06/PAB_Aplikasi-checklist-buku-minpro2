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

    final value = currentPage / totalPages;
    return value.clamp(0.0, 1.0);
  }
}
