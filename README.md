# JEJE BookShelf

Aplikasi manajemen koleksi buku pribadi untuk mencatat, melacak progress membaca, dan memberikan rating pada setiap buku yang dimiliki. Data disimpan dan diambil dari database **Supabase** secara real-time.

> Jen Agresia Misti | 2409116007 | A'24 | MINPRO 1 PAB

---

## Struktur Folder
```
lib/
├── main.dart                  ← Setup app, theme & inisialisasi Supabase
├── models/
│   └── book.dart              ← Class Book + fromJson() + toJson()
├── providers/
│   ├── book_provider.dart     ← State management (CRUD)
│   └── theme_provider.dart    ← Light/Dark mode state
├── services/
│   └── book_service.dart      ← Komunikasi dengan Supabase
└── pages/
    ├── home_page.dart         ← Daftar buku + progress bar di kartu
    ├── detail_page.dart       ← Detail buku + progress bar besar
    ├── form_page.dart         ← Form dengan 6 TextField
    ├── login_page.dart        ← Halaman login
    └── register_page.dart     ← Halaman registrasi
```

---

## Fitur Aplikasi

| # | Fitur | Status | Lokasi |
|---|-------|--------|--------|
| 1 | Tambah buku baru ke Supabase | ✅ | `form_page.dart` → `_simpan()` |
| 2 | Tampilkan daftar buku dari Supabase | ✅ | `home_page.dart` → `fetchBooks()` |
| 3 | Edit buku yang ada | ✅ | `form_page.dart` → `_isEditing` |
| 4 | Hapus buku (dengan konfirmasi) | ✅ | `home_page.dart`, `detail_page.dart` → `_konfirmasiHapus()` |
| 5 | Login menggunakan Supabase Auth | ✅ | `login_page.dart` |
| 6 | Register akun baru | ✅ | `register_page.dart` |
| 7 | Logout | ✅ | `home_page.dart` → `_logout()` |
| 8 | Data per user (RLS) | ✅ | `book_service.dart` → filter `user_id` |
| 9 | Lacak progress membaca | ✅ | `book.dart` → `progress` getter |
| 10 | Progress bar visual | ✅ | `home_page.dart`, `detail_page.dart` → `LinearProgressIndicator` |
| 11 | Tag genre (multi-genre) | ✅ | `form_page.dart` → `_tambahGenre()` |
| 12 | Rating bintang (1–5) | ✅ | `form_page.dart`, `detail_page.dart` |
| 13 | Catatan / ulasan buku | ✅ | `form_page.dart` → `_notesCtrl` |
| 14 | Light Mode & Dark Mode | ✅ | `theme_provider.dart`, `main.dart` |
| 15 | Konfigurasi `.env` | ✅ | `.env` → `SUPABASE_URL`, `SUPABASE_ANON_KEY` |
| 16 | Auto-pop saat buku dihapus | ✅ | `detail_page.dart` → `addPostFrameCallback` |
| 17 | Empty state (belum ada buku) | ✅ | `home_page.dart` → `books.isEmpty` |
| 18 | Loading & error state | ✅ | `home_page.dart` → `isLoading`, `errorMessage` |

---

## Widget yang Digunakan

| Kategori | Widget |
|----------|--------|
| Tampilan | `Text`, `Icon`, `LinearProgressIndicator`, `Chip` |
| Layout | `Scaffold`, `AppBar`, `Row`, `Column`, `Container`, `Padding`, `SizedBox`, `Expanded`, `ListView`, `ListView.builder`, `Wrap`, `Card`, `SafeArea`, `SingleChildScrollView` |
| Interaksi | `InkWell`, `GestureDetector`, `ElevatedButton`, `OutlinedButton`, `TextButton`, `IconButton`, `FloatingActionButton.extended`, `TextFormField`, `Form`, `AlertDialog`, `SnackBar` |
| State | `StatelessWidget`, `StatefulWidget`, `ChangeNotifierProvider`, `MultiProvider`, `StreamBuilder` |
| Navigasi | `Navigator.push`, `Navigator.pop`, `Navigator.pushAndRemoveUntil`, `MaterialPageRoute` |

---

## Nilai Tambah

