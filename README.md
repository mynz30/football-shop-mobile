**Nama:** Faishal Khoiriansyah Wicaksono  
**NPM:** 2406436335  
**Kelas:** D  

---

## Tugas 8: Flutter Navigation, Layouts, Forms, and Input Elements

### 1. Jelaskan perbedaan antara `Navigator.push()` dan `Navigator.pushReplacement()` pada Flutter. Dalam kasus apa sebaiknya masing-masing digunakan pada aplikasi Football Shop kamu?

**Perbedaan utama:**

| Aspek | `Navigator.push()` | `Navigator.pushReplacement()` |
|-------|-------------------|------------------------------|
| **Fungsi** | Menambahkan halaman baru di atas stack navigasi | Mengganti halaman saat ini dengan halaman baru |
| **Stack** | Halaman lama tetap ada di stack | Halaman lama dihapus dari stack |
| **Tombol Back** | Bisa kembali ke halaman sebelumnya | Tidak bisa kembali ke halaman sebelumnya |

**Penggunaan dalam aplikasi Football Shop:**

- **`Navigator.push()`** digunakan untuk:
  - Navigasi dari **Halaman Utama** ke **Form Tambah Produk** (via tombol "Create Product")
  - User dapat kembali ke halaman utama dengan tombol back
  - Cocok untuk flow yang memerlukan navigasi hierarkis
  
  ```dart
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ProductEntryFormPage()),
  );
  ```

- **`Navigator.pushReplacement()`** digunakan untuk:
  - Navigasi dari **Drawer** ke **Halaman Utama**
  - Menghindari penumpukan halaman yang sama di stack
  - Ketika user memilih menu drawer, halaman saat ini diganti dengan halaman tujuan
  
  ```dart
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const MyHomePage()),
  );
  ```

---

### 2. Bagaimana kamu memanfaatkan hierarchy widget seperti `Scaffold`, `AppBar`, dan `Drawer` untuk membangun struktur halaman yang konsisten di seluruh aplikasi?

Saya memanfaatkan hierarchy widget dengan cara berikut:

**1. Scaffold sebagai Struktur Dasar**
- Digunakan di **semua halaman** (home page dan form page)
- Menyediakan kerangka konsisten dengan `appBar`, `drawer`, dan `body`

**2. AppBar untuk Navigasi Atas**
- Menggunakan **warna yang sama** (`Colors.green`) di semua halaman
- Style teks yang konsisten (putih, bold)
- IconTheme putih untuk hamburger menu

```dart
AppBar(
  title: const Text(
    'Football Shop',
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
  backgroundColor: Colors.green,
  iconTheme: const IconThemeData(color: Colors.white),
)
```

**3. Drawer untuk Menu Navigasi Global**
- Dibuat sebagai **widget terpisah** (`LeftDrawer`) untuk reusability
- Di-import dan digunakan di semua halaman yang memerlukan navigasi
- Memiliki header dengan branding yang konsisten
- Menu yang sama dapat diakses dari halaman mana pun

```dart
drawer: const LeftDrawer(),
```

**Keuntungan struktur ini:**
- **Konsistensi visual** di seluruh aplikasi
- **Mudah dimaintain** - perubahan di LeftDrawer otomatis berlaku di semua halaman
- **User experience yang baik** - user tahu cara navigasi dari halaman mana pun

---

### 3. Dalam konteks desain antarmuka, apa kelebihan menggunakan layout widget seperti `Padding`, `SingleChildScrollView`, dan `ListView` saat menampilkan elemen-elemen form? Berikan contoh penggunaannya dari aplikasi kamu.

**Kelebihan masing-masing widget:**

**1. Padding**
- **Kelebihan**: Memberikan ruang/jarak di sekitar widget untuk tampilan yang lebih breathable
- **Contoh di aplikasi**:
  ```dart
  body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      // Form elements
    ),
  )
  ```
  Memberikan margin 16 pixel di semua sisi form, sehingga tidak menempel di tepi layar.

**2. SingleChildScrollView**
- **Kelebihan**: 
  - Membuat konten dapat di-scroll jika melebihi tinggi layar
  - Mencegah overflow error pada layar kecil
  - Memastikan semua elemen form tetap dapat diakses
- **Contoh di aplikasi**:
  ```dart
  body: Form(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 6 input fields + button
          ],
        ),
      ),
    ),
  )
  ```
  Memungkinkan user scroll untuk melihat semua field pada layar kecil atau saat keyboard muncul.

**3. ListView**
- **Kelebihan**:
  - Efisien untuk menampilkan list panjang (lazy loading)
  - Otomatis scrollable
  - Cocok untuk data dinamis
- **Contoh di aplikasi (Drawer)**:
  ```dart
  Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(...),
        ListTile(...),
        ListTile(...),
      ],
    ),
  )
  ```
  Digunakan di drawer untuk menampilkan menu navigasi yang dapat bertambah seiring berkembangnya aplikasi.

**Kombinasi yang powerful:**
Menggunakan `Padding` + `SingleChildScrollView` + `Column` untuk form memastikan:
- Form tidak menempel di tepi layar
- Semua field dapat diakses meskipun layar kecil
- User experience yang smooth saat mengisi form

---

### 4. Bagaimana kamu menyesuaikan warna tema agar aplikasi Football Shop memiliki identitas visual yang konsisten dengan brand toko?

Saya menggunakan **skema warna hijau** sebagai identitas utama Football Shop dengan strategi berikut:

**1. Theme Global di MaterialApp**
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.green,
  ).copyWith(secondary: Colors.tealAccent[400]),
  useMaterial3: true,
)
```
- **Primary color (hijau)**: Melambangkan lapangan sepak bola/rumput
- **Secondary color (teal accent)**: Memberikan variasi tanpa keluar dari tema olahraga

**2. Konsistensi di Seluruh Komponen**

- **AppBar**: Background hijau dengan teks putih
  ```dart
  backgroundColor: Colors.green
  ```

- **Drawer Header**: Gradient hijau untuk efek modern
  ```dart
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.green, Colors.green.shade700],
    ),
  )
  ```

- **Button "Save"**: Background hijau konsisten
  ```dart
  backgroundColor: Colors.green
  ```

- **Icon di Drawer**: Accent hijau untuk konsistensi
  ```dart
  leading: const Icon(Icons.home, color: Colors.green)
  ```

- **Checkbox**: Active color hijau
  ```dart
  activeColor: Colors.green
  ```

**3. Variasi Warna untuk Tombol Aksi**
- Menggunakan warna berbeda untuk tombol berbeda (biru, hijau, merah) untuk membedakan fungsi
- Namun tetap mempertahankan hijau sebagai warna dominan di navigasi dan branding

**Hasil:**
- **Brand identity yang kuat** dengan warna hijau konsisten
- **Professional look** dengan Material Design 3
- **User-friendly** karena konsistensi visual memudahkan navigasi
- **Memorable** - user akan mengasosiasikan hijau dengan Football Shop