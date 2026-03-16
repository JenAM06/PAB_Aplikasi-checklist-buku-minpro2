# JEJE BookShelf

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=flat&logo=supabase&logoColor=white)

Aplikasi manajemen koleksi buku pribadi untuk mencatat, melacak progress membaca, dan memberikan rating pada setiap buku yang dimiliki.

> Jen Agresia Misti | 2409116007 | A'24 | MINPRO 2 PAB

---

## Daftar Isi

- [Tech Stack](#tech-stack)
- [Cara Menjalankan](#cara-menjalankan)
- [Struktur Folder](#struktur-folder)
- [Database Schema](#database-schema)
- [Fitur Aplikasi](#fitur-aplikasi)
- [Nilai Tambah](#nilai-tambah)
- [Widget yang Digunakan](#widget-yang-digunakan)

### Dokumentasi Halaman
- [Home Page](#home-page)
- [Detail Page](#detail-page)
- [Form Page](#form-page)
- [Login & Register Page](#login--register-page)

---

## Tech Stack

| Teknologi | Kegunaan |
|-----------|---------|
| Flutter | Framework UI |
| Dart | Bahasa pemrograman |
| Supabase | Database & Auth |
| Provider | State management |
| flutter_dotenv | Manajemen environment variable |

---

## Cara Menjalankan

1. Clone repository
```bash
   git clone https://github.com/JenAM06/PAB_Aplikasi-checklist-buku-minpro2.git
```

2. Masuk ke folder project
```bash
   cd PAB_Aplikasi-checklist-buku-minpro2
```

3. Buat file `.env` di root project
```
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
```

4. Install dependencies
```bash
   flutter pub get
```

5. Jalankan aplikasi
```bash
   flutter run
```

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

Contoh alur saat menambah buku:

```
FormPage
   ↓
BookProvider.addBook()
   ↓
BookService.addBook()
   ↓
Supabase Database
```

## Database Schema

Aplikasi menggunakan **Supabase PostgreSQL** sebagai backend database.

### Table: `books`

| Column | Type | Description |
|------|------|-------------|
| id | uuid | Primary key buku |
| title | text | Judul buku |
| author | text | Nama penulis |
| genres | text | Daftar genre dalam format JSON |
| notes | text | Catatan atau ulasan buku |
| rating | float | Rating buku dari 1 sampai 5 |
| total_pages | integer | Total halaman buku |
| current_page | integer | Halaman yang sudah dibaca |
| user_id | uuid | ID user pemilik buku |
| created_at | timestamp | Waktu buku ditambahkan |

### Relasi Data

Setiap buku terhubung dengan **user Supabase** melalui kolom `user_id`.

```
User (Supabase Auth)
      │
      └── user_id
            │
            ▼
          books
```

---

## Fitur Aplikasi

| # | Fitur | Lokasi |
|---|-------|--------|
| 1 | Tambah buku baru ke Supabase | `form_page.dart` → `_simpan()` |
| 2 | Tampilkan daftar buku dari Supabase | `home_page.dart` → `fetchBooks()` |
| 3 | Edit buku yang ada | `form_page.dart` → `_isEditing` |
| 4 | Hapus buku (dengan konfirmasi) | `home_page.dart`, `detail_page.dart` → `_konfirmasiHapus()` |
| 5 | Login menggunakan Supabase Auth | `login_page.dart` |
| 6 | Register akun baru | `register_page.dart` |
| 7 | Logout |  `home_page.dart` → `_logout()` |
| 8 | Data per user (RLS) |  `book_service.dart` → filter `user_id` |
| 9 | Lacak progress membaca |  `book.dart` → `progress` getter |
| 10 | Progress bar visual |  `home_page.dart`, `detail_page.dart` → `LinearProgressIndicator` |
| 11 | Tag genre (multi-genre) |  `form_page.dart` → `_tambahGenre()` |
| 12 | Rating bintang (1–5) |  `form_page.dart`, `detail_page.dart` |
| 13 | Catatan / ulasan buku |  `form_page.dart` → `_notesCtrl` |
| 14 | Light Mode & Dark Mode |  `theme_provider.dart`, `main.dart` |
| 15 | Konfigurasi `.env` |  `.env` → `SUPABASE_URL`, `SUPABASE_ANON_KEY` |
| 16 | Auto-pop saat buku dihapus |  `detail_page.dart` → `addPostFrameCallback` |
| 17 | Empty state (belum ada buku) | `home_page.dart` → `books.isEmpty` |
| 18 | Loading & error state | `home_page.dart` → `isLoading`, `errorMessage` |

---

## Nilai Tambah

| # | Fitur | Implementasi |
|---|-------|-------------|
| 1 | Login & Register (Supabase Auth) | `login_page.dart`, `register_page.dart`, `AuthGate` di `main.dart` |
| 2 | Light Mode & Dark Mode | `ThemeProvider`, toggle di setiap halaman |
| 3 | File `.env` | `flutter_dotenv` — URL & Key tidak di-hardcode |

---

## Widget yang Digunakan

| Kategori | Widget |
|----------|--------|
| Tampilan | `Text`, `Icon`, `LinearProgressIndicator`, `Chip` |
| Layout | `Scaffold`, `AppBar`, `Row`, `Column`, `Container`, `Padding`, `SizedBox`, `Expanded`, `ListView`, `ListView.builder`, `Wrap`, `Card`, `SafeArea`, `SingleChildScrollView` |
| Interaksi | `InkWell`, `GestureDetector`, `ElevatedButton`, `OutlinedButton`, `TextButton`, `IconButton`, `FloatingActionButton.extended`, `TextFormField`, `Form`, `AlertDialog`, `SnackBar` |
| State | `StatelessWidget`, `StatefulWidget`, `ChangeNotifierProvider`, `MultiProvider`, `StreamBuilder` |
| Navigasi | `Navigator.push`, `Navigator.pop`, `MaterialPageRoute` |

---

## Home Page

Pada tampilan awal, terdapat AppBar dengan nama aplikasi, tombol toggle tema, dan tombol logout. Jika belum ada buku, tampil pesan empty state. Klik tombol `+` **Tambah Buku** untuk membuka `Form Page` (fitur `Create`). Buku yang berhasil ditambahkan langsung muncul di daftar. Setiap kartu menampilkan judul, penulis, genre, rating, dan progress membaca. Klik ikon tong sampah untuk **hapus buku** dengan konfirmasi dialog.

**Dark Mode**

| Kosongan | Tambah Buku | Hapus Buku |
|----------|------------|-----------|
|<img src="https://github.com/user-attachments/assets/a9522f62-b465-41fd-9f6f-94ad1e21416d" width="150"/>|<img src="https://github.com/user-attachments/assets/dfde4956-210a-403e-bed2-a4520ca5cafc" width="150"/>| <img src="https://github.com/user-attachments/assets/5272bf5c-836a-4df1-9131-9d61c9f505de" width="150"/> |

**Light Mode**

| Kosongan | Tambah Buku | Hapus Buku |
|----------|------------|-----------|
|<img src="https://github.com/user-attachments/assets/5303bc6d-8f99-4a3a-b2f6-d30125547fe0" width="150"/>|<img src="https://github.com/user-attachments/assets/e2577d29-9abf-4927-b045-7689d6644ac3" width="150"/>| <img src="https://github.com/user-attachments/assets/59fd4859-2a28-4883-947c-4afa1a4391d9" width="150"/> |


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
  icon: Icon(
    Icons.delete_outline,
    color: scheme.onSurface.withValues(alpha: 0.3),
    size: 20,
  ),
  onPressed: () => _konfirmasiHapus(context),
  padding: EdgeInsets.zero,
  constraints: const BoxConstraints(),
),
```

### 3. `LinearProgressIndicator`
Menampilkan progress membaca secara visual berupa bar horizontal. Digunakan di kartu buku (5px) dan halaman detail (10px). Warna mengikuti tema aktif via `scheme.primary`.
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
Kerangka utama setiap halaman. `AppBar` di home page menampilkan judul aplikasi, tombol toggle tema, dan tombol logout. Menggunakan `elevation` dan `shadowColor` agar navbar terlihat di light mode.
```dart
Scaffold(
  appBar: AppBar(
    backgroundColor: scheme.surface,
    elevation: 1,
    shadowColor: scheme.onSurface.withValues(alpha: 0.08),
    title: const Text(
      'Jeje BookShelf',
      style: TextStyle(color: Color(0xFF9B6BFF), fontWeight: FontWeight.bold),
    ),
    actions: [
      IconButton(icon: Icon(Icons.light_mode, color: scheme.primary), onPressed: () {}),
      IconButton(icon: Icon(Icons.logout, color: scheme.primary), onPressed: _logout),
    ],
  ),
)
```

### 5. `Row`, `Column`, `Expanded`
`Row` menyusun widget horizontal, `Column` vertikal. `Expanded` memaksa `Column` mengambil sisa ruang agar judul dan penulis tidak bertabrakan dengan ikon hapus.
```dart
Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(book.title, style: TextStyle(color: scheme.onSurface)),
          Text(book.author, style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.5))),
        ],
      ),
    ),
    IconButton(icon: Icon(Icons.delete_outline), onPressed: () {}),
  ],
)
```

### 6. `Container`, `Padding`, `SizedBox`
`Container` untuk styling chip genre dengan warna, border, dan border-radius yang menyesuaikan tema. `SizedBox` sebagai spacer antar widget.
```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  decoration: BoxDecoration(
    color: scheme.primary.withValues(alpha: 0.12),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: scheme.primary.withValues(alpha: 0.3),
      width: 1,
    ),
  ),
  child: Text(g, style: TextStyle(color: scheme.primary, fontSize: 11)),
),
```

### 7. `ListView.builder`
Menampilkan daftar kartu buku yang panjangnya dinamis dan scrollable. Index 0 dipakai untuk header jumlah buku, index selanjutnya untuk kartu buku.
```dart
ListView.builder(
  padding: const EdgeInsets.all(16),
  itemCount: provider.books.length + 1,
  itemBuilder: (context, index) {
    if (index == 0) {
      return Text('${provider.books.length} buku tersimpan');
    }
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
`Card` membungkus konten kartu buku dengan `elevation` dan `border` yang menyesuaikan tema (lebih terlihat di light mode). `InkWell` membuat seluruh area kartu bisa ditekan untuk membuka `DetailPage`.
```dart
Card(
  color: scheme.surface,
  elevation: isDark ? 0 : 2,
  shadowColor: scheme.onSurface.withValues(alpha: 0.08),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    side: isDark
        ? BorderSide.none
        : BorderSide(color: scheme.onSurface.withValues(alpha: 0.08)),
  ),
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
`AlertDialog` untuk konfirmasi hapus buku. `SnackBar` untuk notifikasi aksi berhasil atau gagal. Warna mengikuti `scheme` aktif.
```dart
showDialog(
  context: context,
  builder: (_) => AlertDialog(
    backgroundColor: scheme.surface,
    title: Text('Hapus Buku?', style: TextStyle(color: scheme.onSurface)),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Batal', style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.5))),
      ),
      TextButton(
        onPressed: () {
          context.read<BookProvider>().deleteBook(book.id);
          Navigator.pop(context);
        },
        child: const Text('Hapus', style: TextStyle(color: Colors.redAccent)),
      ),
    ],
  ),
);
```

### 11. `StatefulWidget` & `ChangeNotifierProvider`
`HomePage` menggunakan `StatefulWidget` agar bisa memanggil `fetchBooks()` di `initState`. Data dari `BookProvider` diakses via `context.watch`.
```dart
class HomePage extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<BookProvider>().fetchBooks());
  }
}
```

### 12. `FloatingActionButton.extended`
Tombol aksi utama di `HomePage` untuk navigasi ke halaman tambah buku.
```dart
FloatingActionButton.extended(
  backgroundColor: scheme.primary,
  onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const FormPage()),
  ),
  icon: const Icon(Icons.add, color: Colors.white),
  label: const Text('Tambah Buku',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
),
```

### 13. `StreamBuilder`
Digunakan di `AuthGate` untuk mendengarkan perubahan status autentikasi Supabase secara real-time dan menentukan halaman yang ditampilkan tanpa perlu `Navigator`.
```dart
StreamBuilder<AuthState>(
  stream: Supabase.instance.client.auth.onAuthStateChange,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final event = snapshot.data!.event;
      if (event == AuthChangeEvent.signedIn) return const HomePage();
      if (event == AuthChangeEvent.signedOut) return const LoginPage();
    }
    final currentSession = Supabase.instance.client.auth.currentSession;
    return currentSession != null ? const HomePage() : const LoginPage();
  },
)
```

</details>

---

## Detail Page

Halaman detail bisa diakses dengan klik kartu buku. Menampilkan judul, penulis, genre, progress membaca, rating, dan catatan. Tersedia tombol edit (ikon pensil di AppBar) dan hapus buku. Fitur hapus sengaja tidak dibuat mencolok agar fokus tetap pada isi buku.

**Dark Mode**

| Tampilan | Tampilan Hapus | Hapus Buku | Balik Home Page |
|----------|------------|-----------|-----------|
|<img src="https://github.com/user-attachments/assets/2bcb68a3-ca49-40ad-ad27-a01646b7e0db" width="150"/> | <img src="https://github.com/user-attachments/assets/6cf25d29-331c-48fb-b7ca-6a2e8c779414" width="150"/> | <img src="https://github.com/user-attachments/assets/41a81209-caeb-4f9d-9b8c-50091bc79c1a" width="150"/> | <img src="https://github.com/user-attachments/assets/5e953e1b-c4c5-4b60-b9b2-fcfa168dc831" width="150"/> |

**Light Mode**

| Tampilan | Tampilan Hapus | Hapus Buku | Balik Home Page |
|----------|------------|-----------|-----------|
|<img src="https://github.com/user-attachments/assets/ee33cf9a-b2cc-4d83-8c31-ab0e6c1541fe" width="150"/> | <img src="https://github.com/user-attachments/assets/8fa63159-ff5b-4572-b976-d18e073a3fff" width="150"/> |<img src="https://github.com/user-attachments/assets/4c0606b2-5913-45d9-b5de-9511968f2c45" width="150"/> | <img src="https://github.com/user-attachments/assets/5303bc6d-8f99-4a3a-b2f6-d30125547fe0" width="150"/> |

<details>
<summary>Deskripsi Implementasi Widget</summary>

### 1. `OutlinedButton`
Tombol hapus buku dengan border merah tanpa fill — membedakannya secara visual dari aksi primer agar tidak mencolok.
```dart
OutlinedButton.icon(
  onPressed: () => _konfirmasiHapus(context, book),
  style: OutlinedButton.styleFrom(
    foregroundColor: Colors.redAccent,
    side: const BorderSide(color: Colors.redAccent),
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  icon: const Icon(Icons.delete_outline),
  label: const Text('Hapus Buku', style: TextStyle(fontWeight: FontWeight.bold)),
),
```

### 2. `Divider`
Pemisah visual antara informasi judul/genre dengan konten detail (progress, rating, catatan).
```dart
Divider(color: scheme.onSurface.withValues(alpha: 0.1)),
```

### 3. Guard `bookIndex == -1`
Menggunakan `addPostFrameCallback` untuk auto-pop jika buku sudah dihapus saat `DetailPage` masih terbuka — mencegah crash `firstWhere`.
```dart
if (bookIndex == -1) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (Navigator.canPop(context)) Navigator.pop(context);
  });
  return Scaffold(backgroundColor: scheme.surface);
}
```

</details>

---

## Form Page

Halaman `form` bisa diakses dari fitur `edit` di halaman `detail` atau dari tombol tambah buku. Terdapat 6 `TextFields` yang diisi (detailnya ada pada deskripsi widget) dan 2 fitur unik yaitu progres membaca dan rating bintang. Bar persen pada `card` di halaman page berasal dari jumlah halaman yang sudah kita baca dari total halaman buku, berguna jika kehilangan penanda buku atau sekedar melihat progres membaca. Data langsung disimpan ke Supabase saat tombol **Tambah ke Koleksi** atau **Simpan Perubahan** ditekan. Berikut penjelasan validasinya:
1. _User_ harus Memasukkan nama dan penulisnya
2. _User_ harus memasukkan minimal 1 genre/jenis bukunya
3. _User_ tidak bisa _input_ jumlah halaman yang sudah dia baca melebihi total halaman buku
4. _User_ harus _input_ total halaman buku tapi tidak masalah jika belum ada jumlah halaman yang sudah dibaca karena bisa saja buku yang dimilliki belum dibaca atau terbungkus jadi _user_ hanya ingin memasukkan ke dalam list di aplikasi saja
5. Saya mengatur agar tetap bisa memberi rating walaupun belum 100% selesai membaca untuk mempertimbangkan jika sudah tidak ingin melanjutkan buku tersebut dan menaruh alasannya di catatan.

**Dark Mode**

| Tampilan | Validasi (1) | Validasi (2) | Validasi (3) | Validasi (4) | POV Fitur Edit |
|----------|------------|-----------|-----------|-----------|-----------|
|<img src="https://github.com/user-attachments/assets/1576b80c-0e87-4857-b73c-738de2a2dcf8" width="150"/> | <img src="https://github.com/user-attachments/assets/5373132e-fef2-4b78-b5d5-fb54d3f9fce5" width="150"/> | <img src="https://github.com/user-attachments/assets/ad9b2260-31eb-4d70-9c37-5ee970dd150c" width="150"/> | <img src="https://github.com/user-attachments/assets/049a05be-0e9e-4577-bb01-18265f34bc69" width="150"/> | <img src="https://github.com/user-attachments/assets/634ea078-b63b-4a5c-bb80-1b4e2fe4b595" width="150"/> | <img src="https://github.com/user-attachments/assets/3606ed22-fb40-4fab-90bc-839ab79a2146" width="150"/> |

**Light Mode**

| Tampilan | Validasi (1) | Validasi (2) | Validasi (3) | Validasi (4) | POV Fitur Edit |
|----------|------------|-----------|-----------|-----------|-----------|
| <img src="https://github.com/user-attachments/assets/faa9e459-0257-4499-9d8e-17a896f9b607" width="150"/>| <img src="https://github.com/user-attachments/assets/4584b32f-9598-4c0b-9212-38803c44728a" width="150"/> | <img src="https://github.com/user-attachments/assets/b8e90cda-4b5b-40c9-8313-ebb123cacae7" width="150"/> | <img src="https://github.com/user-attachments/assets/18a1cfb3-e46b-460f-8d02-6093ff94702d" width="150"/> | <img src="https://github.com/user-attachments/assets/fcde1294-c395-4fa5-9f2c-a496c4b5a15a" width="150"/> | <img src="https://github.com/user-attachments/assets/6da73393-d70f-48b9-950a-cd52fe9cf3ec" width="150"/> |

<details>
<summary>Deskripsi Implementasi Widget</summary>

### 1. `StatefulWidget`
Digunakan untuk `FormPage` karena perlu menyimpan state lokal — isi controller, daftar genre, nilai rating, dan status `_isSaving` yang berubah saat pengguna mengisi dan menyimpan form.
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
  child: Padding(
    padding: const EdgeInsets.only(right: 8),
    child: Icon(
      i < _rating ? Icons.star : Icons.star_border,
      color: const Color(0xFFFFD700),
      size: 34,
    ),
  ),
),
```

