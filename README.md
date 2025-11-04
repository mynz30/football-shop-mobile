**Nama:** Faishal Khoiriansyah Wicaksono  
**NPM:** 2406436335  
**Kelas:** D  

---

## 1. Apa itu Widget Tree pada Flutter dan bagaimana hubungan parent-child bekerja antar widget?

**Widget tree** adalah struktur hierarki yang menggambarkan bagaimana semua widget disusun di dalam aplikasi Flutter. Setiap elemen antarmuka pengguna (seperti teks, tombol, atau layout) merupakan **node** dalam pohon tersebut.  

Hubungan **parent-child (induk-anak)** berarti setiap widget (parent) dapat memiliki satu atau lebih widget di dalamnya (child).  
Contohnya:
- `Scaffold` adalah parent dari `AppBar` dan `Body`.
- `Column` adalah parent dari beberapa widget seperti `Text`, `Row`, atau `Container`.  

Flutter membangun dan merender UI berdasarkan struktur pohon ini. Jika satu bagian widget berubah, hanya subtree yang relevan yang akan di-render ulang untuk efisiensi.

---

## 2. Sebutkan semua widget yang digunakan dalam proyek ini dan jelaskan fungsinya.

Berikut daftar widget yang digunakan pada proyek **Football Shop Mobile**:

| Widget | Fungsi |
|--------|---------|
| `MaterialApp` | Widget root yang menyediakan struktur dasar aplikasi berbasis Material Design. |
| `Scaffold` | Menyediakan struktur layout utama seperti `AppBar`, `Body`, dan `FloatingActionButton`. |
| `AppBar` | Menampilkan bar di bagian atas aplikasi yang berisi judul atau tombol navigasi. |
| `Text` | Menampilkan teks statis di layar. |
| `Row` | Menyusun widget secara horizontal. |
| `Column` | Menyusun widget secara vertikal. |
| `Card` | Menyediakan tampilan seperti kartu untuk menampilkan informasi yang terpisah dengan bayangan (elevation). |
| `Container` | Membungkus widget lain dan dapat diberi padding, margin, atau warna. |
| `GridView.count` | Membuat layout grid dengan jumlah kolom tetap (digunakan untuk menampilkan tombol utama). |
| `Material` | Memberikan efek Material Design seperti warna dan bayangan pada widget. |
| `InkWell` | Membuat area dapat ditekan (tappable) dengan efek ripple. |
| `Icon` | Menampilkan ikon dari pustaka Material Icons. |
| `SnackBar` | Menampilkan pesan notifikasi sementara di bagian bawah layar. |
| `ScaffoldMessenger` | Mengatur bagaimana `SnackBar` ditampilkan di dalam sebuah `Scaffold`. |
| `Padding` | Memberikan jarak di sekitar widget child. |
| `SizedBox` | Memberikan jarak atau ruang kosong antar widget. |

---

## 3. Apa fungsi dari widget MaterialApp? Mengapa widget ini sering digunakan sebagai widget root?

`MaterialApp` adalah widget yang mengatur **struktur dasar aplikasi Flutter** berbasis Material Design.  
Fungsinya:
- Menentukan tema global aplikasi (warna, font, ikon).
- Mengatur **navigasi antar halaman (routes)**.
- Menentukan **widget awal** yang akan ditampilkan (`home`).
- Mengatur **localization**, **title**, dan **debug banner**.

Widget ini sering digunakan sebagai **root** karena ia menjadi fondasi untuk semua elemen antarmuka berbasis Material Design — tanpa `MaterialApp`, banyak widget seperti `Scaffold` atau `SnackBar` tidak akan berfungsi dengan baik.

---

## 4. Jelaskan perbedaan antara StatelessWidget dan StatefulWidget. Kapan kamu memilih salah satunya?

| Perbandingan | StatelessWidget | StatefulWidget |
|---------------|----------------|----------------|
| **Sifat** | Tidak memiliki state yang dapat berubah setelah dibuat. | Memiliki state yang dapat berubah selama aplikasi berjalan. |
| **Contoh** | `Text`, `Icon`, `RaisedButton`. | `Checkbox`, `TextField`, `Slider`. |
| **Rebuild** | Hanya dirender sekali (kecuali parent berubah). | Dapat di-render ulang ketika `setState()` dipanggil. |
| **Penggunaan** | Ketika tampilan bersifat statis dan tidak berubah-ubah. | Ketika tampilan perlu bereaksi terhadap interaksi pengguna atau data yang dinamis. |

Dalam tugas ini, saya menggunakan **StatelessWidget**, karena tampilan (tiga tombol dan informasi mahasiswa) bersifat **statis** dan tidak berubah berdasarkan interaksi kompleks.

---

## 5. Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di metode build?

`BuildContext` adalah **objek yang menghubungkan widget ke lokasi tertentu di dalam widget tree**.  
Dengan `BuildContext`, widget dapat:
- Mengakses informasi tentang posisi atau hubungan dengan widget lain.
- Mengambil data dari widget induk seperti `Theme`, `MediaQuery`, atau `ScaffoldMessenger`.
- Menampilkan elemen UI seperti `SnackBar`.

Dalam metode `build(BuildContext context)`, objek `context` digunakan untuk:
- Menampilkan `SnackBar` menggunakan `ScaffoldMessenger.of(context)`.
- Mengetahui ukuran layar (`MediaQuery.of(context)`).
- Mengambil tema dari `Theme.of(context)`.

---

## 6. Jelaskan konsep "hot reload" di Flutter dan bagaimana bedanya dengan "hot restart".

| Fitur | Hot Reload | Hot Restart |
|--------|-------------|-------------|
| **Tujuan** | Menyuntikkan perubahan kode ke dalam aplikasi yang sedang berjalan tanpa kehilangan state. | Menjalankan ulang seluruh aplikasi dari awal. |
| **Kecepatan** | Cepat (dalam hitungan detik). | Lebih lambat karena aplikasi dijalankan ulang sepenuhnya. |
| **State Aplikasi** | Dipertahankan. | Hilang (semua variabel kembali ke kondisi awal). |
| **Kapan digunakan** | Saat hanya mengubah UI atau layout kecil. | Saat mengubah struktur utama aplikasi, variabel global, atau logika awal aplikasi. |

Hot reload sangat membantu saat melakukan iterasi cepat pada tampilan antarmuka tanpa kehilangan progress aplikasi.