| # | Fitur | Implementasi |
|---|-------|-------------|
| 1 | Login & Register (Supabase Auth) | `login_page.dart`, `register_page.dart`, `AuthGate` di `main.dart` |
| 2 | Light Mode & Dark Mode | `ThemeProvider`, toggle di setiap halaman |
| 3 | File `.env` | `flutter_dotenv` — URL & Key tidak di-hardcode |

---

## Home Page

> Saya jelaskan alur disini ദ്ദി◝ ⩊ ◜.ᐟ

Pada tampilan awal, terdapat AppBar dengan nama aplikasi, tombol toggle tema, dan tombol logout. Jika belum ada buku, tampil pesan empty state. Klik tombol `+` **Tambah Buku** untuk membuka `Form Page` (fitur `Create`). Buku yang berhasil ditambahkan langsung muncul di daftar. Setiap kartu menampilkan judul, penulis, genre, rating, dan progress membaca. Klik ikon tong sampah untuk **hapus buku** dengan konfirmasi dialog.

| Kosongan | Tambah Buku | Hapus Buku |
|----------|------------|-----------|
| <img src="https://github.com/user-attachments/assets/d0c935ac-445b-4400-956a-e366cdb3cec5" width="150"/> | <img src="https://github.com/user-attachments/assets/ab4e424f-5443-40a4-8c95-2ca352880fc5" width="150"/> | <img src="https://github.com/user-attachments/assets/8ae6f8d4-efdb-490c-bc00-7420fd13025b" width="150"/> |

<details>
<summary>Deskripsi Implementasi Widget</summary>

### 1. `Text`
Widget dasar untuk menampilkan teks di seluruh halaman — judul buku, nama penulis, label, persentase progress, hingga pesan empty state.
```dart
Text(
  book.title,
  style: TextStyle(
    color: scheme.onSurface,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
),
```

### 2. `Icon` dan `IconButton`
Menampilkan ikon interaktif. Digunakan untuk tombol hapus, edit, toggle tema, dan logout di AppBar.
```dart
IconButton(
  icon: const Icon(Icons.delete_outline, size: 20),
  onPressed: () => _konfirmasiHapus(context),
),
```

### 3. `LinearProgressIndicator`
Menampilkan progress membaca secara visual berupa bar horizontal. Digunakan di kartu buku (5px) dan halaman detail (10px).
```dart
ClipRRect(
  borderRadius: BorderRadius.circular(4),
  child: LinearProgressIndicator(
    value: book.progress,
    minHeight: 5,
    backgroundColor: scheme.onSurface.withValues(alpha: 0.1),
    valueColor: AlwaysStoppedAnimation(scheme.primary),
  ),
),
```

### 4. `Scaffold` & `AppBar`
Kerangka utama setiap halaman. `AppBar` menampilkan judul, tombol toggle tema, dan logout di home page.
```dart
Scaffold(
  appBar: AppBar(
    backgroundColor: scheme.surface,
    title: const Text('Jeje BookShelf'),
    actions: [
      IconButton(icon: Icon(Icons.light_mode), onPressed: () {}),
      IconButton(icon: Icon(Icons.logout), onPressed: _logout),
    ],
  ),
)
```

### 5. `Row`, `Column`, `Expanded`
`Row` menyusun widget horizontal, `Column` vertikal. `Expanded` memaksa widget mengambil sisa ruang agar judul dan penulis tidak bertabrakan dengan ikon hapus.
```dart
Row(
  children: [
    Expanded(child: Column(children: [Text(book.title), Text(book.author)])),
    IconButton(icon: Icon(Icons.delete_outline), onPressed: () {}),
  ],
)
```

### 6. `Container`, `Padding`, `SizedBox`
`Container` untuk styling chip genre dengan warna, padding, dan border-radius. `SizedBox` sebagai spacer antar widget.
```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  decoration: BoxDecoration(
    color: scheme.primary.withValues(alpha: 0.12),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: scheme.primary.withValues(alpha: 0.3)),
  ),
  child: Text(g, style: TextStyle(color: scheme.primary)),
),
```

