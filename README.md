**Nama:** Faishal Khoiriansyah Wicaksono  
**NPM:** 2406436335  
**Kelas:** D  

---

# Tugas 9: Integrasi Layanan Web Django dengan Aplikasi Flutter

## Pertanyaan dan Jawaban

### 1. Mengapa kita perlu membuat model Dart saat mengambil/mengirim data JSON? Apa konsekuensinya jika langsung memetakan `Map<String, dynamic>` tanpa model?

**Mengapa perlu membuat model Dart:**

Model Dart diperlukan saat mengambil/mengirim data JSON karena beberapa alasan penting:

1. **Type Safety**: Model Dart memberikan type safety yang kuat. Dengan model, kita tahu persis tipe data setiap field (String, int, bool, dll.), sehingga kesalahan tipe data dapat terdeteksi saat compile-time, bukan runtime.

2. **Autocomplete dan IntelliSense**: IDE dapat memberikan autocomplete dan suggestion yang akurat karena mengetahui struktur object dan tipe data masing-masing properti.

3. **Kemudahan Maintenance**: Ketika struktur data berubah, kita hanya perlu mengupdate model di satu tempat. Semua error akan muncul di compile-time, memudahkan kita menemukan dan memperbaiki kode yang terpengaruh.

4. **Dokumentasi Implicit**: Model berfungsi sebagai dokumentasi kode yang jelas tentang struktur data yang digunakan aplikasi.

5. **Null Safety**: Dengan model, kita dapat menentukan field mana yang nullable dan mana yang required, memanfaatkan fitur null safety Dart.

**Konsekuensi jika langsung memetakan `Map<String, dynamic>` tanpa model:**

1. **Tidak ada type checking**: Semua data diakses dengan key string, sehingga typo pada nama key tidak akan terdeteksi hingga runtime.
   ```dart
   // Tanpa model - error baru terdeteksi saat runtime
   print(data['naem']); // Typo! seharusnya 'name'
   
   // Dengan model - error terdeteksi saat compile-time
   print(product.naem); // Compile error: no such property
   ```

2. **Tidak ada null safety**: Kita tidak tahu field mana yang mungkin null, sehingga berpotensi menyebabkan null pointer exception.

3. **Kode sulit di-maintain**: Perubahan struktur data tidak akan terdeteksi secara otomatis, sehingga bug dapat muncul di production.

4. **Tidak ada autocomplete**: Developer harus mengingat atau terus-menerus memeriksa dokumentasi API untuk mengetahui field yang tersedia.

5. **Validasi data manual**: Harus menulis kode validasi secara manual untuk setiap field yang diakses.

---

### 2. Apa fungsi package http dan CookieRequest dalam tugas ini? Jelaskan perbedaan peran http vs CookieRequest.

**Package `http`:**

Package `http` adalah package Flutter standar untuk melakukan HTTP request. Fungsinya meliputi:

1. Mengirim HTTP request (GET, POST, PUT, DELETE) ke web service
2. Menerima response dari server
3. Menghandle basic HTTP operations seperti headers dan body
4. Tidak menangani session management atau cookie secara otomatis

Contoh penggunaan:
```dart
import 'package:http/http.dart' as http;

final response = await http.get(Uri.parse('https://example.com/api/products'));
```

**Package `pbp_django_auth` (CookieRequest):**

CookieRequest adalah custom package yang dirancang khusus untuk integrasi dengan Django. Fungsinya lebih luas:

1. **Session Management**: Otomatis menyimpan dan mengelola session cookies dari Django
2. **Authentication**: Menangani login/logout dengan Django authentication system
3. **CSRF Protection**: Otomatis menangani CSRF token yang dibutuhkan Django
4. **Persistent Session**: Menjaga user tetap login antar sesi aplikasi
5. **Automatic Cookie Handling**: Mengirimkan cookie di setiap request tanpa konfigurasi manual

Contoh penggunaan:
```dart
final request = context.watch<CookieRequest>();
final response = await request.get('https://example.com/api/products');
// Cookie session otomatis dikirim
```

**Perbedaan Peran:**

