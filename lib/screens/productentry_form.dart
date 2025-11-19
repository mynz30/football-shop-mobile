import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:football_shop_mobile/widgets/left_drawer.dart';
import 'package:football_shop_mobile/menu.dart';

class ProductEntryFormPage extends StatefulWidget {
  const ProductEntryFormPage({super.key});

  @override
  State<ProductEntryFormPage> createState() => _ProductEntryFormPageState();
}

class _ProductEntryFormPageState extends State<ProductEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  int _price = 0;
  String _description = "";
  String _thumbnail = "";
  String _brand = "";
  String _category = "";
  String? _jenisProduct;
  bool _isFeatured = false;
  int _stock = 0;
  double _rating = 0.0;

  final List<String> _jenisProductList = [
    'Jersey',
    'Bola',
    'Sepatu',
    'Aksesoris',
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Form Tambah Produk',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input Nama Produk
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Nama Produk",
                    hintText: "Masukkan nama produk",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.shopping_bag),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _name = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Nama produk tidak boleh kosong!";
                    }
                    if (value.length < 3) {
                      return "Nama produk minimal 3 karakter!";
                    }
                    if (value.length > 100) {
                      return "Nama produk maksimal 100 karakter!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input Brand
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Brand",
                    hintText: "Contoh: Nike, Adidas, Puma",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.branding_watermark),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _brand = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Brand tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Dropdown Jenis Produk
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Jenis Produk",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.category),
                  ),
                  value: _jenisProduct,
                  hint: const Text("Pilih jenis produk"),
                  items: _jenisProductList.map((String jenis) {
                    return DropdownMenuItem<String>(
                      value: jenis,
                      child: Text(jenis),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _jenisProduct = value;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Jenis produk harus dipilih!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input Harga
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Harga",
                    hintText: "Masukkan harga produk",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixText: "Rp ",
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (String? value) {
                    setState(() {
                      _price = int.tryParse(value!) ?? 0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Harga tidak boleh kosong!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Harga harus berupa angka!";
                    }
                    if (int.parse(value) <= 0) {
                      return "Harga harus lebih dari 0!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input Stock
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Stock",
                    hintText: "Masukkan jumlah stock",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.inventory),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (String? value) {
                    setState(() {
                      _stock = int.tryParse(value!) ?? 0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Stock tidak boleh kosong!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Stock harus berupa angka!";
                    }
                    if (int.parse(value) < 0) {
                      return "Stock tidak boleh negatif!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input Rating
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Rating",
                    hintText: "Masukkan rating (0.0 - 5.0)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.star),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (String? value) {
                    setState(() {
                      _rating = double.tryParse(value!) ?? 0.0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Rating tidak boleh kosong!";
                    }
                    double? rating = double.tryParse(value);
                    if (rating == null) {
                      return "Rating harus berupa angka!";
                    }
                    if (rating < 0 || rating > 5) {
                      return "Rating harus antara 0.0 - 5.0!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input Deskripsi
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Deskripsi",
                    hintText: "Masukkan deskripsi produk",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.description),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Deskripsi tidak boleh kosong!";
                    }
                    if (value.length < 10) {
                      return "Deskripsi minimal 10 karakter!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input Thumbnail URL
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Thumbnail URL",
                    hintText: "Masukkan URL gambar produk",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.image),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _thumbnail = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "URL thumbnail tidak boleh kosong!";
                    }
                    final urlPattern = RegExp(
                      r'^https?:\/\/.+\.(jpg|jpeg|png|gif|webp)$',
                      caseSensitive: false,
                    );
                    if (!urlPattern.hasMatch(value)) {
                      return "URL harus berupa link gambar yang valid!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input Kategori
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Kategori",
                    hintText: "Contoh: Pria, Wanita, Anak-anak",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.label),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _category = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Kategori tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Checkbox Is Featured
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isFeatured,
                        onChanged: (bool? value) {
                          setState(() {
                            _isFeatured = value!;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                      const Expanded(
                        child: Text(
                          "Tandai sebagai Produk Unggulan",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol Save
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Kirim ke Django
                        final response = await request.postJson(
                          "https://faishal-khoiriansyah-footballshop.pbp.cs.ui.ac.id/create-flutter/",
                          jsonEncode(<String, dynamic>{
                            'name': _name,
                            'price': _price.toString(),
                            'description': _description,
                            'thumbnail': _thumbnail,
                            'category': _category,
                            'is_featured': _isFeatured,
                            'stock': _stock.toString(),
                            'brand': _brand,
                            'rating': _rating.toString(),
                          }),
                        );

                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Produk berhasil disimpan!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyHomePage(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Terjadi kesalahan: ${response['message']}"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.save),
                        SizedBox(width: 8),
                        Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}