### 7. `ListView.builder`
Menampilkan daftar kartu buku yang panjangnya dinamis dan scrollable.
```dart
ListView.builder(
  itemCount: provider.books.length + 1,
  itemBuilder: (context, index) {
    if (index == 0) return Text('${provider.books.length} buku tersimpan');
    return _BookCard(book: provider.books[index - 1]);
  },
),
```

### 8. `Wrap`
Menyusun chip genre secara horizontal dan otomatis pindah baris jika tidak cukup ruang.
```dart
Wrap(
  spacing: 6,
  runSpacing: 4,
  children: book.genres.map((g) => Container(...)).toList(),
),
```

### 9. `Card`, `InkWell`, `Navigator.push`, `MaterialPageRoute`
`Card` membungkus konten dengan sudut melengkung dan shadow. `InkWell` membuat seluruh area kartu bisa ditekan untuk membuka `DetailPage`.
```dart
Card(
  color: scheme.surface,
  child: InkWell(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(bookId: book.id)),
    ),
    child: Padding(...),
  ),
)
```

### 10. `AlertDialog`, `TextButton`, `SnackBar`
`AlertDialog` untuk konfirmasi hapus buku. `SnackBar` untuk notifikasi aksi berhasil atau gagal.
```dart
showDialog(
  context: context,
  builder: (_) => AlertDialog(
    title: Text('Hapus Buku?'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text('Batal')),
      TextButton(onPressed: () { provider.deleteBook(book.id); }, child: Text('Hapus')),
    ],
  ),
);
```

### 11. `StatelessWidget` & `ChangeNotifierProvider`
`HomePage` dan `_BookCard` adalah `StatelessWidget` karena tidak punya state internal. Data dari `BookProvider` diakses via `context.watch`.
```dart
class HomePage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookProvider>();
  }
}
```

### 12. `FloatingActionButton.extended`
Tombol aksi utama di `HomePage` untuk navigasi ke halaman tambah buku.
```dart
FloatingActionButton.extended(
  backgroundColor: scheme.primary,
  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FormPage())),
  icon: const Icon(Icons.add, color: Colors.white),
  label: const Text('Tambah Buku'),
),
```

### 13. `StreamBuilder`
Digunakan di `AuthGate` untuk mendengarkan perubahan status autentikasi Supabase secara real-time dan menentukan halaman yang ditampilkan.
```dart
StreamBuilder<AuthState>(
  stream: Supabase.instance.client.auth.onAuthStateChange,
  builder: (context, snapshot) {
    if (snapshot.data?.event == AuthChangeEvent.signedIn) return const HomePage();
    return const LoginPage();
  },
)
```

</details>

---

## Detail Page

> Saya jelaskan alur disini ◝(ᵔᗜᵔ)◜

Halaman detail bisa diakses dengan klik kartu buku. Menampilkan judul, penulis, genre, progress membaca, rating, dan catatan. Tersedia tombol edit (ikon pensil di AppBar) dan hapus buku. Fitur hapus sengaja tidak dibuat mencolok agar fokus tetap pada isi buku.

| Tampilan | Tampilan Hapus | Hapus Buku | Balik Home Page |
|----------|------------|-----------|-----------|
| <img src="https://github.com/user-attachments/assets/2fcc1426-614c-4763-a627-43fd344a3d9e" width="150"/> | <img src="https://github.com/user-attachments/assets/f0474134-5e7a-423e-8d9c-49a0b9d189bd" width="150"/> | <img src="https://github.com/user-attachments/assets/79591258-6ba1-41f3-9874-b1fd379c1a29" width="150"/> | <img src="https://github.com/user-attachments/assets/5e953e1b-c4c5-4b60-b9b2-fcfa168dc831" width="150"/> |

<details>
<summary>Deskripsi Implementasi Widget</summary>

### 1. `OutlinedButton`
Tombol hapus buku dengan border merah tanpa fill — membedakannya secara visual dari aksi primer.
```dart
OutlinedButton.icon(
  onPressed: () => _konfirmasiHapus(context, book),
  style: OutlinedButton.styleFrom(
    foregroundColor: Colors.redAccent,
    side: const BorderSide(color: Colors.redAccent),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  icon: const Icon(Icons.delete_outline),
  label: const Text('Hapus Buku'),
),
```