| Aspek | `http` | `CookieRequest` |
|-------|--------|----------------|
| **Session Management** | Manual | Otomatis |
| **Cookie Handling** | Manual | Otomatis |
| **Authentication State** | Tidak ada | Built-in |
| **CSRF Protection** | Manual | Otomatis |
| **Use Case** | Simple REST API | Django backend dengan authentication |
| **State Management** | Stateless | Stateful |

---

### 3. Mengapa instance CookieRequest perlu untuk dibagikan ke semua komponen di aplikasi Flutter?

Instance CookieRequest perlu dibagikan ke semua komponen karena beberapa alasan penting:

1. **Konsistensi Session**: Semua bagian aplikasi harus menggunakan session yang sama. Jika setiap widget membuat instance CookieRequest sendiri, mereka akan memiliki session terpisah, menyebabkan:
   - User harus login berulang kali
   - Data tidak konsisten antar halaman
   - Cookie tidak tersinkronisasi

2. **Efisiensi Memory**: Menggunakan satu instance menghemat memory dibanding membuat instance baru di setiap widget.

3. **State Management**: Authentication state (logged in/logged out) perlu diketahui oleh seluruh aplikasi. Provider pattern memastikan semua widget dapat mengakses dan bereaksi terhadap perubahan state ini.

4. **Sinkronisasi Data**: Ketika user logout di satu halaman, semua halaman lain harus tahu dan bereaksi sesuai (misalnya redirect ke login page).

**Implementasi dengan Provider:**

```dart
// Di main.dart
Provider(
  create: (_) {
    CookieRequest request = CookieRequest();
    return request;
  },
  child: MaterialApp(...)
)

// Di widget lain
final request = context.watch<CookieRequest>();
// Semua widget menggunakan instance yang sama
```

**Manfaat Pattern ini:**

- Dependency Injection yang clean
- Mudah untuk testing (bisa mock CookieRequest)
- Reactive UI - widget otomatis rebuild saat state berubah
- Centralized session management

---

### 4. Jelaskan konfigurasi konektivitas yang diperlukan agar Flutter dapat berkomunikasi dengan Django. Mengapa kita perlu menambahkan 10.0.2.2 pada ALLOWED_HOSTS, mengaktifkan CORS dan pengaturan SameSite/cookie, dan menambahkan izin akses internet di Android?

**Konfigurasi yang Diperlukan:**

**1. ALLOWED_HOSTS dengan 10.0.2.2**

```python
ALLOWED_HOSTS = [
    "localhost",
    "127.0.0.1",
    "10.0.2.2",  # Untuk Android Emulator
    "your-production-domain.com",
]
```

**Mengapa perlu 10.0.2.2?**
- Android Emulator berjalan dalam virtual device yang terisolasi
- `localhost` atau `127.0.0.1` di emulator merujuk ke emulator itu sendiri, bukan host machine
- `10.0.2.2` adalah alamat IP khusus yang di-route oleh Android Emulator ke `127.0.0.1` host machine
- Tanpa ini, Django akan menolak request dari emulator dengan error 400 Bad Request

**2. CORS (Cross-Origin Resource Sharing)**

```python
INSTALLED_APPS = [
    ...
    'corsheaders',
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    ...
]

CORS_ALLOW_ALL_ORIGINS = True  # Untuk development
CORS_ALLOW_CREDENTIALS = True
```

**Mengapa perlu CORS?**
- Flutter web app dan mobile app dianggap sebagai "origin" berbeda dari Django backend
- Browser modern (untuk Flutter web) memblokir request ke domain berbeda tanpa CORS headers
- `CORS_ALLOW_CREDENTIALS = True` memungkinkan cookie dikirim dalam cross-origin request
- Tanpa CORS, browser akan memblokir response dengan CORS policy error

**3. Cookie Settings (SameSite)**

```python
CSRF_COOKIE_SECURE = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SAMESITE = 'None'
SESSION_COOKIE_SAMESITE = 'None'
```

**Mengapa perlu pengaturan SameSite?**
- `SameSite=None` memungkinkan cookie dikirim dalam cross-site request
- `Secure=True` diperlukan saat menggunakan `SameSite=None` (HTTPS)
- Default `SameSite=Lax` mencegah cookie dikirim dari aplikasi Flutter
- Tanpa ini, authentication tidak akan bekerja karena session cookie tidak terkirim

