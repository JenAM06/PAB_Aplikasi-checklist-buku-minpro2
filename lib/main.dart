import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/book_provider.dart';
import 'pages/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => BookProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookShelf',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          surface: const Color(0xFF1A1530),
          primary: const Color(0xFF9B6BFF),
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0A1A),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