</details>

---

## Form Page

> Saya jelaskan alur disini („• ֊ •„)੭

Halaman form bisa diakses dari fitur edit di halaman detail atau dari tombol tambah buku. Terdapat 6 `TextField` dengan validasi. Data langsung disimpan ke Supabase saat tombol **Tambah ke Koleksi** atau **Simpan Perubahan** ditekan. Saya mengatur agar tetap bisa memberi rating walaupun belum 100% selesai membaca.

| Tampilan | Tampilan Isi | Validasi (1) | Validasi (2) | POV Fitur Edit | Balik ke Home Page |
|----------|------------|-----------|-----------|-----------|-----------|
| <img src="https://github.com/user-attachments/assets/2d9a4e9e-f37d-4a4e-9eae-c89c8d032586" width="150"/> | <img src="https://github.com/user-attachments/assets/7b339667-a1b6-48a6-98de-6632ef3898b6" width="150"/> | <img src="https://github.com/user-attachments/assets/29bce5db-6fbf-4bbe-a2f0-a2a4602af254" width="150"/> | <img src="https://github.com/user-attachments/assets/d0bda3e3-6ded-4306-92d6-d7354693b3a4" width="150"/> | <img src="https://github.com/user-attachments/assets/73b67212-1e6e-4374-9279-4d8b534365dc" width="150"/> | <img src="https://github.com/user-attachments/assets/b1107d22-0922-49bd-a631-22659a6c3ec4" width="150"/> |

<details>
<summary>Deskripsi Implementasi Widget</summary>

### 1. `StatefulWidget`
Digunakan untuk `FormPage` karena perlu menyimpan state lokal — isi controller, daftar genre, dan nilai rating yang berubah saat pengguna mengisi form.
```dart
class FormPage extends StatefulWidget {
  final Book? bookToEdit;
  const FormPage({super.key, this.bookToEdit});

  @override
  State<FormPage> createState() => _FormPageState();
}
```

### 2. `GestureDetector`
Mendeteksi tap pada bintang rating dan tombol `+` genre. Lebih ringan dari `InkWell` karena tidak butuh efek ripple.
```dart
GestureDetector(
  onTap: () => setState(() => _rating = i + 1.0),
  child: Icon(
    i < _rating ? Icons.star : Icons.star_border,
    color: const Color(0xFFFFD700),
    size: 34,
  ),
),
```

### 3. `ElevatedButton`
Tombol utama simpan data dengan background `scheme.primary` sebagai aksi paling menonjol.
```dart
ElevatedButton(
  onPressed: _isSaving ? null : _simpan,
  style: ElevatedButton.styleFrom(backgroundColor: scheme.primary),
  child: Text(_isEditing ? 'Simpan Perubahan' : 'Tambah ke Koleksi'),
),
```

### 4. `TextFormField` & `Form`
6 input dengan validasi terintegrasi. `GlobalKey<FormState>` memicu validasi semua field sekaligus.

| # | Field | Tipe | Validasi |
|---|-------|------|---------|
| 1 | Judul | Teks | Wajib diisi |
| 2 | Penulis | Teks | Wajib diisi |
| 3 | Genre | Teks + tombol `+` | Min. 1 genre |
| 4 | Total Halaman | Angka | Wajib diisi, > 0 |
| 5 | Halaman Ke- | Angka | Tidak boleh > total |
| 6 | Catatan | Multiline | Opsional |
```dart
final _formKey = GlobalKey<FormState>();

if (!_formKey.currentState!.validate()) return;
```

</details>

---

## Login & Register Page

Halaman login dan register menggunakan **Supabase Auth**. Setiap user hanya bisa melihat dan mengelola buku miliknya sendiri (Row Level Security). Tersedia toggle Light/Dark Mode di setiap halaman auth.

| Login | Register |
|-------|---------|
| <img src="https://github.com/user-attachments/assets/699abe7f-374f-4ebf-8a73-6d3b568e4275" width="150" /> | <img src="https://github.com/user-attachments/assets/41809fff-c26e-4abe-aefb-04c6bf7945a8" width="150"/> |
