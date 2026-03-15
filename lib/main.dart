import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/book_provider.dart';
import 'providers/theme_provider.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'BookShelf',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          surface: const Color(0xFF1A1530),
          primary: const Color(0xFF9B6BFF),
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0A1A),
        useMaterial3: true,
      ),
      // Light Theme
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          surface: Colors.white, // card & input jadi putih bersih
          primary: const Color(0xFF6B3FCC),
          onSurface: const Color(0xFF1A1530), // teks gelap agar kontras
        ),
        scaffoldBackgroundColor: const Color(
          0xFFEFECFF,
        ), // background sedikit ungu
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final event = snapshot.data!.event;
          final session = snapshot.data!.session;

          if (event == AuthChangeEvent.signedIn && session != null) {
            return const HomePage();
          }
          if (event == AuthChangeEvent.signedOut) {
            return const LoginPage();
          }
        }

        // Cek session yang sudah ada
        final currentSession = Supabase.instance.client.auth.currentSession;
        if (currentSession != null) {
          return const HomePage();
        }

        return const LoginPage();
      },
    );
  }
}
