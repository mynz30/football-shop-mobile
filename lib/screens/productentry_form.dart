import 'package:flutter/material.dart';
import 'package:football_shop_mobile/widgets/left_drawer.dart';

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
  String? _jenisProduct; // Nullable untuk dropdown
  bool _isFeatured = false;

  // List jenis produk
  final List<String> _jenisProductList = [
    'Jersey',
    'Bola',
    'Sepatu',
    'Aksesoris',
  ];

  @override
  Widget build(BuildContext context) {
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
                    if (value.length < 2) {
                      return "Brand minimal 2 karakter!";
                    }
                    if (value.length > 50) {
                      return "Brand maksimal 50 karakter!";
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
                    if (int.parse(value) > 1000000000) {
                      return "Harga terlalu besar!";
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
                    if (value.length > 500) {
                      return "Deskripsi maksimal 500 karakter!";
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
                    // Validasi format URL sederhana
                    final urlPattern = RegExp(
                      r'^https?:\/\/.+\.(jpg|jpeg|png|gif|webp)$',
                      caseSensitive: false,
                    );
                    if (!urlPattern.hasMatch(value)) {
                      return "URL harus berupa link gambar yang valid (jpg, jpeg, png, gif, webp)!";
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
                    if (value.length < 3) {
                      return "Kategori minimal 3 karakter!";
                    }
                    if (value.length > 50) {
                      return "Kategori maksimal 50 karakter!";
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Produk Berhasil Disimpan'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Nama: $_name'),
                                    const SizedBox(height: 8),
                                    Text('Brand: $_brand'),
                                    const SizedBox(height: 8),
                                    Text('Jenis Produk: $_jenisProduct'),
                                    const SizedBox(height: 8),
                                    Text('Harga: Rp $_price'),
                                    const SizedBox(height: 8),
                                    Text('Deskripsi: $_description'),
                                    const SizedBox(height: 8),
                                    Text('Thumbnail: $_thumbnail'),
                                    const SizedBox(height: 8),
                                    Text('Kategori: $_category'),
                                    const SizedBox(height: 8),
                                    Text('Produk Unggulan: ${_isFeatured ? "Ya" : "Tidak"}'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _formKey.currentState!.reset();
                                    setState(() {
                                      _name = "";
                                      _price = 0;
                                      _description = "";
                                      _thumbnail = "";
                                      _brand = "";
                                      _category = "";
                                      _jenisProduct = null;
                                      _isFeatured = false;
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
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