**4. Android Internet Permission**

```xml
<uses-permission android:name="android.permission.INTERNET" />
<application android:usesCleartextTraffic="true">
```

**Mengapa perlu permission ini?**
- Android memerlukan explicit permission untuk akses internet (security measure)
- `usesCleartextTraffic=true` memungkinkan HTTP (non-HTTPS) untuk development
- Tanpa permission ini, aplikasi tidak bisa melakukan network request sama sekali
- Production app sebaiknya menggunakan HTTPS dan remove `usesCleartextTraffic`

**Apa yang Terjadi Jika Konfigurasi Tidak Benar:**

| Konfigurasi Missing | Dampak |
|---------------------|--------|
| `10.0.2.2` tidak di ALLOWED_HOSTS | HTTP 400 Bad Request dari Django |
| CORS tidak aktif | Browser memblokir response dengan CORS error |
| SameSite tidak diatur | Cookie tidak terkirim, authentication gagal |
| Internet permission tidak ada | Aplikasi crash atau network request gagal silent |

---

### 5. Jelaskan mekanisme pengiriman data mulai dari input hingga dapat ditampilkan pada Flutter.

**Mekanisme Lengkap Pengiriman Data:**

**A. Dari Input di Flutter ke Django (POST Request)**

1. **User Input**
   ```dart
   // User mengisi form di Flutter
   TextField(
     controller: _nameController,
     decoration: InputDecoration(labelText: 'Product Name'),
   )
   ```

2. **Serialisasi Data**
   ```dart
   // Data form dikonversi ke JSON
   final response = await request.postJson(
     "https://example.com/api/create-product/",
     jsonEncode({
       "name": _nameController.text,
       "price": int.parse(_priceController.text),
       "description": _descriptionController.text,
     }),
   );
   ```

3. **HTTP Request**
   - CookieRequest mengirim POST request dengan:
     - Headers: Content-Type, Cookie (session), CSRF token
     - Body: JSON data yang sudah di-serialize
     - Method: POST

4. **Django Menerima Request**
   ```python
   @csrf_exempt
   def create_product(request):
       if request.method == 'POST':
           data = json.loads(request.body)
           name = data['name']
           # Process data...
   ```

5. **Django Memproses dan Menyimpan**
   ```python
   product = Product.objects.create(
       name=name,
       price=price,
       description=description,
       user=request.user
   )
   ```

6. **Django Mengirim Response**
   ```python
   return JsonResponse({
       "status": "success",
       "message": "Product created successfully"
   }, status=201)
   ```

7. **Flutter Menerima Response**
   ```dart
   if (response['status'] == 'success') {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Product created!')),
     );
     Navigator.pop(context);
   }
   ```

**B. Dari Django ke Flutter (GET Request - Menampilkan Data)**

1. **Flutter Request Data**
   ```dart
   Future<List<Product>> fetchProduct(CookieRequest request) async {
     final response = await request.get(
       'https://example.com/json/',
     );
     
     List<Product> listProduct = [];
     for (var d in response) {
       listProduct.add(Product.fromJson(d));
     }
     return listProduct;
   }
   ```

2. **Django Query Database**
   ```python
   def show_json(request):
       products = Product.objects.all()
       return HttpResponse(
           serializers.serialize("json", products),
           content_type="application/json"
       )
   ```

3. **Serialisasi Django**
   ```json
   [
     {
       "model": "main.product",
       "pk": 1,
       "fields": {
         "name": "Jersey Home",
         "price": 500000,
         "description": "Official jersey"
       }
     }
   ]
   ```

4. **Flutter Deserialize JSON**
   ```dart
   factory Product.fromJson(Map<String, dynamic> json) => Product(
       model: json["model"],
       pk: json["pk"],
       fields: Fields.fromJson(json["fields"]),
   );
   ```

5. **Flutter Render UI**
   ```dart
   FutureBuilder(
     future: fetchProduct(request),
     builder: (context, AsyncSnapshot snapshot) {
       if (snapshot.hasData) {
         return ListView.builder(
           itemCount: snapshot.data.length,
           itemBuilder: (_, index) => ProductCard(
             product: snapshot.data[index]
           ),
         );
       }
       return CircularProgressIndicator();
     },
   )
   ```