### 3. `ElevatedButton`
Tombol utama simpan data dengan background `scheme.primary`. Saat `_isSaving` bernilai `true`, tombol di-disable dan menampilkan `CircularProgressIndicator` agar tidak bisa ditekan dua kali.
```dart
ElevatedButton(
  onPressed: _isSaving ? null : _simpan,
  style: ElevatedButton.styleFrom(
    backgroundColor: scheme.primary,
    disabledBackgroundColor: scheme.primary.withValues(alpha: 0.5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  ),
  child: _isSaving
      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
      : Text(_isEditing ? 'Simpan Perubahan' : 'Tambah ke Koleksi'),
),
```

### 4. `TextFormField` & `Form`
6 input dengan validasi terintegrasi. `GlobalKey<FormState>` memicu validasi semua field sekaligus saat simpan ditekan.

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

// Validasi semua field sekaligus
if (!_formKey.currentState!.validate()) return;

// Validasi manual genre dan halaman
if (_genres.isEmpty) { _showSnackbar('Tambahkan minimal satu genre!', isError: true); return; }
if (total <= 0) { _showSnackbar('Total halaman wajib diisi!', isError: true); return; }
if (current > total) { _showSnackbar('Halaman sekarang tidak boleh melebihi total!', isError: true); return; }
```

### 5. `Chip`
Menampilkan genre yang sudah ditambahkan sebagai chip yang bisa dihapus satu per satu.
```dart
Chip(
  label: Text(g, style: TextStyle(color: scheme.onSurface, fontSize: 12)),
  backgroundColor: scheme.primary.withValues(alpha: 0.2),
  side: BorderSide(color: scheme.primary, width: 1),
  deleteIcon: Icon(Icons.close, size: 14, color: scheme.onSurface.withValues(alpha: 0.5)),
  onDeleted: () => setState(() => _genres.remove(g)),
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
),
```

</details>

---

## Login & Register Page

Saat pertama membuka aplikasi, user akan diarahkan ke halaman **Login**. Jika belum punya akun, klik **Daftar** untuk ke halaman Register. Setelah registrasi berhasil, kembali ke halaman login dan masuk menggunakan email dan password yang sudah didaftarkan. Setiap user hanya bisa melihat dan mengelola buku miliknya sendiri berkat **Row Level Security** di Supabase. Tersedia toggle Light/Dark Mode di setiap halaman auth. Untuk keluar dari akun, klik tombol logout di AppBar halaman utama.

**Dark mode**

| Login | Register | Validasi (1)| Validasi (2)|
|-------|---------|---------|---------|
| <img src="https://github.com/user-attachments/assets/699abe7f-374f-4ebf-8a73-6d3b568e4275" width="150" /> | <img src="https://github.com/user-attachments/assets/41809fff-c26e-4abe-aefb-04c6bf7945a8" width="150"/> | <img src="https://github.com/user-attachments/assets/c3d96317-b745-4eb2-8500-74a898764576" width="150"/>| <img src="https://github.com/user-attachments/assets/a5b71d24-a39e-433b-8705-b7b1c403368b" width="150"/>|

**Light Mode**

| Login | Register | Validasi (1)| Validasi (2)|
|-------|---------|---------|---------|
| <img src="https://github.com/user-attachments/assets/98009bff-2903-4e2a-8d59-6e62b9fc4fae" width="150" /> | <img src="https://github.com/user-attachments/assets/c579d19c-84a8-432a-936b-2f23517d18f8" width="150"/> | <img src="https://github.com/user-attachments/assets/84739167-dcf5-4c51-8690-2fd4536e8baf" width="150"/>| <img src="https://github.com/user-attachments/assets/a5b71d24-a39e-433b-8705-b7b1c403368b" width="150"/>|

<details>
<summary>Deskripsi Implementasi Widget</summary>

### 1. `SafeArea` & `SingleChildScrollView`
`SafeArea` memastikan konten tidak tertutup status bar atau notch. `SingleChildScrollView` memungkinkan form di-scroll saat keyboard muncul.
```dart
SafeArea(
  child: Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Form(...),
    ),
  ),
),
```

### 2. `StreamBuilder` & `AuthGate`
Mendengarkan perubahan auth state Supabase secara real-time. Saat login berhasil otomatis pindah ke `HomePage`, saat logout otomatis kembali ke `LoginPage`.
```dart
StreamBuilder<AuthState>(
  stream: Supabase.instance.client.auth.onAuthStateChange,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final event = snapshot.data!.event;
      if (event == AuthChangeEvent.signedIn) return const HomePage();
      if (event == AuthChangeEvent.signedOut) return const LoginPage();
    }
    final currentSession = Supabase.instance.client.auth.currentSession;
    return currentSession != null ? const HomePage() : const LoginPage();
  },
)
```

### 3. `TextButton`
Digunakan untuk link navigasi antar halaman auth ("Daftar" dan "Login") agar kursor berubah jadi jari saat dihover — lebih interaktif dari `GestureDetector`.
```dart
TextButton(
  onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const RegisterPage()),
  ),
  style: TextButton.styleFrom(
    padding: EdgeInsets.zero,
    minimumSize: Size.zero,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  ),
  child: Text('Daftar', style: TextStyle(color: scheme.primary, fontWeight: FontWeight.bold)),
),
```

</details>