**Flow Diagram:**

```
Flutter Input → Serialize to JSON → HTTP POST → Django View
                                                      ↓
                                                 Validate Data
                                                      ↓
                                                 Save to Database
                                                      ↓
Flutter UI ← Deserialize JSON ← HTTP Response ← JSON Response
```

---

### 6. Jelaskan mekanisme autentikasi dari login, register, hingga logout. Mulai dari input data akun pada Flutter ke Django hingga selesainya proses autentikasi oleh Django dan tampilnya menu pada Flutter.

**A. REGISTER - Pembuatan Akun Baru**

**1. Input di Flutter**
```dart
// User mengisi form register
TextField(controller: _usernameController),
TextField(controller: _passwordController, obscureText: true),
TextField(controller: _confirmPasswordController, obscureText: true),

ElevatedButton(
  onPressed: () async {
    final response = await request.postJson(
      "https://example.com/auth/register/",
      jsonEncode({
        "username": _usernameController.text,
        "password1": _passwordController.text,
        "password2": _confirmPasswordController.text,
      }),
    );
  },
)
```

**2. Django Menerima dan Validasi**
```python
@csrf_exempt
def register(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        username = data['username']
        password1 = data['password1']
        password2 = data['password2']
        
        # Validasi
        if password1 != password2:
            return JsonResponse({
                "status": False,
                "message": "Password tidak cocok."
            }, status=400)
        
        if User.objects.filter(username=username).exists():
            return JsonResponse({
                "status": False,
                "message": "Username sudah ada."
            }, status=400)
```

**3. Django Membuat User**
```python
        # Buat user baru
        user = User.objects.create_user(
            username=username,
            password=password1
        )
        user.save()
        
        return JsonResponse({
            "username": user.username,
            "status": 'success',
            "message": "User berhasil dibuat!"
        }, status=200)
```

**4. Flutter Handle Response**
```dart
if (response['status'] == 'success') {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Successfully registered!')),
  );
  // Redirect ke login page
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}
```

---

**B. LOGIN - Autentikasi User**

**1. Input Credentials di Flutter**
```dart
TextField(controller: _usernameController),
TextField(controller: _passwordController, obscureText: true),

ElevatedButton(
  onPressed: () async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    
    // Login request
    final response = await request.login(
      "https://example.com/auth/login/",
      {
        'username': username,
        'password': password,
      },
    );
  },
)
```

**2. Django Autentikasi**
```python
@csrf_exempt
def login(request):
    username = request.POST.get('username')
    password = request.POST.get('password')
    
    # Django authenticate user
    user = authenticate(username=username, password=password)
    
    if user is not None:
        if user.is_active:
            # Login user - creates session
            auth_login(request, user)
            
            return JsonResponse({
                "username": user.username,
                "status": True,
                "message": "Login sukses!"
            }, status=200)
```

**3. Django Session Management**
- Django membuat session di database
- Session ID dikirim ke Flutter via Set-Cookie header
- Cookie berisi: sessionid, csrftoken

**4. CookieRequest Menyimpan Cookie**
```dart
// CookieRequest otomatis:
// 1. Menerima Set-Cookie header
// 2. Menyimpan cookie di memory
// 3. Set loggedIn = true
```

**5. Flutter Update UI State**
```dart
if (request.loggedIn) {
  String message = response['message'];
  String uname = response['username'];
  
  // Navigate ke home page
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => MyHomePage()),
  );
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("$message Selamat datang, $uname.")),
  );
}
```

**6. Authenticated Requests**
```dart
// Setiap request berikutnya otomatis menyertakan cookie
final products = await request.get('https://example.com/json/');
// Cookie session terkirim otomatis, Django tahu user sudah login
```

---

**C. LOGOUT - Mengakhiri Session**

**1. User Klik Logout di Flutter**
```dart
ListTile(
  leading: Icon(Icons.logout),
  title: Text('Logout'),
  onTap: () async {
    final response = await request.logout(
      "https://example.com/auth/logout/",
    );
  },
)
```

**2. Django Hapus Session**
```python
@csrf_exempt
def logout(request):
    username = request.user.username
    
    try:
        # Django logout - hapus session
        auth_logout(request)
        
        return JsonResponse({
            "username": username,
            "status": True,
            "message": "Logout berhasil!"
        }, status=200)
```

**3. CookieRequest Clear Cookie**
```dart
// CookieRequest otomatis:
// 1. Clear semua cookie
// 2. Set loggedIn = false
```

**4. Flutter Redirect ke Login**
```dart
if (response['status']) {
  String uname = response["username"];
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Sampai jumpa, $uname.")),
  );
  
  // Redirect ke login page
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}
```

**Flow Diagram Autentikasi Lengkap:**

```
REGISTER:
Flutter Form → POST /auth/register/ → Django validates
                                          ↓
                                    Create User in DB
                                          ↓
Flutter Login ← JSON Response ← Success/Error message

LOGIN:
Flutter Form → POST /auth/login/ → Django authenticate()
                                          ↓
                                    auth_login() creates session
                                          ↓
                                    Set-Cookie header
                                          ↓
Flutter Home ← Store cookie ← JSON Response + Cookie

AUTHENTICATED REQUEST:
Flutter → GET /json/ (with cookie) → Django checks session
                                          ↓
                                    Session valid?
                                          ↓
Flutter UI ← Deserialize ← JSON data (if authenticated)

LOGOUT:
Flutter → POST /auth/logout/ → Django auth_logout()
                                     ↓
                                Clear session
                                     ↓
Flutter Login ← Clear cookie ← JSON Response
```

**Keamanan Authentication:**

1. **Password Hashing**: Django otomatis hash password dengan PBKDF2
2. **CSRF Protection**: Token dikirim dan divalidasi untuk setiap request
3. **Session Security**: Session ID random dan secure
4. **HTTPS**: Production harus menggunakan HTTPS untuk encrypt data transfer

---

### 7. Jelaskan bagaimana cara kamu mengimplementasikan checklist di atas secara step-by-step!

**Step 1: Setup Django Backend untuk Autentikasi**

1. **Buat app authentication di Django**
```bash
python manage.py startapp authentication
```

2. **Buat views untuk login, register, logout**
```python
# authentication/views.py
from django.contrib.auth import authenticate, login as auth_login, logout as auth_logout
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
import json

@csrf_exempt
def login(request):
    username = request.POST.get('username')
    password = request.POST.get('password')
    user = authenticate(username=username, password=password)
    if user is not None:
        if user.is_active:
            auth_login(request, user)
            return JsonResponse({
                "username": user.username,
                "status": True,
                "message": "Login sukses!"
            }, status=200)
    return JsonResponse({
        "status": False,
        "message": "Login gagal."
    }, status=401)

@csrf_exempt
def register(request):
    # Implementation sama seperti sebelumnya
    pass

@csrf_exempt  
def logout(request):
    # Implementation sama seperti sebelumnya
    pass
```

3. **Routing authentication**
```python
# authentication/urls.py
from django.urls import path
from authentication.views import login, register, logout

app_name = 'authentication'

urlpatterns = [
    path('login/', login, name='login'),
    path('register/', register, name='register'),
    path('logout/', logout, name='logout'),
]
```

4. **Update settings.py**
```python
INSTALLED_APPS = [
    ...
    'corsheaders',
    'authentication',
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    ...
]

CORS_ALLOW_ALL_ORIGINS = True
CORS_ALLOW_CREDENTIALS = True
CSRF_COOKIE_SAMESITE = 'None'
SESSION_COOKIE_SAMESITE = 'None'
CSRF_COOKIE_SECURE = True
SESSION_COOKIE_SECURE = True

ALLOWED_HOSTS = ["localhost", "127.0.0.1", "10.0.2.2", "your-domain.com"]
```

---

**Step 2: Setup Flutter dengan Provider**

1. **Update pubspec.yaml**
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  pbp_django_auth: ^1.0.0
  http: ^1.2.0
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Update main.dart dengan Provider**
```dart
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

void main() {
  runApp(const FootballShopApp());
}

class FootballShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Football Shop',
        home: LoginPage(),
      ),
    );
  }
}
```

---

**Step 3: Implementasi Halaman Login**

1. **Buat login.dart**
```dart
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      body: Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final response = await request.login(
                      "https://your-domain.com/auth/login/",
                      {
                        'username': _usernameController.text,
                        'password': _passwordController.text,
                      },
                    );
                    
                    if (request.loggedIn) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                      );
                    }
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

**Step 4: Implementasi Halaman Register**

1. **Buat register.dart** dengan struktur mirip login
2. **Implementasi form register** dengan username, password1, password2
3. **Call endpoint /auth/register/**
4. **Redirect ke login** setelah berhasil register

---

**Step 5: Membuat Model Dart**

1. **Convert JSON dari Django ke Dart model**

Bisa menggunakan tool seperti Quicktype atau manual:

```dart
// lib/models/product.dart
class Product {
    String model;
    int pk;
    Fields fields;

    Product({required this.model, required this.pk, required this.fields});

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );
}

class Fields {
    String name;
    int price;
    String description;
    // ... fields lainnya

    Fields({required this.name, required this.price, ...});

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        price: json["price"],
        description: json["description"],
        // ... parse fields lainnya
    );
}
```

---

**Step 6: Implementasi Halaman List Produk**

1. **Buat list_productentry.dart**
```dart
class ProductEntryPage extends StatefulWidget {
  @override
  State<ProductEntryPage> createState() => _ProductEntryPageState();
}

class _ProductEntryPageState extends State<ProductEntryPage> {
  Future<List<Product>> fetchProduct(CookieRequest request) async {
    final response = await request.get('https://your-domain.com/json/');
    
    List<Product> listProduct = [];
    for (var d in response) {
      if (d != null) {
        listProduct.add(Product.fromJson(d));
      }
    }
    return listProduct;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(title: Text('All Products')),
      body: FutureBuilder(
        future: fetchProduct(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                return ProductCard(product: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}
```

---

**Step 7: Implementasi Halaman Detail Produk**

1. **Buat product_detail.dart**
```dart
class ProductDetailPage extends StatefulWidget {
  final int productId;
  const ProductDetailPage({required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Future<Product> fetchProductDetail(CookieRequest request) async {
    final response = await request.get(
      'https://your-domain.com/json/${widget.productId}/',
    );
    return Product.fromJson(response[0]);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(title: Text('Product Detail')),
      body: FutureBuilder(
        future: fetchProductDetail(request),
        builder: (context, AsyncSnapshot<Product> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          
          var product = snapshot.data!.fields;
          return SingleChildScrollView(
            child: Column(
              children: [
                Image.network(product.thumbnail),
                Text(product.name, style: TextStyle(fontSize: 24)),
                Text('Rp ${product.price}'),
                Text(product.description),
                // ... tampilkan semua atribut
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Back to Products'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

2. **Tambahkan navigasi dari list ke detail**
```dart
// Di ProductCard
InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          productId: product.pk,
        ),
      ),
    );
  },
  child: Card(child: ...),
)
```

---

**Step 8: Filter Produk Berdasarkan User**

1. **Update Django view untuk filter by user**
```python
# main/views.py
@login_required(login_url='/login/')
def show_json_by_user(request):
    # Filter hanya produk milik user yang login
    products = Product.objects.filter(user=request.user)
    return HttpResponse(
        serializers.serialize("json", products),
        content_type="application/json"
    )
```

2. **Tambahkan URL routing**
```python
# main/urls.py
urlpatterns = [
    ...
    path("json/user/", show_json_by_user, name="show_json_by_user"),
]
```

3. **Buat halaman My Products di Flutter**
```dart
class MyProductsPage extends StatefulWidget {
  @override
  State<MyProductsPage> createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  Future<List<Product>> fetchMyProducts(CookieRequest request) async {
    // Endpoint khusus untuk produk user yang login
    final response = await request.get(
      'https://your-domain.com/json/user/',
    );
    
    List<Product> listProduct = [];
    for (var d in response) {
      if (d != null) {
        listProduct.add(Product.fromJson(d));
      }
    }
    return listProduct;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(title: Text('My Products')),
      body: FutureBuilder(
        future: fetchMyProducts(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 100),
                  Text('Belum ada produk'),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) {
              return ProductCard(product: snapshot.data![index]);
            },
          );
        },
      ),
    );
  }
}
```

---

**Step 9: Update Left Drawer dengan Logout**

```dart
class LeftDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Icon(Icons.sports_soccer, size: 60),
                Text('Football Shop'),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('All Products'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductEntryPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.inventory),
            title: Text('My Products'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyProductsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add_box),
            title: Text('Add Product'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductEntryFormPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout'),
            onTap: () async {
              final response = await request.logout(
                "https://your-domain.com/auth/logout/",
              );
              
              if (context.mounted) {
                if (response['status']) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Logout berhasil!")),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
```

---

**Step 10: Konfigurasi Android**

1. **Update AndroidManifest.xml**
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Tambahkan permission internet -->
    <uses-permission android:name="android.permission.INTERNET" />
    
    <application
        android:usesCleartextTraffic="true"
        ...>
        ...
    </application>
</manifest>
```

---

**Step 11: Testing dan Debugging**

1. **Testing Lokal**
   - Jalankan Django: `python manage.py runserver`
   - Ganti URL di Flutter ke `http://10.0.2.2:8000` untuk emulator
   - Atau `http://127.0.0.1:8000` untuk browser/physical device

2. **Testing dengan Deployment**
   - Deploy Django ke production server
   - Update semua URL di Flutter ke production URL
   - Test login, register, dan semua fitur

3. **Common Issues:**
   - **CORS Error**: Pastikan corsheaders installed dan configured
   - **Cookie tidak terkirim**: Cek SameSite=None dan Secure=True
   - **10.0.2.2 tidak work**: Gunakan ngrok atau deploy ke server
   - **401 Unauthorized**: Pastikan cookie session terkirim dengan benar

---

**Step 12: Deployment**

1. **Deploy Django ke PaaS** (Railway, Heroku, dll)
2. **Update ALLOWED_HOSTS** dengan domain production
3. **Set environment variables** untuk SECRET_KEY, DATABASE_URL
4. **Update semua URL di Flutter** dari localhost ke production URL
5. **Build Flutter app**:
   ```bash
   flutter build apk
   # atau
   flutter build appbundle
   ```

---

**Step 13: Final Checklist**

✅ **Deployment Django berjalan**
- Django berhasil di-deploy dan accessible
- API endpoints `/json/`, `/auth/login/`, dll berfungsi

✅ **Implementasi registrasi akun**
- Halaman register dengan form username, password1, password2
- Validasi password match
- Create user di Django
- Redirect ke login setelah sukses

✅ **Implementasi login**
- Halaman login dengan form username dan password
- Autentikasi dengan Django
- Simpan session cookie
- Redirect ke home setelah login

✅ **Integrasi autentikasi Django-Flutter**
- CookieRequest di-share via Provider
- Session management otomatis
- Cookie terkirim di setiap request

✅ **Model kustom Dart**
- Product model sesuai struktur Django
- fromJson dan toJson methods
- Type-safe fields

✅ **Halaman daftar item**
- Fetch dari endpoint `/json/`
- Tampilkan name, price, description, thumbnail, category, is_featured
- Grid/List layout

✅ **Halaman detail item**
- Navigasi dari card di list page
- Tampilkan semua atribut product
- Tombol kembali ke list

✅ **Filter by user**
- Endpoint `/json/user/` di Django
- Halaman "My Products" di Flutter
- Hanya tampilkan produk milik user yang login

✅ **README.md**
- Jawaban semua pertanyaan
- Penjelasan implementasi step-by-step

---

## Kesimpulan

Integrasi Django-Flutter melibatkan beberapa komponen kunci:

1. **Backend (Django)**: API endpoints untuk auth dan data
2. **Frontend (Flutter)**: UI dan state management
3. **Communication**: HTTP requests dengan cookie-based authentication
4. **Data Flow**: JSON serialization/deserialization
5. **Security**: CORS, CSRF, Session management

Dengan arsitektur ini, kita memiliki aplikasi full-stack yang secure, scalable, dan maintainable. Django menangani business logic dan data persistence, sedangkan Flutter menyediakan UI yang responsive dan native-like experience.

**Tips untuk Development:**

- Gunakan print() atau debugger untuk tracking data flow
- Test di Postman dulu sebelum implement di Flutter
- Gunakan try-catch untuk error handling yang baik
- Implement loading states untuk better UX
- Validasi input di client dan server side
- Gunakan environment variables untuk URL configuration